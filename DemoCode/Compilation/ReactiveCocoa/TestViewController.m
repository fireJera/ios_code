//
//  TestViewController.m
//  ReactiveCocoa
//
//  Created by Jeremy on 2019/1/17.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "TestViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)click {
    if (self.delegateSignal) {
        [self.delegateSignal sendNext:nil];
    }
}

@end
