//
//  ViewController.m
//  OptimizeLaunch
//
//  Created by Jeremy on 2020/3/26.
//  Copyright © 2020 jercouple. All rights reserved.
//

#import "ViewController.h"
#import <sys/time.h>

@interface ViewController ()


@end

@implementation ViewController

//__attribute__((constructor)) void waitForNetDebugger() {
//    struct timeval time;
//    (void)gettimeofday(&time, NULL);
//    long start_sec = time.tv_sec;
//    long current_sec = start_sec;
//    while (current_sec < start_sec + 5) {
//        (void)gettimeofday(&time, NULL);
//        current_sec = time.tv_sec;
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    NSInteger count = 0;
//    for (int i = 0; i < 99999999; i++) {
//        count++;
//    }
//    NSLog(@"count : %d", count);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"viewWillLayoutSubviews");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews");
}

- (void)viewLayoutMarginsDidChange {
    NSLog(@"viewLayoutMarginsDidChange");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    int launch = [[NSUserDefaults standardUserDefaults] integerForKey:@"launch"];
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"launch"];
    launch = [[NSUserDefaults standardUserDefaults] integerForKey:@"launch"];
}

@end
