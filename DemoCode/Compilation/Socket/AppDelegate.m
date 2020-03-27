//
//  AppDelegate.m
//  Socket
//
//  Created by Jeremy on 2020/3/21.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ServiceViewController.h"

#define ISSocketServer 1

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] init];
#if ISSocketServer
    self.window.rootViewController = [ServiceViewController new];
#else
    self.window.rootViewController = [ViewController new];
#endif
    [self.window makeKeyAndVisible];
    return YES;
}

@end
