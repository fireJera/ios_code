//
//  UIViewController+WALME_Custom.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "UIViewController+WALME_Custom.h"
#import <objc/runtime.h>
#import "UINavigationController+WALME_Custom.h"
//#import "AppDelegate.h"
#import "WALMEControllerHeader.h"
#import "CodeFrameDefineCode.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "WALMEAliLog.h"

#if __has_include (<Lottie/Lottie.h>)
#import <Lottie/Lottie.h>
#endif

@implementation UIViewController (WALME_Custom)

//+ (void)load {
//    SEL originSel = @selector(viewWillAppear:);
//    SEL swizzleSel = @selector(walme_viewWillAppear:);
//
//    Method originMethod = class_getInstanceMethod(self, originSel);
//    Method swizzleMethod = class_getInstanceMethod(self, swizzleSel);
//
//    BOOL didAddMethod = class_addMethod(self, originSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
//    if (didAddMethod) {
//        class_replaceMethod(self, swizzleSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
//    } else {
//        method_exchangeImplementations(originMethod, swizzleMethod);
//    }
//}
//
//- (void)walme_viewWillAppear:(BOOL)animated {
//    [self walme_viewWillAppear:animated];
//    NSMutableDictionary<NSString *, NSString *> * dic = [NSMutableDictionary dictionary];
//    NSString * module = NSStringFromClass(self.class);
//    [dic setValue:module forKey:@"module"];
//    [dic setValue:@"viewWillAppear" forKey:@"aciton"];
////    WALMEAliLog * aliLog = [[WALMEAliLog alloc] initWithEndPoint:@"" keyID:@"" keySecret:@""];
//    WALMEAliLog * aliLog = [[WALMEAliLog alloc] init];
//    [aliLog putKesAndValues:dic toTopic:@"" toSource:@""];
//}

- (void)setNavBarBgAlpha:(CGFloat)navBarBgAlpha {
    CGFloat tempAlpha = MAX(0, navBarBgAlpha);
    tempAlpha = MIN(1, navBarBgAlpha);
    NSString * alphaString = [NSString stringWithFormat:@"%f", tempAlpha];
    [self.navigationController setNeedsNavigationBackground:tempAlpha];
    [self setNavBarAlpha:alphaString];
}

- (CGFloat)navBarBgAlpha {
    NSString * str = [self navBarAlpha];
    if (str) {
        return [str floatValue];
    }
    return 1.0;
}

- (void)setNavBarAlpha:(NSString *)alpha {
    objc_setAssociatedObject(self, @selector(navBarAlpha), alpha, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)navBarAlpha {
    return objc_getAssociatedObject(self, @selector(navBarAlpha));
}

- (void)setNavBarTintColor:(UIColor *)navBarTintColor {
    self.navigationController.navigationBar.tintColor = navBarTintColor;
    self.navigationController.navigationBar.barTintColor = navBarTintColor;
    objc_setAssociatedObject(self, @selector(navBarTintColor), navBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)navBarTintColor {
    UIColor * color = objc_getAssociatedObject(self, @selector(navBarTintColor));
    if (!color) {
        color = [UIColor whiteColor];
    }
    return color;
}

- (void)setNavBarTitleColor:(UIColor *)navBarTitleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: navBarTitleColor}];
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setLargeTitleTextAttributes:@{NSForegroundColorAttributeName: navBarTitleColor}];
    }
    objc_setAssociatedObject(self, @selector(navBarTitleColor), navBarTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)navBarTitleColor {
    UIColor * color = objc_getAssociatedObject(self, @selector(navBarTitleColor));
    if (!color) {
        color = [UIColor whiteColor];
    }
    return color;
}

- (instancetype)initFromNib {
    NSString * nib = NSStringFromClass([self class]);
    return [self initWithNibName:nib bundle:nil];
}

- (instancetype)initWithDataSource:(id<WALMEViewControllerInfoDataSource>)dataSource {
    return [self init];
}

