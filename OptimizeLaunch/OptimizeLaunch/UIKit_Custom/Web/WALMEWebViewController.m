//
//  WALMEWebViewController.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEWebViewController.h"
#import <WebKit/WebKit.h>
#import "WALMEControllerHeader.h"
#import "WALMEWebViewController+Delegate.h"
#import "NSDictionary+WALME_Custom.h"
#import "WALMEViewmodelHeader.h"
#import "UIViewController+WALME_Custom.h"

#if DEBUG
static NSString * const WALMEWebUrlHost = @"https://newdev-api.imdsk.com/";
#else
static NSString * const WALMEWebUrlHost = @"https://api.ichat001.com/";
//api.ichat001.com
#endif

@interface WALMEWebViewController () {
    NSString * _leftFunc;
    NSString * _rightFunc;
}

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WALMEWebViewController * preController;
//@property (nonatomic, strong) UIProgressView * progressView;

@end

@implementation WALMEWebViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    if (self.navigationController.navigationBar.hidden) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"handleMessage"];
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"handleMessage"];
    [_webView.configuration.userContentController addScriptMessageHandler:self name:@"handleMessage"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_walme_navView];
    [self p_walme_setWebView];
    //    [self p_walme_setProgressView];
}

- (void)p_walme_navView {
    [self walme_setNavView];
    self.navBarBgAlpha = 1;
    if (_navColor) {
        self.navBarTintColor = _navColor;
//        [UIColor navBarGradientColor];
    }
    self.navBarTitleColor = [UIColor blackColor];
}
// 重写分类的返回方法
- (void)walme_close {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)p_walme_close {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)p_walme_setWebView {
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    config.preferences = [[WKPreferences alloc] init];                              //设置偏好设置
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
//    if (WALMEIOSFLoatSystemVersion < 11.0) {
//        _webView.frame = CGRectMake(0, 64, _webView.width, _webView.height - 64);
//    }
    [self.view addSubview:_webView];
    
    NSURLRequest * request;
    if (_urlString) {
        NSString * suffixStr = [[WALMENetWorkManager walme_urlStringSuffix:NO] URLEncode];
        if ([_urlString containsString:@"?"]) {
            _urlString = [NSString stringWithFormat:@"%@&token=%@&_ua=%@", _urlString, WALMEINSTANCE_USER.token, suffixStr];
        } else {
            _urlString = [NSString stringWithFormat:@"%@?token=%@&_ua=%@", _urlString, WALMEINSTANCE_USER.token, suffixStr];
        }
        if (![_urlString hasPrefix:@"http"]) {
            _urlString = [NSString stringWithFormat:@"%@%@", WALMEWebUrlHost, _urlString];
        }
        request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_urlString]];
//        [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_urlString]]];
    } else {
        request = [[NSURLRequest alloc] initWithURL:_url];
//        [_webView loadRequest:[[NSURLRequest alloc] initWithURL:_url]];
    }
//    printf("%s", [request.URL.absoluteString UTF8String]);
//    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:webURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15.0];
    [_webView loadRequest:request];
    
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
}


//- (void)p_walme_setProgressView {
//    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 2)];
//    _progressView.progressTintColor = [UIColor greenColor];
//    [self.view addSubview:_progressView];
//}

#pragma mark - observer

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"loading"]) {
        //        NSLog(@"loading");
    } else if ([keyPath isEqualToString:@"title"]) {
        if (object == _webView) {
            self.title = _webView.title;
        } else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    //    else if ([keyPath isEqualToString:@"estimatedProgress"]) {
    //        _progressView.progress = self.webView.estimatedProgress;
    //    }
    //    // 加载完成
    //    if (!_webView.loading) {
    //        [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
    //            [self.progressView setAlpha:0.0f];
    //        } completion:^(BOOL finished) {
    //            [self.progressView setProgress:0.0f animated:YES];
    //        }];
    //    }
}


