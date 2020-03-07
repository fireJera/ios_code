//
//  ViewController.m
//  CrashHandler
//
//  Created by Jeremy on 2019/3/7.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

typedef struct Test {
    int a;
    int b;
} Test;


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)ocCrash:(id)sender {
    NSArray *array= @[@"tom",@"xxx",@"ooo"];
    [array objectAtIndex:5];
}

- (IBAction)signalCrash:(id)sender {
    Test * pTest = {1,2};
    free(pTest); //导致SIGABRT的错误，因为内存中根本就没有这个空间，哪来的free，就在栈中的对象而已
    pTest->a = 5;
}

- (IBAction)changeIcon:(id)sender {
    static BOOL shouldChange = NO;
    shouldChange = !shouldChange;
    NSString * iconName;
    if (shouldChange) {
        if (![[UIApplication sharedApplication] supportsAlternateIcons]) {
            return;
        }
        iconName = @"testIcon";
    } else {
        iconName = nil;
    }
    [[UIApplication sharedApplication] setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换app图标发生错误了 ： %@",error);
        }
    }];
}

@end