- (void)walme_setNavView {
    self.navBarBgAlpha = 0;
    self.navBarTintColor = [UIColor whiteColor];
    //walme_my_9
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowleft_24_black_2_round"] style:UIBarButtonItemStylePlain target:self action:@selector(walme_close)];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

//- (void)walme_setView {
//    self.navBarBgAlpha = 0;
//    self.navBarTintColor = [UIColor whiteColor];
//    //walme_my_9
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowleft_24_black_2_round"] style:UIBarButtonItemStylePlain target:self action:@selector(walme_close)];
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
//}

- (void)walme_close {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setBlankView:(WALMEBlankView *)blankView {
    if (!blankView) objc_setAssociatedObject(self, @selector(blankView), blankView, OBJC_ASSOCIATION_RETAIN);
}

- (WALMEBlankView *)blankView {
    WALMEBlankView * view = (WALMEBlankView *)objc_getAssociatedObject(self, @selector(blankView));
    if (!view) {
        view = [[WALMEBlankView alloc] init];
        view.blankType = WALMEBlankViewTypeBlank;
        objc_setAssociatedObject(self, @selector(blankView), view, OBJC_ASSOCIATION_RETAIN);
    }
    return view;
}

@end


#pragma mark - Alert
NSString * const WALMEAlertCancelTitle = @"取消";
NSString * const WALMEAlertSureTitle = @"确定";

@implementation UIViewController (WALMEAlert)

/**
 只有一个确定的提示框
 
 @param title 标题
 @param message 提示
 */
- (void)showSureActionAlert:(nullable NSString *)title message:(nullable NSString *)message {
    [self showAlert:title message:message buttons:@[WALMEAlertSureTitle] handler:nil otherhandler:nil];
}

/**
 只有一个确定的提示框
 
 @param title 标题
 @param handler 回调
 */
- (void)showSureActionAlert:(nullable NSString *)title handler:(nullable void(^)(void))handler {
    [self showAlert:title message:nil buttons:@[WALMEAlertSureTitle] handler:handler otherhandler:nil];
}

/**
 button为空时自动补为确定
 
 @param title 标题
 @param message 提示
 @param button button文字
 */
- (void)showSureActionAlert:(nullable NSString *)title message:(nullable NSString *)message button:(nullable NSString *)button {
    [self showAlert:title message:nil buttons:button ? @[button] : @[WALMEAlertSureTitle] handler:nil otherhandler:nil];
}
- (void)showOneActionAlert:(NSString *)title
               buttonTitle:(NSString *)buttonTitle
                   handler:(void (^)(void))handler {
    [self showAlert:title message:nil buttons:buttonTitle ? @[buttonTitle] : @[WALMEAlertSureTitle] handler:handler otherhandler:nil];
}

/**
 带取消的提示框 没有message
 
 @param title 标题
 @param ackTitle 右边按钮内容
 @param handler 回调
 */
- (void)showAlertWithCancel:(nullable NSString *)title ackTitle:(nullable NSString *)ackTitle ackHandler:(nullable void (^)(void))handler {
    [self showAlert:title message:nil buttons:ackTitle ? @[WALMEAlertCancelTitle, ackTitle] : @[WALMEAlertCancelTitle, WALMEAlertSureTitle] handler:nil otherhandler:handler];
}

/**
 带取消的提示框
 
 @param title 标题
 @param message 提示
 @param ackTitle 右边按钮内容
 @param handler 回调
 */
- (void)showAlertWithCancel:(nullable NSString *)title message:(nullable NSString *)message ackTitle:(nullable NSString *)ackTitle ackHandler:(nullable void (^)(void))handler {
    [self showAlert:title message:message buttons:ackTitle ? @[WALMEAlertCancelTitle, ackTitle] : @[WALMEAlertCancelTitle, WALMEAlertSureTitle] handler:nil otherhandler:handler];
}


/**
 提示框 没有message
 
 @param title 标题
 @param buttons 两个按钮的内容
 @param handler 回调1
 @param otherhandler 回调2
 */
- (void)showAlert:(nullable NSString *)title buttons:(nullable NSArray<NSString *> *)buttons handler:(nullable void(^)(void))handler otherhandler:(nullable void(^)(void))otherhandler {
    [self showAlert:title message:nil buttons:buttons handler:handler otherhandler:otherhandler];
}


/**
 完全自定义提示框
 
 @param title 标题
 @param message 提示
 @param buttons 两个按钮的文字
 @param handler 回调1
 @param otherhandler 回调2
 */
- (void)showAlert:(nullable NSString *)title message:(nullable NSString *)message buttons:(nullable NSArray<NSString *> *)buttons handler:(nullable void(^)(void))handler otherhandler:(nullable void(^)(void))otherhandler {
    if (!buttons || buttons.count == 0) return;
    UIAlertController * _Nonnull alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:buttons.firstObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }]];
    if (buttons.count > 1) {
        [alert addAction:[UIAlertAction actionWithTitle:buttons[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (otherhandler) {
                otherhandler();
            }
        }]];
    }
    
    //    if (WALME_IS_IPAD) {
    //        UIPopoverPresentationController * popPresenter = [alert popoverPresentationController];
    //        popPresenter.sourceView = WALMEINSTANCE_KEYWINDOW;
    //        popPresenter.sourceRect = CGRectMake(0 / 2, 0 / 2, 0, 0);
    //        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
    //        [self presentViewController:alert animated:YES completion:nil];
    //    } else {
    [self presentViewController:alert animated:YES completion:nil];
    //    }
}

