//
//  AppDelegate.m
//  sqlite
//
//  Created by Jeremy on 2020/3/16.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "sqlite3.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] init];
    self.window.rootViewController = [[ViewController alloc] init];
    
    __unused const char *version = sqlite3_version;
    __unused const char * libversion = sqlite3_libversion();
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
