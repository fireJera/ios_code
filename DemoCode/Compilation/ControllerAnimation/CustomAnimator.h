//
//  CustomAnimator.h
//  ViewAnimation
//
//  Created by super on 2018/12/17.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL presenting;

@end

NS_ASSUME_NONNULL_END