- (void)showAlert:(NSString *)title
          message:(NSString *)message
          buttons:(NSArray<NSString *> *)buttons
         handlers:(NSArray<void (^)(void)> *)handlers {
    if (buttons.count == 0 || !buttons) return;
    UIAlertController * _Nonnull alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [buttons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alert addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            WALMEVoidBlock handler = handlers[idx];
            if (handler) {
                handler();
            }
        }]];
    }];
    
    //    if (WALME_IS_IPAD) {
    //        UIPopoverPresentationController * popPresenter = [alert popoverPresentationController];
    //        popPresenter.sourceView = WALMEINSTANCE_KEYWINDOW;
    //        popPresenter.sourceRect = CGRectMake(0 / 2, 0 / 2, 0, 0);
    //        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
    //        [self presentViewController:alert animated:YES completion:nil];
    //    } else {
    [self presentViewController:alert animated:YES completion:nil];
    //    }
}

/**
 带文字输入框提示框 左边取消
 
 @param title 标题
 @param message 提示
 @param placeholder 默认文字
 @param button 右边按钮
 @param method 输入框文字改变回调
 @param handler 右边按钮点击回调
 */

- (void)showInputAlert:(nullable NSString *)title
               message:(nullable NSString *)message
           placeholder:(nullable NSString *)placeholder
                button:(nullable NSString *)button
              selector:(nullable SEL)method
               handler:(nullable void (^)(NSString * _Nullable))handler {
    [self showInputAlert:title
                 message:message
               fieldText:nil
             placeholder:placeholder
                  button:button
                selector:method
                  target:self
                 handler:handler];
}

- (void)showInputAlert:(nullable NSString *)title
               message:(nullable NSString *)message
             fieldText:(nullable NSString *)text
           placeholder:(nullable NSString *)placeholder
                button:(nullable NSString *)button
              selector:(SEL)method
               handler:(nullable void (^)(NSString *))handler {
    [self showInputAlert:title
                 message:message
               fieldText:text
             placeholder:placeholder
                  button:button
                selector:method
                  target:self
                 handler:handler];
}

- (void)showInputAlert:(NSString *)title
               message:(nullable NSString *)message
             fieldText:(nullable NSString *)text
           placeholder:(nullable NSString *)placeholder
                button:(nullable NSString *)button
              selector:(nullable SEL)method
                target:(nullable id)target
               handler:(nullable void (^)(NSString * _Nullable))handler {
    UIAlertController * _Nonnull alert =  [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        NSLayoutConstraint*  heightConstraint = [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant: 24];
        [textField addConstraint:heightConstraint];
        textField.placeholder = placeholder;
        if (text) {
            textField.text = text;
        }
        if (target && method) {
            [[NSNotificationCenter defaultCenter] addObserver:target selector:method name:UITextFieldTextDidChangeNotification object:textField];
        }
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:WALMEAlertCancelTitle style:UIAlertActionStyleDefault handler:nil]];
    
    if (button) {
        [alert addAction:[UIAlertAction actionWithTitle:button style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textfield = alert.textFields.firstObject;
            if (handler) {
                handler(textfield.text);
            }
        }]];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showActionSheet:(nullable NSString *)title handler:(void(^)(void))handler {
    if (title) [self showActionSheet:@[title] handler:handler otherhandler:nil];
}

