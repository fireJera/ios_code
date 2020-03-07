//
//  CustomAnimator.m
//  ViewAnimation
//
//  Created by super on 2018/12/17.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "CustomAnimator.h"

@implementation CustomAnimator



- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController * from = [transitionContext viewControllerForKey:@"from"];
    UIViewController * to = [transitionContext viewControllerForKey:@"to"];
    UIView * containerView = transitionContext.containerView;
    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//    CGRect fromFrame = [transitionContext finalFrameForViewController:from];
//    CGRect toFrame = [transitionContext finalFrameForViewController:to];
    
    
    CGRect containerFrame = containerView.frame;
    CGRect toViewStartFrame = [transitionContext initialFrameForViewController:to];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:to];
    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:from];
    
    if (self.presenting) {
        toViewStartFrame.origin.x = containerFrame.size.width;
        toViewStartFrame.origin.y = containerFrame.size.height;
    } else {
        fromViewFinalFrame = CGRectMake(containerFrame.size.width,
                                        containerFrame.size.height,
                                        toView.frame.size.width,
                                        toView.frame.size.height);
    }
    [containerView addSubview:toView];
    toView.frame = toViewStartFrame;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (self.presenting) {
            toView.frame = toViewFinalFrame;
        } else {
            fromView.frame = fromViewFinalFrame;
        }
    } completion:^(BOOL finished) {
        BOOL success = ![transitionContext transitionWasCancelled];
        if ((self.presenting && !success) || (!self.presenting  && success)) {
            [toView removeFromSuperview];
        }
        [transitionContext completeTransition:finished];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

@end
