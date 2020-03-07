//
//  ViewController.m
//  YYKit
//
//  Created by super on 2018/12/27.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import "YYWeakProxy.h"
#import "YYTransaction.h"
#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YYWeakProxy * weakProxy = [[YYWeakProxy alloc] initWithTarget:self];
    [weakProxy performSelector:@selector(test)];
    ((void (*void)(void))_objc_msgSend(self, @selector(test)));
    [[YYTransaction transactionWithTarget:self selector:@selector(test)] commit];
    
//    _objc_fatal("faile");
}

- (void)test {
    NSLog(@"test");
}

@end
