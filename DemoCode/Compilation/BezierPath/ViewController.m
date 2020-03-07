//
//  ViewController.m
//  BezierPath
//
//  Created by super on 2019/1/14.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>

@interface ViewController ()

@property(nonatomic, strong) CAShapeLayer * pathLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGMutablePathRef letters = CGPathCreateMutable();   //创建path
    CTFontRef font = CTFontCreateWithName(CFSTR("Helvetica-Bold"), 100.0f, NULL);       //设置字体
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)font, kCTFontAttributeName,
                           nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"" attributes:attrs];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);   //创建line
    CFArrayRef runArray = CTLineGetGlyphRuns(line);     //根据line获得一个数组
    // 获得每一个 run
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        // 获得 run 的字体
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        // 获得 run 的每一个形象字
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            // 获得形象字
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            //获得形象字信息
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            // 获得形象字外线的path
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);
    
    //根据构造出的 path 构造 bezier 对象
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    CFRelease(font);
    
    //根据 bezier 创建 shapeLayer对象
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = CGRectMake(100, 100, 200, 100);
    pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [[UIColor blackColor] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 3.0f;
    pathLayer.lineJoin = kCALineJoinBevel;
    
    [self.view.layer addSublayer:pathLayer];
    
    self.pathLayer = pathLayer;
    
    [self startAnimation];
//    CAShapeLayer * layer = [CAShapeLayer layer];
//    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:100 startAngle:0 endAngle:M_PI * 3 / 2 clockwise:YES];
//    [path addLineToPoint:CGPointMake(100, 100)];
//    layer.path = path.CGPath;
//    [self.view.layer addSublayer:layer];
//    layer.hidden = NO;
////    layer.fillColor = [UIColor blackColor].CGColor;
//    layer.strokeColor = [UIColor blackColor].CGColor;
}


//开始动画
- (void) startAnimation
{
    [self.pathLayer removeAllAnimations];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.5;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:0.25];
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
//    CABasicAnimation *pathAnimation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnimation1.duration = 0.5;
//    pathAnimation1.fromValue = [NSNumber numberWithFloat:0.25f];
//    pathAnimation1.toValue = [NSNumber numberWithFloat:0.5f];
//    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

@end
