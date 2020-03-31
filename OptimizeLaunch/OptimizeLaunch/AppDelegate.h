//
//  AppDelegate.h
//  OptimizeLaunch
//
//  Created by Jeremy on 2020/3/26.
//  Copyright © 2020 jercouple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow * window;

+ (void)setStartTime:(CFAbsoluteTime)start;

@end

