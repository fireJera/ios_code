
//
//  LETADPhotoEditView.m
//  LetDate
//
//  Created by Jeremy on 2019/1/21.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

#import "LETADPhotoEditView.h"
//#import "LETADVHeader.h"

static const int kSideInterval = 10;

@implementation LETADPhotoEditView

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
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    UIBezierPath * squarPath = [UIBezierPath bezierPathWithRect:CGRectMake(kSideInterval, (self.frame.size.height - (width - kSideInterval * 2)) / 2, width - (kSideInterval * 2), width - (kSideInterval * 2))];
    [path appendPath:squarPath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
    [self.layer addSublayer:fillLayer];
    
    for (int i = 0; i < 4; i++) {
        CAShapeLayer * layer = [[CAShapeLayer alloc] init];
        UIBezierPath * path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(kSideInterval, (height - width) / 2 + kSideInterval + (width - kSideInterval * 2) / 3 * i)];
        [path addLineToPoint:CGPointMake(width - kSideInterval, (height - width) / 2 + kSideInterval + (width - kSideInterval * 2) / 3 * i)];
        
        layer.path = path.CGPath;
        
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.lineWidth = (i == 0 || i == 3) ? 2 : 1;
        [self.layer addSublayer:layer];
        
        CAShapeLayer * vLayer = [[CAShapeLayer alloc] init];
        UIBezierPath * vPath = [[UIBezierPath alloc] init];
        [vPath moveToPoint:CGPointMake(kSideInterval + (width - kSideInterval * 2) / 3 * i, (height - (width - kSideInterval * 2)) / 2)];
        
        [vPath addLineToPoint:CGPointMake(kSideInterval + (width - kSideInterval * 2) / 3 * i, (height + width) / 2 - kSideInterval)];
        vLayer.path = vPath.CGPath;
        vLayer.strokeColor = [UIColor whiteColor].CGColor;
        vLayer.lineWidth = (i == 0 || i == 3) ? 2 : 1;
        [self.layer addSublayer:vLayer];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 5.f,[[[UIColor blackColor] colorWithAlphaComponent:0.8] CGColor]);
    [[UIColor clearColor] setFill];
    [[UIColor whiteColor] setStroke];
    CGContextDrawPath(context, kCGPathEOFillStroke);
    CGContextRestoreGState(context);
}
@end
