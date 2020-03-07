//
//  main.m
//  TanTanCard
//
//  Created by Jeremy on 2019/7/18.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
extern void _objc_autoreleasePoolPrint();
int main(int argc, char * argv[]) {
    id obj = [NSObject new];
    @autoreleasepool {
        id __weak o = obj;
        NSLog(@"1 %@", o);
//        NSLog(@"2 %@", o);
        //        NSLog(@"3 %@", o);
        //        NSLog(@"4 %@", o);
        //        NSLog(@"5 %@", o);
        _objc_autoreleasePoolPrint();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
