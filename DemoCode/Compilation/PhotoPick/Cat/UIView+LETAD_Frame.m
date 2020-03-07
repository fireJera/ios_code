//
//  UIImageView+LETAD_Frame.m
//  Orange
//
//  Created by JerRen on 03/11/2017.
//  Copyright © 2018 JerRen. All rights reserved.
//

#import "UIView+LETAD_Frame.h"

@implementation UIView (LETAD_Frame)

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX {
    CGRect frame = self.frame;
    frame.origin.x = centerX - frame.size.width / 2;
    self.frame = frame;
}

- (void)setCenterY:(CGFloat)centerY {
    CGRect frame = self.frame;
    frame.origin.y = centerY - frame.size.height / 2;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGSize)size {
    return self.frame.size;
}

- (CGFloat)centerX {
    return self.frame.origin.x + self.frame.size.width / 2;
}

- (CGFloat)centerY {
    return self.frame.origin.y + self.frame.size.height / 2;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.height;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (CGFloat)right {
    return self.frame.origin.x + self.width;
}

@end

@implementation UIView (LETAD_ViewController)

- (UIViewController *)viewController {
    UIResponder *nextResponder =  self;
    do
    {
        nextResponder = [nextResponder nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
    } while (nextResponder != nil);
    return nil;
}

@end

@implementation UIView (LETAD_SubView)

- (void)removeAllSubViews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

@end


@implementation UIView (LETADLoad)

- (void)bringToFront {
    [self.superview bringSubviewToFront:self];
}

- (void)sendToBack {
    [self.superview sendSubviewToBack:self];
}

@end

@implementation UIView (LETADCorner)

@dynamic layerBorderColor, layerBorderWidth, layerCornerRadius;

- (void)addCorner:(CGFloat)radius {
    [self addCorner:radius borderWidth:1 bgColor:[UIColor clearColor] borderColor:[UIColor blackColor]];
}

- (void)addCorner:(CGFloat)radius borderWidth:(CGFloat)borderWidth bgColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor {
    UIImage * image = [self p_letad_drawRectCorner:radius borderWidth:borderWidth bgColor:bgColor borderColor:borderColor];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    [self insertSubview:imageView atIndex:0];
}


- (UIImage *)p_letad_drawRectCorner:(CGFloat)radius borderWidth:(CGFloat)borderWidth bgColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor {
    CGSize sizeToFit = CGSizeMake([self pixel:self.bounds.size.width], self.bounds.size.width);
    CGFloat halfBorderWidth = borderWidth / 2.0;
    UIGraphicsBeginImageContextWithOptions(sizeToFit, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    
    CGFloat width = sizeToFit.width;
    CGFloat height = sizeToFit.height;
    CGContextMoveToPoint(context, width - halfBorderWidth, radius + halfBorderWidth);
    CGContextAddArcToPoint(context, width - halfBorderWidth, height - halfBorderWidth, width - radius - halfBorderWidth, height - halfBorderWidth, radius);
    CGContextAddArcToPoint(context, halfBorderWidth, height - halfBorderWidth, halfBorderWidth, height - radius - halfBorderWidth, radius);
    CGContextAddArcToPoint(context, halfBorderWidth, halfBorderWidth, width - halfBorderWidth, halfBorderWidth, radius);
    CGContextAddArcToPoint(context, width - halfBorderWidth, halfBorderWidth, width - halfBorderWidth, radius + halfBorderWidth, radius);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (double)pixel:(double)num {
    double unit = 0;
    unit = 1 / (int)[UIScreen mainScreen].scale;
    return [self p_letad_roundByUnit:num with:unit];
}

- (double)p_letad_roundByUnit:(double)num with:(double)unit {
    double remain = modf(num, &unit);
    if (remain > unit / 2.0) {
        return [self p_letad_ceilUnit:num with:unit];
    } else {
        return [self p_letad_floorUnit:num with:unit];
    }
}

- (double)p_letad_ceilUnit:(double)num with:(double)unit {
    return num - modf(num, &unit) + unit;
}

- (double)p_letad_floorUnit :(double)num with:(double)unit{
    return num - modf(num, &unit);
}

- (void)setLayerCornerRadius:(CGFloat)layerCornerRadius {
    self.layer.cornerRadius = layerCornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setLayerBorderWidth:(CGFloat)layerBorderWidth {
    self.layer.borderWidth = layerBorderWidth;
}

- (void)setLayerBorderColor:(UIColor *)layerBorderColor {
    self.layer.borderColor = layerBorderColor.CGColor;
}

@end

@implementation UIView (LETADImage)

- (UIImage *)snapImage {
    UIImage * imageRet = nil;
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    //获取图像
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
}

@end
