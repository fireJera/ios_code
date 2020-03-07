//
//  JJClassListViewController.h
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/9.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJClassListViewController : UIViewController

@property (nonatomic, copy) NSString * imageName;

- (instancetype)initWithClasses:(NSArray<Class> *)classes;

@end

NS_ASSUME_NONNULL_END
