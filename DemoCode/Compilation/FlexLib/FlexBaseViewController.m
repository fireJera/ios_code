//
//  FlexBaseViewController.m
//  FlexLib
//
//  Created by Jeremy on 2019/5/19.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "FlexBaseViewController.h"

@interface FlexBaseViewController () {
    UIView * _test;
}
@end

@implementation FlexBaseViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"FlexLib Demo";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTest:(id)sender {
    //    TestVC* vc=[[TestVC alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
}
- (void)onPressTest:(id)sender {
    NSLog(@"pressed");
}

@end
