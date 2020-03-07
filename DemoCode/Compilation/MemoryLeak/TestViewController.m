//
//  TestViewController.m
//  MemoryLeak
//
//  Created by Jeremy on 2020/3/4.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "TestViewController.h"
#import "AllowTest.h"
#import "FBRetainCycleDetector.h"

@interface TestViewController ()
@property (nonatomic, strong) AllowTest * aTest;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _aTest = [AllowTest new];
    _aTest.delegate = self;
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 200, 100, 100);
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)btnPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        FBObjectGraphConfiguration * con = [[FBObjectGraphConfiguration alloc] initWithFilterBlocks:nil shouldInspectTimers:YES];
        FBRetainCycleDetector * detector = [[FBRetainCycleDetector alloc] initWithConfiguration:con];
        [detector addCandidate:self];
        [detector findRetainCycles];
    }];
}

- (void)dealloc {
    NSLog(@"self deall:  %@", self);
}

@end
