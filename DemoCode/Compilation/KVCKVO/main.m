//
//  main.m
//  KVCKVO
//
//  Created by Jeremy on 2020/3/23.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        dispatch_queue_t cqueue = dispatch_queue_create(@"testqueue", DISPATCH_QUEUE_SERIAL);
        
        dispatch_queue_t cqueue2 = dispatch_queue_create(@"testqueue", DISPATCH_QUEUE_SERIAL);
//        dispatch_set_target_queue(cqueue2, cqueue);
        dispatch_async(cqueue, ^{
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1");
        });
        
        dispatch_async(cqueue2, ^{
            NSLog(@"2");
        });
        
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
