//
//  JJImageViewController.h
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/9.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJImageViewController : UIViewController

- (instancetype)initWithFocusImages:(NSArray<NSString *> *)focusImages;
- (instancetype)initWithFocusImages:(NSArray<NSString *> *)focusImages otherImages:(nullable NSArray<NSString *> *)otherImages;

@end

NS_ASSUME_NONNULL_END
