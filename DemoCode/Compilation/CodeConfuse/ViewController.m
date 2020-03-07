//
//  ViewController.m
//  CodeConfuse
//
//  Created by super on 2019/1/3.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import "TestObject.h"
#import "tViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self test];
    [[[TestObject alloc] init] testObject];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(0, 100, 100, 100);
    [btn addTarget:self action:@selector(pres) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    WKWebView * web = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [web evaluateJavaScript:@"test" completionHandler:^(id result, NSError *  error) {
        if (error) {
            NSLog(@"%@", error);
        }
    }];
}

- (void)pres {
    [self presentViewController:[tViewController new] animated:YES completion:nil];
}


- (void)test {
//    NSLog(@"Test");
}

@end
