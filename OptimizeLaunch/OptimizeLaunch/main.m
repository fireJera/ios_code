//
//  main.m
//  OptimizeLaunch
//
//  Created by Jeremy on 2020/3/26.
//  Copyright © 2020 jercouple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        printf("main function \n");
        [AppDelegate setStartTime:CFAbsoluteTimeGetCurrent()];
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}

//__attribute__((constructor)) static void beforeFunction() {
//    printf("before function \n");
//}
//
//// 手动杀掉后会调用
//__attribute__((destructor)) static void aftefFunction() {
//    printf("after function \n");
//    NSInteger count = 0;
//    for (int i = 0; i < 99999999; i++) {
//        count++;
//    }
//    printf("count : %d \n", count);
//}
