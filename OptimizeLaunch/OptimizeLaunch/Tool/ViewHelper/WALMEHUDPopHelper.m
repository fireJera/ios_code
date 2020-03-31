//
//  WALMEHUDPopHelper.m
//  CodeFrame
//
//  Created by Jeremy on 2019/5/6.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEHUDPopHelper.h"
#import "WALMEControllerHeader.h"
#import "WALMEControllerFinder.h"
#import "WALMEUserHomePopHelloView.h"

static dispatch_semaphore_t kHUDLock = NULL;
#define Lock() dispatch_semaphore_wait(kHUDLock, DISPATCH_TIME_FOREVER)
#define UnLock() dispatch_semaphore_signal(kHUDLock)

@implementation WALMEHUDPopHelper

+ (void)initialize
{
    if (self == [WALMEHUDPopHelper class]) {
        kHUDLock = dispatch_semaphore_create(1);
    }
}

+ (void)showTextHUD:(NSString *)text {
//    if (!IsStringLengthGreaterThanZero(text)) return;
    Lock();
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController * topVC = [WALMEControllerFinder topViewController];
//        [topVC.view showTextHUD:text];
    });
    UnLock();
}

+ (void)showTextHUD:(NSString *)text delaySecond:(NSInteger)second {
//    if (!IsStringLengthGreaterThanZero(text)) return;
    second = MIN(second, 1);
    Lock();
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController * topVC = [WALMEControllerFinder rootControlerInWindow];
//        [topVC.view showTextHUD:text enabled:YES xOffset:0 yOffset:(topVC.view.height / 2) - 240 dealy:second];
    });
    UnLock();
}

+ (MBProgressHUD *)customProgressHUDTitle:(NSString *)title {
//    if (!IsStringLengthGreaterThanZero(title)) return nil;
    __block MBProgressHUD * hud;
    Lock();
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        UIViewController * topVC = [WALMEControllerFinder topViewController];
        topVC = topVC.navigationController ? topVC.navigationController : topVC;
//        hud = [topVC.view customProgressHUDTitle:title];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIViewController * topVC = [WALMEControllerFinder topViewController];
            topVC = topVC.navigationController ? topVC.navigationController : topVC;
//            hud =/ [topVC.view customProgressHUDTitle:title];
        });
    }
    UnLock();
    return hud;
}

+ (void)showHelloViewWithStrings:(NSArray<NSString *> *)strings {
//    if (!IsArrayWithItems(strings)) return;
    Lock();
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController * topVC = [WALMEControllerFinder topViewController];
        UIViewController * nav = topVC.navigationController;
        if (!nav) {
            nav = [WALMEControllerFinder rootControlerInWindow];
        }
        WALMEUserHomePopHelloView * popView = [[WALMEUserHomePopHelloView alloc] initWithFrame:nav.view.bounds];
        [nav.view addSubview:popView];
        popView.optionStrings = strings;
        popView.delegate = (id<WALMEPopHelloViewDelegate>)topVC;
    });
    UnLock();
}

@end
