//
//  InterTransition.m
//  ViewAnimation
//
//  Created by super on 2018/12/17.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "InterTransition.h"

@implementation InterTransition

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [super startInteractiveTransition:transitionContext];
//    self.contextData = transitionContext;
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipUpdate:)];
    self.panGesture.maximumNumberOfTouches = 1;
    UIView * container = [transitionContext containerView];
    [container addGestureRecognizer:self.panGesture];
}

- (void)handleSwipUpdate:(UIGestureRecognizer *)gestureRecognizer {
    UIView * container = [self.contextData containerView];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.panGesture setTranslation:CGPointZero inView:container];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [self.panGesture translationInView:container];
        CGFloat percentage = fabs(translation.y / CGRectGetHeight(container.bounds));
        [self updateInteractiveTransition:percentage];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self finishInteractiveTransition];
        [[self.contextData containerView] removeGestureRecognizer:self.panGesture];
    }
}

@end
