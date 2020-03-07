//
//  JJDetaiViewController.h
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/10.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JJIvar, JJProperty, JJMethod;

@interface JJDetaiViewController : UIViewController

+ (instancetype)detailWithIvar:(JJIvar *)ivar;
+ (instancetype)detailWithProperty:(JJProperty *)property;
+ (instancetype)detailWithMethod:(JJMethod *)method;

@end

NS_ASSUME_NONNULL_END
