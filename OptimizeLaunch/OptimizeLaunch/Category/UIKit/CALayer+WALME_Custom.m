//
//  CALayer+WALME_Custom.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "CALayer+WALME_Custom.h"
#import "UIColor+WALME_Hex.h"

@implementation CALayer (WALME_Custom)


- (void)setBorderIBColor:(UIColor *)borderIBColor {
    self.borderColor = borderIBColor.CGColor;
}

- (void)setShadowIBColor:(UIColor *)shadowIBColor {
    self.shadowColor = shadowIBColor.CGColor;
}

- (UIColor *)borderIBColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

- (UIColor *)shadowIBColor {
    return [UIColor colorWithCGColor:self.shadowColor];
}

- (UIImage *)snapImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (CAGradientLayer *)verticalGradientLayerWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor {
    if (fromColor && toColor) {
        return [self gradientLayerWithColors:@[fromColor, toColor] size:CGSizeMake(10, 10) isHorizon:NO];
    }
    return nil;
}

+ (CAGradientLayer *)horizonGradientLayerWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor {
    if (fromColor && toColor) {
        return [self gradientLayerWithColors:@[fromColor, toColor] size:CGSizeMake(10, 10) isHorizon:YES];
    }
    return nil;
}

+ (CAGradientLayer *)gradientLayerWithColors:(NSArray<UIColor *> *)colors size:(CGSize)size isHorizon:(BOOL)isHorizon {
    if (!colors) return nil;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, size.width, size.height);
    gradient.startPoint = CGPointMake(0, 0);
    CGPoint end = isHorizon ? CGPointMake(1, 0) : CGPointMake(0, 1);
    gradient.endPoint = end;
    float location = 1.0 / (float)(colors.count * 2);
    NSMutableArray *locations = [NSMutableArray arrayWithCapacity:colors.count];
    NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
    for (int i = 0; i < colors.count; i++) {
        [locations addObject:@(location + location * 2 * i)];
        [cgColors addObject:(id)(colors[i].CGColor)];
    }
    gradient.locations = locations;
//    gradient.locations = @[@0.25, @0.75];
    gradient.colors = cgColors;
    return gradient;
}

+ (CAGradientLayer *)navBarGradientLayer {
    return [self gradientLayerWithColors:@[[UIColor walme_colorWithRGB:0x3E4149], [UIColor walme_colorWithRGB:0x353535]]
                                    size:CGSizeMake(0, 0)
                               isHorizon:YES];
}

+ (UIImage *)navBarGradientLayerImage {
    return [[self navBarGradientLayer] snapImage];
}

+ (CAGradientLayer *)chatNavBarGradientLayer {
    return [self gradientLayerWithColors:@[[UIColor walme_colorWithRGB:0x8a65d9], [UIColor walme_colorWithRGB:0x8358d0]]
                                    size:CGSizeMake(0, 0)
                               isHorizon:YES];
}

+ (UIImage *)chatNavBarGradientLayerImage {
    return [[self chatNavBarGradientLayer] snapImage];
}


//+ (CAGradientLayer *)yellowGradientLayer {
//    return [CALayer yellowGradientLayerWithSize:CGSizeMake(0, 0)];
//}
//
//+ (CAGradientLayer *)yellowGradientLayerWithSize:(CGSize)size {
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = CGRectMake(0, 0, size.width, size.height);
//    gradient.startPoint = CGPointMake(0, 0);
//    gradient.endPoint = CGPointMake(1, 0);
//    gradient.locations = @[@0.25, @0.75];
//    gradient.colors = [NSArray arrayWithObjects:
//                       (id)[UIColor walme_colorWithHexString:@"ffa359"].CGColor,
//                       (id)[UIColor walme_colorWithHexString:@"ffc851"].CGColor,
//                       nil];
//    return gradient;
//}
//
//+ (UIImage *)yellowGradientImage {
//    return [[CALayer yellowGradientLayer] snapImage];
//}
//
//+ (UIImage *)yellowGradientImageWithSize:(CGSize)size {
//    return [[CALayer yellowGradientLayerWithSize:size] snapImage];
//}
//
//+ (UIImage *)redGradientImage {
//    CGSize size = CGSizeMake(0, 0);
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = CGRectMake(0, 0, size.width, size.height);
//    gradient.startPoint = CGPointMake(0, 0);
//    gradient.endPoint = CGPointMake(1, 0);
//    gradient.locations = @[@0.25, @0.75];
//    gradient.colors = [NSArray arrayWithObjects:
//                       (id)[UIColor walme_colorWithHexString:@"fe5353"].CGColor,
//                       (id)[UIColor walme_colorWithHexString:@"f89292"].CGColor,
//                       nil];
//    return [gradient snapImage];
//}

@end


@implementation CALayer (WALME_Frame)

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
