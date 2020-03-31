//
//  CALayer+WALME_Custom.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (WALME_Custom)

@property (nonatomic, strong) UIColor * borderIBColor;
@property (nonatomic, strong) UIColor * shadowIBColor;

- (void)setShadowIBColor:(UIColor *)shadowIBColor;
- (void)setBorderIBColor:(UIColor *)borderIBColor;

- (UIColor *)shadowIBColor;
- (UIColor *)borderIBColor;

- (nullable UIImage *)snapImage;

+ (CAGradientLayer *)verticalGradientLayerWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;
+ (CAGradientLayer *)horizonGradientLayerWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;
+ (CAGradientLayer *)gradientLayerWithColors:(NSArray<UIColor *> *)colors size:(CGSize)size isHorizon:(BOOL)isHorizon;

+ (CAGradientLayer *)navBarGradientLayer;
+ (UIImage *)navBarGradientLayerImage;

+ (CAGradientLayer *)chatNavBarGradientLayer;
+ (UIImage *)chatNavBarGradientLayerImage;

//+ (CAGradientLayer *)yellowGradientLayer;
//+ (CAGradientLayer *)yellowGradientLayerWithSize:(CGSize)size;
//+ (UIImage *)yellowGradientImage;
//+ (UIImage *)yellowGradientImageWithSize:(CGSize)size;
//
//+ (UIImage *)redGradientImage;

@end

@interface CALayer (WALME_Frame)

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;

@end

NS_ASSUME_NONNULL_END
