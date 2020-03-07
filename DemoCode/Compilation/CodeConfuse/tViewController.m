//
//  tViewController.m
//  CodeConfuse
//
//  Created by super on 2019/1/5.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "tViewController.h"

@interface tViewController ()

@end

@implementation tViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    static int i;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        i = 0;
    });
    i++;
    NSLog(@"-------%d", i);
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = [UIColor yellowColor];
    btn1.frame = CGRectMake(100, 100, 100, 100);
    [btn1 addTarget:self action:@selector(dism) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}



- (void)dism {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
