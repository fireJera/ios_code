//
//  ViewController.m
//  Concurrent
//
//  Created by super on 2018/12/25.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("queue3", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue4 = dispatch_queue_create("queue4", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue5 = dispatch_queue_create("queue5", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue6 = dispatch_queue_create("queue6", DISPATCH_QUEUE_SERIAL);
    
//    dispatch_set_target_queue(queue2, queue1);
//    dispatch_set_target_queue(queue3, queue2);
//    dispatch_set_target_queue(queue4, queue3);
//    dispatch_set_target_queue(queue5, queue4);
//    dispatch_set_target_queue(queue6, queue5);
    
    dispatch_async(queue1, ^{
        NSLog(@"queue1 current thread:%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue2, ^{
        NSLog(@"queue2 current thread:%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue3, ^{
        NSLog(@"queue3 current thread:%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue4, ^{
        NSLog(@"queue4 current thread:%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue5, ^{
        NSLog(@"queue5 current thread:%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue6, ^{
        NSLog(@"queue6 current thread:%@", [NSThread currentThread]);
    });
}


@end
