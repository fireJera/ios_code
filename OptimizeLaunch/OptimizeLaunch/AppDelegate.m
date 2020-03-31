//
//  AppDelegate.m
//  OptimizeLaunch
//
//  Created by Jeremy on 2020/3/26.
//  Copyright © 2020 jercouple. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <WebKit/WebKit.h>

CFAbsoluteTime selfStart;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] init];
    ViewController * controller = [ViewController new];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    double launchTime = end - selfStart;
    
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"launch"];
    
    NSLog(@"launchTime = %f 毫秒",launchTime * 1000);
//    WKWebView *webView;
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"applicationWillTerminate");
}

+ (void)setStartTime:(CFAbsoluteTime)start {
    selfStart = start;
}


@end
//
