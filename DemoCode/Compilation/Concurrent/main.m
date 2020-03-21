//
//  main.m
//  Concurrent
//
//  Created by super on 2018/12/25.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_queue_create(0, 0);
        dispatch_group_enter(group);
        dispatch_group_enter(group);
        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:1];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [NSThread sleepForTimeInterval:1];
                NSLog(@"1 finish");
                dispatch_group_leave(group);
            });
        });
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:2];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [NSThread sleepForTimeInterval:2];
                NSLog(@"2 finish");
                dispatch_group_leave(group);
            });
            
        });
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:3];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSLog(@"3 finish");
                dispatch_group_leave(group);
            });
        });
        NSLog(@"all start");
        dispatch_group_notify(group, queue, ^{
            NSLog(@"all finish");
        });
        NSLog(@"last step");
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
