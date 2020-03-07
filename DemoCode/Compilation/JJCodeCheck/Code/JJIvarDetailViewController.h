//
//  JJIVarDetailViewController.h
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/10.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "JJDetaiViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJIvarDetailViewController : JJDetaiViewController

- (instancetype)initWithIvar:(JJIvar *)ivar;

- (instancetype)initWithProperty:(JJProperty *)property;

@end

NS_ASSUME_NONNULL_END
