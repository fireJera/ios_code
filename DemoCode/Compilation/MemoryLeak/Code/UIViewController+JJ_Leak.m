//
//  UIViewController+JJ_Leak.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "UIViewController+JJ_Leak.h"
#import "NSObject+JJ_Leak.h"
#import <objc/runtime.h>

#if _INTERNAL_MLF_ENABLED

const void *const kHasBeenPoppedKey = &kHasBeenPoppedkey;

@implementation UIViewController (JJ_Leak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(viewWillAppear:) withSEL:@selector(swizzled_viewWillAppear:)];
        [self swizzleSEL:@selector(viewWillDisappear:) withSEL:@selector(swizzled_viewDidDisappear::)];
        [self swizzleSEL:@selector(dismissViewControllerAnimated:completion:) withSEL:@selector(swizzled_dismissViewControllerAnimated:completion:)];
    });
}

- (void)swizzled_viewDidDisappear:(BOOL)animated {
    [self swizzled_viewDidDisappear:animated];
    if ([objc_getAssociatedObject(self, kHasBeenPoppedKey) boolValue]) {
        [self willDealloc];
    }
}

- (void)swizzled_viewWillAppear:(BOOL)animated {
    [self swizzled_viewWillAppear:animated];
    objc_setAssociatedObject(self, kHasBeenPoppedKey, @(NO), OBJC_ASSOCIATION_RETAIN);
}

- (void)swizzled_dismissViewControllerAnimated:(BOOL)flag completion:(void(^)(void))completion {
    [self swizzled_dismissViewControllerAnimated:flag completion:completion];
    UIViewController * dismissedViewController = self.presentedViewController;
    if (!dismissedViewController && self.presentedViewController) {
        dismissedViewController = self;
    }
    if (!dismissedViewController) {
        return;
    }
    [dismissedViewController willDealloc];
}

- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }
    [self willReleaseChildren:self.childViewControllers];
    [self willReleaseChild:self.presentedViewController];
    if (self.isViewLoaded) {
        [self willReleaseChild:self.view];
    }
    return YES;
}

@end

#endif