- (void)handleMessage {
    NSString * funcStr = _funcData[@"funcName"];
    SEL selector = NSSelectorFromString(funcStr);
    if (![self respondsToSelector:selector]) {
        return;
    }
    IMP imp = [self methodForSelector:selector];
    void (*func)(id, SEL) = (void *)imp;
    func(self, selector);
}

- (void)showConfirm {
    NSDictionary * dic = _funcData[@"funcData"];
//    if (IsDictionaryWithItems(dic)) {
//        NSString * str = dic[@"msg"];
//        NSString * enterFunc = dic[@"enterFunc"];
//        NSString * enterText = SAFESTRING(dic[@"enterLabel"]);
//        NSString * cancelFunc = dic[@"cancelFunc"];
//        NSString * cancelText = SAFESTRING(dic[@"cancelLabel"]);
//        NSMutableArray * array = [NSMutableArray arrayWithCapacity:2];
//        if (cancelText.length > 0) {
//            [array addObject:cancelText];
//        } else {
//            [array addObject:@"取消"];
//        }
//        if (enterText.length > 0) {
//            [array addObject:enterText];
//        } else {
//            [array addObject:@"确定"];
//        }
//
//        [self showAlert:str buttons:array handler:^{
//            [self p_walme_evaluateJavaScript:cancelFunc];
//        } otherhandler:^{
//            [self p_walme_evaluateJavaScript:enterFunc];
//        }];
//    }
}

- (void)p_walme_callback {
    if (_funcData) {
//        if (IsDictionaryWithItems(_funcData)) {
//            WALMENetCallback * callback = [[WALMENetCallback alloc] init];
//            callback.walme_deal(_funcData);
//        }
    }
}

- (void)showLoader {
//    _hud = [self.navigationController.view customProgressHUDTitle:nil];
}

