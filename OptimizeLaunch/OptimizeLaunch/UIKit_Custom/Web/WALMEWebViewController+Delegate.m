//
//  WALMEWebViewController+Delegate.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEWebViewController+Delegate.h"

@implementation WALMEWebViewController (Delegate)
#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"handleMessage"]) {
        self.funcData = message.body;
        [self handleMessage];
    }
}

#pragma mark - WKUIDelegate

//- (void)webViewDidClose:(WKWebView *)webView {
////    NSLog(@"%s ", __FUNCTION__);
//}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    completionHandler();
}

//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(BOOL))completionHandler {
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"confirm" message:@"JS调用confirm" preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(YES);
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(NO);
//    }]];
//    [self presentViewController:alert animated:YES completion:NULL];
////    NSLog(@"%@", message);
//}

//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(nonnull NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(NSString * _Nullable))completionHandler {
//    NSLog(@"%s", __FUNCTION__);
//
//    NSLog(@"%@", prompt);
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.textColor = [UIColor redColor];
//    }];
//
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler([[alert.textFields lastObject] text]);
//    }]];
//
//    [self presentViewController:alert animated:YES completion:NULL];
//}

#pragma mark - WKNavigationDelegate
// 请求开始前，会先调用此代理方法
// 与UIWebView的
// - (BOOL)webView:(UIWebView *)webView
// shouldStartLoadWithRequest:(NSURLRequest *)request
// navigationType:(UIWebViewNavigationType)navigationType;
// 类型，在请求先判断能不能跳转（请求）
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *hostname = navigationAction.request.URL.host.lowercaseString;
    NSURL * url = navigationAction.request.URL;
    // 第3步:当用户点击素材时，须调用点击事件上报接口，同样clickUrl来自于上面返回 的model中
    SEL callbackFunc = NSSelectorFromString(@"reportTATClickURL:");
    if ([self respondsToSelector:callbackFunc]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:callbackFunc withObject:url.absoluteString];
#pragma clang diagnostic pop
    }
    if (url != nil &&
        url.absoluteString != nil &&
        ([url.absoluteString containsString:@"//itunes.apple.com/"] || [url.absoluteString containsString:@"//apps.apple.com/"]) &&
        [[UIApplication sharedApplication] openURL:url]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated
        && ![hostname containsString:@".baidu.com"]) {
        // 对于跨域，需要手动跳转
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        //        self.progressView.alpha = 1.0;
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    //    NSLog(@"%s", __FUNCTION__);
}

// 在响应完成时，会回调此方法
// 如果设置为不允许响应，web内容就不会传过来
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(nonnull WKNavigationResponse *)navigationResponse decisionHandler:(nonnull void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
    //    NSLog(@"%s", __FUNCTION__);
}

//// 开始导航跳转时会回调
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"%s", __FUNCTION__);
//}
//
//// 接收到重定向时会回调
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"%s", __FUNCTION__);
//}
//
//// 导航失败时会回调
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"%s", __FUNCTION__);
//}
//
//// 页面内容到达main frame时回调
//- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"%s", __FUNCTION__);
//}
//
//// 导航完成时，会回调（也就是页面载入完成了）
//- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"%s", __FUNCTION__);
//}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (error.code == NSURLErrorCancelled) {
        return;
    }
}

// 对于HTTPS的都会触发此代理，如果不要求验证，传默认就行
// 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    //    NSLog(@"%s", __FUNCTION__);
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

//// 9.0才能使用，web内容处理中断时会触发
//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
//    NSLog(@"%s", __FUNCTION__);
//}

@end
