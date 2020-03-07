//
//  InterTransition.h
//  ViewAnimation
//
//  Created by super on 2018/12/17.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InterTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, weak) id<UIViewControllerContextTransitioning> contextData;
@property (nonatomic, strong) UIPanGestureRecognizer * panGesture;

@end

NS_ASSUME_NONNULL_END
