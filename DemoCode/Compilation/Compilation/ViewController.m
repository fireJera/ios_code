//
//  ViewController.m
//  Compilation
//
//  Created by super on 2018/12/24.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import "Test.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Test * t = [Test new];
    t.deal(@"give me five").resultBlock = ^{
        NSLog(@"finisn block");
        NSLog(@"%@", TSTObjectIdentifier);
    };
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 300, 100, 100);
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)btnPressed:(UIButton *)sender {
//    [self btnTouch];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1");
    });
}

@end
