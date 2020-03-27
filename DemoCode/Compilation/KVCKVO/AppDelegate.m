//
//  AppDelegate.m
//  KVCKVO
//
//  Created by Jeremy on 2020/3/23.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "CopyableC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [UIWindow new];
    ViewController * controller = [ViewController new];
    CopyableC * cp = [[CopyableC alloc] init];
    CopyableC * newcp = [cp copy];
    controller.cpyC = cp;
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