- (void)close {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideLoader {
    
}

- (void)ajaxRequest {
    NSDictionary * dic = _funcData[@"funcData"];
//    if (IsDictionaryWithItems(dic)) {
//        NSString * url = SAFESTRING(dic[@"url"]);
//        NSString * successFunc = dic[@"successFunc"];
//        NSString * failFunc = dic[@"errorFunc"];
//        NSDictionary * parameters = dic[@"postData"];
//        //        NSString * urlString = [NSString stringWithFormat:@"%@?token=%@", url, WALMEINSTANCE_USER.token];
//        MBProgressHUD * hud;
////        hud = [self.navigationController.view customProgressHUDTitle:nil];
//        [WALMENetWorkManager walme_post:url withParameters:parameters success:^(id result) {
//            NSMutableString * jsStr;
//            NSString * str = @"";
//            str = [(NSDictionary *)result convertToJSONStr];
//            str = [NSString stringWithFormat:@",%@", str];
//            jsStr = [NSMutableString stringWithString:successFunc];
//            
//            [jsStr insertString:str atIndex:jsStr.length - 1];
//            [self p_walme_evaluateJavaScript:jsStr];
//            dispatch_async(dispatch_get_main_queue(), ^{
////                [hud hideAnimated:YES];
//            });
//        } failed:^(BOOL netReachable, NSString *msg, id result) {
//            NSMutableString * jsStr;
//            NSString * str = @"";
//            if (result) {
//                str = [(NSDictionary *)result convertToJSONStr];
//                str = [NSString stringWithFormat:@",%@", str];
//            }
//            jsStr = [NSMutableString stringWithString:failFunc];
//            [jsStr insertString:str atIndex:jsStr.length - 1];
//            [self p_walme_evaluateJavaScript:jsStr];
//            dispatch_async(dispatch_get_main_queue(), ^{
////                [hud hideAnimated:YES];
//            });
//        }];
//    }
}

- (void)refresh {
    [_webView reload];
}

- (void)open {
    NSDictionary * dic = _funcData[@"funcData"];
//    if (IsDictionaryWithItems(dic)) {
//        BOOL shoudlClose = [dic[@"closeCurrent"] intValue];
//
//        if (shoudlClose) {
//            NSString * closeFunc = dic[@"closeFunc"];
//            [self p_walme_evaluateJavaScript:closeFunc];
//            [self.navigationController popViewControllerAnimated:NO];
//        }
//        [self p_walme_callback];
//    }
}

- (void)showTips {
    [self p_walme_callback];
}

- (void)showAlert {
    NSDictionary * dic = _funcData[@"funcData"];
//    if (IsDictionaryWithItems(dic)) {
//        NSString * str = SAFESTRING(dic[@"msg"]);
//        NSString * jsFunc = dic[@"enterFunc"];
//        NSString * enterText = SAFESTRING(dic[@"enterLabel"]);
//        if (enterText.length == 0) {
//            enterText = nil;
//        }
//        [self showOneActionAlert:str buttonTitle:enterText handler:^{
//            [self p_walme_evaluateJavaScript:jsFunc];
//        }];
//    }
}

//当前页跳转
- (void)jump {
    NSDictionary * dic = _funcData[@"funcData"];
//    if (IsDictionaryWithItems(dic)) {
//        NSString * urlStr = dic[@"pageData"][@"url"];
//        if (urlStr) {
//            _urlString = urlStr;
//            NSString * suffixStr = [[WALMENetWorkManager walme_urlStringSuffix:NO] URLEncode];
//            if ([_urlString containsString:@"?"]) {
//                _urlString = [NSString stringWithFormat:@"%@&token=%@&_ua=%@", _urlString, WALMEINSTANCE_USER.token, suffixStr];
//            } else {
//                _urlString = [NSString stringWithFormat:@"%@?token=%@&_ua=%@", _urlString, WALMEINSTANCE_USER.token, suffixStr];
//            }
//
//            [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_urlString]]];
//        }
//    }
}

- (void)enablePopGes {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)disablePopGes {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)setRightButton {
    NSDictionary * dic = _funcData[@"funcData"];
//    if (IsDictionaryWithItems(dic)) {
//        int show = [dic[@"display"] intValue];
//        _rightFunc = dic[@"buttonFunc"];
//        NSString * content = dic[@"text"];
//        if (show) {
//            if (show == 1) {//text
//                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:content style:UIBarButtonItemStylePlain target:self action:@selector(p_walme_navRight:)];
//            } else if (show == 2) {//image
//                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:content] style:UIBarButtonItemStylePlain target:self action:@selector(p_walme_navRight:)];
//            }
//        }
//    }
}

- (void)setLeftButton {
    NSDictionary * dic = _funcData[@"funcData"];
//    if (IsDictionaryWithItems(dic)) {
//        int show = [dic[@"display"] intValue];
//        _leftFunc = dic[@"buttonFunc"];
//        NSString * content = dic[@"text"];
//        if (show == 1) {//text
//            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:content style:UIBarButtonItemStylePlain target:self action:@selector(p_walme_navLeft:)];
//        } else if (show == 2) {//image
//            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:content] style:UIBarButtonItemStylePlain target:self action:@selector(p_walme_navLeft:)];
//        }
//    }
}

- (void)setSlideBack {
    NSDictionary * dic = _funcData[@"funcData"];
//    if (IsDictionaryWithItems(dic)) {
//        BOOL allow = [dic[@"allow"] intValue];
//        if (!allow) {
//            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//        }
//    }
}

- (void)p_walme_navLeft:(UIBarButtonItem *)sender {
    if (_leftFunc) {
        [self p_walme_evaluateJavaScript:_leftFunc];
    }
}

- (void)p_walme_navRight:(UIBarButtonItem *)sender {
    
}

- (void)p_walme_evaluateJavaScript:(NSString *)jsStr {
    [_webView evaluateJavaScript:jsStr completionHandler:^(id result, NSError *error) {
        if (error == nil) {
            if (result != nil) {
                //                NSLog(@"resultString : %@", result);
            }
        } else {
            //            NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_webView removeObserver:self forKeyPath:@"loading"];
    [_webView removeObserver:self forKeyPath:@"title"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end

