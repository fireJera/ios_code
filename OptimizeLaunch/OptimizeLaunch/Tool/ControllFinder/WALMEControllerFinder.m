//
//  WALMEControllerFinder.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEControllerFinder.h"

@implementation WALMEControllerFinder

+ (UIViewController *)rootControlerInWindow {
    return UIApplication.sharedApplication.delegate.window.rootViewController;
}

+ (UIViewController *)topViewController {
    UIViewController * topVC = [self rootControlerInWindow];
    topVC = [self _topViewController:topVC];
    while (topVC.presentedViewController) {
        topVC = [self _topViewController:topVC.presentedViewController];
    }
    return topVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)viewController selectedViewController]];
    }
    else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)viewController topViewController]];
    } else {
        return viewController;
    }
    return nil;
}

@end
