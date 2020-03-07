//
//  UIImageView+LETAD_Frame.h
//  Orange
//
//  Created by JerRen on 03/11/2017.
//  Copyright © 2018 JerRen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LETAD_Frame)

//这些不是真正的属性哦，不要误会
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

@interface UIView (LETAD_ViewController)

@property (nonatomic, assign, readonly) UIViewController * viewController;

@end

@interface UIView (LETAD_SubView)

- (void)removeAllSubViews;

@end

@interface UIView (LETADLoad)

//- (void)bringToFront;
//- (void)sendToBack;

@end

@interface UIView (LETADCorner)

- (void)addCorner:(CGFloat)radius;

- (void)addCorner:(CGFloat)radius
      borderWidth:(CGFloat)width
          bgColor:(UIColor *)bgColor
      borderColor:(UIColor *)color;

#if !TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) CGFloat layerCornerRadius;
@property (nonatomic, assign) UIColor * layerBorderColor;
@property (nonatomic, assign) CGFloat layerBorderWidth;
#else
@property (nonatomic, assign) IBInspectable CGFloat layerCornerRadius;
@property (nonatomic, assign) IBInspectable UIColor * layerBorderColor;
@property (nonatomic, assign) IBInspectable CGFloat layerBorderWidth;
#endif

@end

@interface UIView (LETADImage)

- (UIImage *)snapImage;

@end
