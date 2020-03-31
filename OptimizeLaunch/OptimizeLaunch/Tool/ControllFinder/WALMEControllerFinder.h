//
//  WALMEControllerFinder.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface WALMEControllerFinder : NSObject

+ (UIViewController *)rootControlerInWindow;
+ (UIViewController *)topViewController;

@end

NS_ASSUME_NONNULL_END
