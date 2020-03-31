//
//  WALMEPhotoEditView.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEPhotoEditView.h"
#import "WALMEViewHeader.h"

static const int kSideInterval = 0;

@implementation WALMEPhotoEditView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    const CGFloat cropWidth = width - (kSideInterval * 2);
    const CGFloat top = (height - cropWidth) / 2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    UIBezierPath * squarPath = [UIBezierPath bezierPathWithRect:CGRectMake(kSideInterval, top, cropWidth, cropWidth)];
    [path appendPath:squarPath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
    [self.layer addSublayer:fillLayer];
    
    for (int i = 1; i < 3; i++) {
        CAShapeLayer * layer = [[CAShapeLayer alloc] init];
        UIBezierPath * path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(kSideInterval, top + cropWidth / 3 * i)];
        [path addLineToPoint:CGPointMake(width - kSideInterval, top + cropWidth / 3 * i)];
        
        layer.path = path.CGPath;
        
        layer.strokeColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
        layer.lineWidth = 1;
        [self.layer addSublayer:layer];
        
        CAShapeLayer * vLayer = [[CAShapeLayer alloc] init];
        UIBezierPath * vPath = [[UIBezierPath alloc] init];
        [vPath moveToPoint:CGPointMake(kSideInterval + cropWidth / 3 * i, top)];
        
        [vPath addLineToPoint:CGPointMake(kSideInterval + cropWidth / 3 * i, top + cropWidth)];
        vLayer.path = vPath.CGPath;
        vLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
        vLayer.lineWidth = 1;
        [self.layer addSublayer:vLayer];
    }
    
    const CGFloat cornerWidth = 3.0;
    const CGFloat cornerHeight = 30;
    for (int i = 0; i < 4; i++) {
        int index = i % 2;
        CGFloat x = index == 0 ? kSideInterval + cornerWidth / 2 : width - kSideInterval - (cornerWidth / 2);
        CGFloat y = i > 1 ? (top + cropWidth - cornerWidth / 2) : top + cornerWidth / 2;
        CGFloat Vx = x;
        CGFloat Vy = i > 1 ? y - cornerHeight : y + cornerHeight;
        
        CGFloat Hx = index == 0 ? x + cornerHeight : x - cornerHeight;
        CGFloat Hy = y;
        CAShapeLayer * layer = [[CAShapeLayer alloc] init];
        UIBezierPath * path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(Vx, Vy)];
        [path addLineToPoint:CGPointMake(x, y)];
        [path addLineToPoint:CGPointMake(Hx, Hy)];
        
        layer.path = path.CGPath;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.lineWidth = cornerWidth;
        [self.layer addSublayer:layer];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 5.f,[[[UIColor blackColor] colorWithAlphaComponent:0.8] CGColor]);
    [[UIColor clearColor] setFill];
    [[UIColor whiteColor] setStroke];
    CGContextDrawPath(context, kCGPathEOFillStroke);
    CGContextRestoreGState(context);
}


//- (void)drawRect:(CGRect)rect {
//    CGFloat width = self.frame.size.width;
//    CGFloat height = self.frame.size.height;
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
//    UIBezierPath * squarPath = [UIBezierPath bezierPathWithRect:CGRectMake(kSideInterval, (self.frame.size.height - (width - kSideInterval * 2)) / 2, width - (kSideInterval * 2), width - (kSideInterval * 2))];
//    [path appendPath:squarPath];
//    [path setUsesEvenOddFillRule:YES];
//
//    CAShapeLayer *fillLayer = [CAShapeLayer layer];
//    fillLayer.path = path.CGPath;
//    fillLayer.fillRule = kCAFillRuleEvenOdd;
//    fillLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
//    [self.layer addSublayer:fillLayer];
//
//    for (int i = 0; i < 4; i++) {
//        CAShapeLayer * layer = [[CAShapeLayer alloc] init];
//        UIBezierPath * path = [[UIBezierPath alloc] init];
//        [path moveToPoint:CGPointMake(kSideInterval, (height - width) / 2 + kSideInterval + (width - kSideInterval * 2) / 3 * i)];
//        [path addLineToPoint:CGPointMake(width - kSideInterval, (height - width) / 2 + kSideInterval + (width - kSideInterval * 2) / 3 * i)];
//
//        layer.path = path.CGPath;
//
//        layer.strokeColor = [UIColor whiteColor].CGColor;
//        layer.lineWidth = (i == 0 || i == 3) ? 2 : 1;
//        [self.layer addSublayer:layer];
//
//        CAShapeLayer * vLayer = [[CAShapeLayer alloc] init];
//        UIBezierPath * vPath = [[UIBezierPath alloc] init];
//        [vPath moveToPoint:CGPointMake(kSideInterval + (width - kSideInterval * 2) / 3 * i, (height - (width - kSideInterval * 2)) / 2)];
//
//        [vPath addLineToPoint:CGPointMake(kSideInterval + (width - kSideInterval * 2) / 3 * i, (height + width) / 2 - kSideInterval)];
//        vLayer.path = vPath.CGPath;
//        vLayer.strokeColor = [UIColor whiteColor].CGColor;
//        vLayer.lineWidth = (i == 0 || i == 3) ? 2 : 1;
//        [self.layer addSublayer:vLayer];
//    }
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//
//    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 5.f,[[[UIColor blackColor] colorWithAlphaComponent:0.8] CGColor]);
//    [[UIColor clearColor] setFill];
//    [[UIColor whiteColor] setStroke];
//    CGContextDrawPath(context, kCGPathEOFillStroke);
//    CGContextRestoreGState(context);
//}

@end