- (void)showActionSheet:(nullable NSArray<NSString *> *)titles handler:(nullable void(^)(void))handler otherhandler:(nullable void(^)(void))otherhandler {
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (!titles || titles.count == 0) return;
    [alert addAction:[UIAlertAction actionWithTitle:titles.firstObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }]];
    if (titles.count > 1) {
        [alert addAction:[UIAlertAction actionWithTitle:titles[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (otherhandler) {
                otherhandler();
            }
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    //    if (WALME_IS_IPAD) {
    //        UIPopoverPresentationController * popPresenter = [alert popoverPresentationController];
    //        popPresenter.sourceView = WALMEINSTANCE_KEYWINDOW;
    //        popPresenter.sourceRect = CGRectMake(0 / 2, 0 / 2, 0, 0);
    //        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
    //        [self presentViewController:alert animated:YES completion:nil];
    //    } else {
    [self presentViewController:alert animated:YES completion:nil];
    //    }
}

- (void)showThreeActionSheet:(nullable NSArray<NSString *> *)titles handler:(nullable void(^)(void))handler secondhandler:(nullable void(^)(void))secondhandler thirdhandler:(nullable void(^)(void))thirdhandler {
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (!titles || titles.count == 0) return;
    [alert addAction:[UIAlertAction actionWithTitle:titles.firstObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }]];
    if (titles.count > 1) {
        [alert addAction:[UIAlertAction actionWithTitle:titles[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (secondhandler) {
                secondhandler();
            }
        }]];
    }
    
    if (titles.count > 2) {
        [alert addAction:[UIAlertAction actionWithTitle:titles[2] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (thirdhandler) {
                thirdhandler();
            }
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    //    if (WALME_IS_IPAD) {
    //        UIPopoverPresentationController * popPresenter = [alert popoverPresentationController];
    //        popPresenter.sourceView = WALMEINSTANCE_KEYWINDOW;
    //        popPresenter.sourceRect = CGRectMake(0 / 2, 0 / 2, 0, 0);
    //        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
    //        [self presentViewController:alert animated:YES completion:nil];
    //    } else {
    [self presentViewController:alert animated:YES completion:nil];
    //    }
}

@end

@implementation UIViewController (WALME_ScreenShot)

- (UIImage *)screenShot {
    CGSize imageSize = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow * window in [UIApplication sharedApplication].windows) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x,  -window.bounds.size.height * window.layer.anchorPoint.y);
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
        } else {
            [window.layer renderInContext:UIGraphicsGetCurrentContext()];
        }
        CGContextRestoreGState(context);
    }
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation UIViewController (WALME_UploadProgress)

- (void)hideNavShadowLine {
    UIView * navBar = self.navigationController.navigationBar;
    if (navBar) {
        [self hideLine:navBar];
    }
}

- (void)hideLine:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        view.hidden = YES;
    } else {
        for (UIView *subview in view.subviews) {
            [self hideLine:subview];
        }
    }
}

@end

@implementation UIViewController (WALME_nav)

- (UIViewController *)lastViewControllerInNav {
    UINavigationController * nav;
    if ([self isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)self;
    } else {
        nav = self.navigationController;
    }
    if (!nav) return nil;
    NSUInteger count = nav.viewControllers.count;
    return nav.viewControllers[count - 2];
}

- (UIViewController *)rootViewControllerInNav {
    UINavigationController * nav;
    if ([self isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)self;
    } else {
        nav = self.navigationController;
    }
    if (!nav) return nil;
    return nav.viewControllers.firstObject;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzlingOriginSel:@selector(viewDidAppear:) forSwizzleSel:@selector(walme_viewDidAppear:)];
    });
}

+ (void)swizzlingOriginSel:(SEL)originSel forSwizzleSel:(SEL)swizzleSel {
    Class selfClass = [self class];
    Method originMethod = class_getInstanceMethod(selfClass, originSel);
    Method swizzleMethod = class_getInstanceMethod(selfClass, swizzleSel);
    BOOL didAdd = class_addMethod(selfClass, originSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (didAdd) {
        class_replaceMethod(selfClass, swizzleSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }
    else {
        method_exchangeImplementations(originMethod, swizzleMethod);
    }
}

- (void)walme_viewDidAppear:(BOOL)animated {
    [self walme_viewDidAppear:animated];
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    SEL selector = NSSelectorFromString(@"walme_swizzleViewDidAppear:");
    if ([delegate respondsToSelector:selector]) {
        ((void(*)(id, SEL, UIViewController *))(void *)objc_msgSend)(delegate, selector, self);
    }
}

@end
