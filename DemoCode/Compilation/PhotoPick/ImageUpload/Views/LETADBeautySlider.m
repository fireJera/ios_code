//
////
////  LETADBeautySlider.m
////  LetDate
////
////  Created by Jeremy on 2019/1/21.
////  Copyright © 2019 JersiZhu. All rights reserved.
////
//
//#import "LETADBeautySlider.h"
//static const CGFloat SLIDER_X_BOUND = 30.0;
//static const CGFloat SLIDER_Y_BOUND = 40.0;
//
//@interface LETADBeautySlider () {
//    CGRect _lastBounds;
//}
//@end
//
//@implementation LETADBeautySlider
//
//- (CGRect)trackRectForBounds:(CGRect)bounds
//{
//    return self.bounds;
//}
//
//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value;
//{
//    rect.origin.x = rect.origin.x;
//    rect.size.width = rect.size.width;
//    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
//    _lastBounds = result;
//    return result;
//}
//
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView* result = [super hitTest:point withEvent:event];
//    if (result != self) {
//        if ((point.y >= -15) &&
//            (point.y < (_lastBounds.size.height + SLIDER_Y_BOUND)) &&
//            (point.x >= 0 && point.x < CGRectGetWidth(self.bounds))) {
//            result = self;
//        }
//    }
//    return result;
//}
//
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    BOOL result = [super pointInside:point withEvent:event];
//    
//    if (!result) {
//        if ((point.x >= (_lastBounds.origin.x - SLIDER_X_BOUND)) && (point.x <= (_lastBounds.origin.x + _lastBounds.size.width + SLIDER_X_BOUND))
//            && (point.y >= -SLIDER_Y_BOUND) && (point.y < (_lastBounds.size.height + SLIDER_Y_BOUND))) {
//            result = YES;
//        }
//    }
//    return result;
//}
//@end
