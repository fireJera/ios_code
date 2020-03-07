//
//  UINavigationController+JJ_Leak.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "UINavigationController+JJ_Leak.h"
#import "NSObject+JJ_Leak.h"
#import <objc/runtime.h>

#if _INTERNAL_MLF_ENABLED

@implementation UINavigationController (JJ_Leak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(popToViewController:animated:) withSEL:@selector(swizzled_popToViewController:animated:)];
        [self swizzleSEL:@selector(pushViewController:animated:) withSEL:@selector(swizzled_pushViewController:animated:)];
        [self swizzleSEL:@selector(popViewControllerAnimated:) withSEL:@selector(popViewControllerAnimated:)];
        [self swizzleSEL:@selector(popToRootViewControllerAnimated:) withSEL:@selector(popToRootViewControllerAnimated:)];
    });
}

- (void)swizzled_pushViewController:(UIViewController *)viewcontroller animated:(BOOL)animated {
    if (self.splitViewController) {
        id detailViewController = objc_getAssociatedObject(self, kPoppedDetailVCKey);
        if ([detailViewController isKindOfClass:[UIViewController class]]) {
            [detailViewController willDealloc];
            objc_setAssociatedObject(self, kPoppedDetailVCKey, nil, OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    [self swizzled_pushViewController:viewcontroller animated:animated];
}

//- (UIViewController *)swizzled_popViewControllerAnimated:(BOOL)animated {
//    UIViewController * poppedViewController = [self swizzled_popViewControllerAnimated:animated];
//    if (!poppedViewController) return nil;
//
//    if (self.splitViewController && self.splitViewController.viewControllers.firstObject == self &&
//        self.splitViewController == poppedViewController.splitViewController) {
//        objc_setAssociatedObject(self, kPoppedDetailVCKey, poppedViewController, OBJC_ASSOCIATION_RETAIN);
//        return poppedViewController;
//    }
//
//    extern const void *const kHasBeenPoppedKey;
//    objc_setAssociatedObject(poppedViewController, kHasBeenPoppedKey, @(YES), OBJC_ASSOCIATION_RETAIN);
//
//    return poppedViewController;
//}

- (UIViewController *)swizzled_popViewControllerAnimated:(BOOL)animated {
    UIViewController *poppedViewController = [self swizzled_popViewControllerAnimated:animated];
    
    if (!poppedViewController) {
        return nil;
    }
    
    // Detail VC in UISplitViewController is not dealloced until another detail VC is shown
    if (self.splitViewController &&
        self.splitViewController.viewControllers.firstObject == self &&
        self.splitViewController == poppedViewController.splitViewController) {
        objc_setAssociatedObject(self, kPoppedDetailVCKey, poppedViewController, OBJC_ASSOCIATION_RETAIN);
        return poppedViewController;
    }
    
    // VC is not dealloced until disappear when popped using a left-edge swipe gesture
    extern const void *const kHasBeenPoppedKey;
    objc_setAssociatedObject(poppedViewController, kHasBeenPoppedKey, @(YES), OBJC_ASSOCIATION_RETAIN);
    
    return poppedViewController;
}

- (NSArray<UIViewController *> *)swizzled_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray<UIViewController *>* poppedViewControllers = [self swizzled_popToViewController:viewController animated:animated];
    for (UIViewController * viewController in poppedViewControllers) {
        [viewController willDealloc];
    }
    return poppedViewControllers;
}

- (NSArray<UIViewController *> *)swizzled_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray<UIViewController *> *poppedViewControllers = [self swizzled_popToRootViewControllerAnimated:animated];
    
    for (UIViewController * viewControler in poppedViewControllers) {
        [viewControler willDealloc];
    }
    return poppedViewControllers;
}

- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }
    [self willReleaseChildren:self.viewControllers];
    return YES;
}

@end

#endif
