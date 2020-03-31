    //
//  UINavigationController+WALME_Custom.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "UINavigationController+WALME_Custom.h"
#import <objc/runtime.h>
#import "UIViewController+WALME_Custom.h"
#import <WebKit/WebKit.h>

@implementation UINavigationController (WALME_Custom)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzlingOriginSel:@selector(_updateInteractiveTransition:) forSwizzleSel:@selector(JER_updateInteractiveTransition:)];
        [self swizzlingOriginSel:@selector(popToViewController:animated:) forSwizzleSel:@selector(JER_popToViewController:animated:)];
        [self swizzlingOriginSel:@selector(popToRootViewControllerAnimated:) forSwizzleSel:@selector(JER_popToRootViewControllerAnimated:)];
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

- (nullable NSArray<__kindof UIViewController *> *)JER_popToRootViewControllerAnimated:(BOOL)animated {
    self.navigationBar.tintColor = self.viewControllers.firstObject.navBarTintColor;
    self.navigationBar.barTintColor = self.viewControllers.firstObject.navBarTintColor;
    [self setNeedsNavigationBackground:self.viewControllers.firstObject.navBarBgAlpha];
    return [self JER_popToRootViewControllerAnimated:animated];
}

- (nullable UIViewController *)JER_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.navigationBar.tintColor = viewController.navBarTintColor;
    self.navigationBar.barTintColor = viewController.navBarTintColor;
    [self setNeedsNavigationBackground:viewController.navBarBgAlpha];
    return [self JER_popToViewController:viewController animated:animated];
}

- (void)JER_updateInteractiveTransition:(CGFloat)percentComplete {
    UIViewController * topViewController = self.topViewController;
    if (!topViewController) {
        [self JER_updateInteractiveTransition:percentComplete];
        return;
    }
    id <UIViewControllerTransitionCoordinator> coordinator = topViewController.transitionCoordinator;
    if (!coordinator) {
        [self JER_updateInteractiveTransition:percentComplete];
        return;
    }
    UIViewController * toViewController = [coordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController * fromViewController = [coordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGFloat toAlpha = toViewController.navBarBgAlpha;
    CGFloat fromAlpha = fromViewController.navBarBgAlpha;
    CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete;
    [self setNeedsNavigationBackground:newAlpha];
    
    UIColor * toColor = topViewController.navBarTintColor;
    UIColor * fromColor = fromViewController.navBarTintColor;
    UIColor * newColor = [self p_walme_averageColor:fromColor toColor:toColor percent:percentComplete];
    self.navigationBar.tintColor = newColor;
    self.navigationBar.barTintColor = newColor;
    [self JER_updateInteractiveTransition:percentComplete];
}

- (UIColor *)p_walme_averageColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent {
    CGFloat toAlpha = 0;
    CGFloat toBlue = 0;
    CGFloat toGreen = 0;
    CGFloat toRed = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat fromAlpha = 0;
    CGFloat fromBlue = 0;
    CGFloat fromGreen = 0;
    CGFloat fromRed = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha) * percent;;
    CGFloat newGreen = fromGreen + (toGreen - fromGreen) * percent;;
    CGFloat newBlue = fromBlue + (toBlue - fromBlue) * percent;;
    CGFloat newRed = fromRed + (toRed - fromRed) * percent;
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}

- (void)setNeedsNavigationBackground:(CGFloat)alpha {
    UIView * barBackgroundView = self.navigationBar.subviews.firstObject;
    if (1) {
        barBackgroundView.alpha = alpha;
    } else {
        UIView * shadowFace = [barBackgroundView valueForKey:@"_shadowView"];
        if (shadowFace) {
            shadowFace.alpha = alpha;
            shadowFace.hidden = alpha == 0;
        }
        if (self.navigationBar.translucent) {
            if (@available(iOS 10.0, *)) {
                UIView * bgEffectView = [barBackgroundView valueForKey:@"_backgroundEffectView"];
                if (bgEffectView) {
                    UIImage * image = [self.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
                    if (!image) {
                        bgEffectView.alpha = alpha;
                        return;
                    }
                }
            } else {
                UIView * adaptiveBackdrop = [barBackgroundView valueForKey:@"_adaptiveBackdrop"];
                if (adaptiveBackdrop) {
                    UIView * backdropEffectView = [adaptiveBackdrop valueForKey:@"_backdropEffectView"];
                    if (backdropEffectView) {
                        backdropEffectView.alpha = alpha;
                    }
                }
            }
        }
        barBackgroundView.alpha = alpha;
    }
}

@end

@implementation UINavigationController (JER_NavBarDelegate)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    UIViewController * topVC = self.topViewController;
    if (topVC) {
        id<UIViewControllerTransitionCoordinator> coor = topVC.transitionCoordinator;
        if (coor.initiallyInteractive) {
            if (@available(iOS 10.0, *)) {
                [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    [self p_walme_dealIntercationChanges:context];
                }];
            } else {
                [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    [self p_walme_dealIntercationChanges:context];
                }];
            }
            return YES;
        }
        else {
            UIViewController * toViewController = [coor viewControllerForKey:UITransitionContextToViewControllerKey];
            [self setNeedsNavigationBackground:toViewController.navBarBgAlpha];
            self.navigationBar.tintColor = toViewController.navBarTintColor;
            self.navigationBar.barTintColor = toViewController.navBarTintColor;
        }
    }
    if (self.viewControllers.count > 1) {
        Class cls = NSClassFromString(@"TATBaseWebViewController");
        if ([topVC isKindOfClass:cls]) {
            WKWebView * web = [topVC valueForKey:@"_webView"];
            if ([web isKindOfClass:[WKWebView class]]) {
                if ([web canGoBack]) {
                    [web goBack];
                    return NO;
                }
            }
            NSLog(@"isisKindOfClass : TATBaseWebViewController");
        }
        return YES;
    }
    return NO;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    [self setNeedsNavigationBackground:self.topViewController.navBarBgAlpha];
    self.navigationBar.tintColor = self.topViewController.navBarTintColor;
    self.navigationBar.barTintColor = self.topViewController.navBarTintColor;
    return YES;
}

- (void)p_walme_dealIntercationChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    void(^animationBlock)(UITransitionContextViewControllerKey) = ^(UITransitionContextViewControllerKey key){
        CGFloat nowAlpha = [context viewControllerForKey:key].navBarBgAlpha;
        [self setNeedsNavigationBackground:nowAlpha];
        self.navigationBar.tintColor = [context viewControllerForKey:key].navBarTintColor;
        self.navigationBar.barTintColor = [context viewControllerForKey:key].navBarTintColor;
    };
    if (context.isCancelled) {
        NSTimeInterval cancelDuration = context.transitionDuration * (double)(context.percentComplete);
        [UIView animateWithDuration:cancelDuration animations:^{
            animationBlock(UITransitionContextFromViewControllerKey);
        }];
    } else {
        NSTimeInterval finishDuration = context.transitionDuration * (double)(1 - context.percentComplete);
        [UIView animateWithDuration:finishDuration animations:^{
            animationBlock(UITransitionContextToViewControllerKey);
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIStatusBarStyle style = self.topViewController.preferredStatusBarStyle;
    if (!style) {
        style = UIStatusBarStyleDefault;
    }
    return style;
}

- (void)dealloc {
    NSLog(@"⚠️⚠️⚠️ UINavigationController dealloc ⚠️⚠️⚠️");
}

@end
