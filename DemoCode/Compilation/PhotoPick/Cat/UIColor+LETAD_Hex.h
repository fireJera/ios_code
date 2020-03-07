//
//  UIColor+AppSetting.h
//  wft
//
//  Created by JSen on 14/10/8.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LETAD_Hex)

+ (UIColor *)letad_colorWithRGB:(int)rgb;
+ (UIColor *)letad_colorWithRGB:(int)rgb alpha:(CGFloat)alpha;

// new  use this
+ (UIColor *)letad_colorWithHexString:(NSString *)hexStr;

#pragma mark - common
+ (UIColor *)themeGrayColor;
//#pragma mark 登录页
+ (UIColor *)btnGreenColor;

#pragma mark - date
+ (UIColor *)menuSelectedColor;

+ (UIColor *)graySixEColor;

+ (UIColor *)cameraGrayColor;

//#pragma mark - Home
//
+ (UIColor *)blackTextColor;
+ (UIColor *)femaleBlueColor;
+ (UIColor *)grayTextColor;
+ (UIColor *)maleRedColor;
+ (UIColor *)HomeTagTextColor;
+ (UIColor *)seperatorLineColor;
+ (UIColor *)orangeBtnColor;
+ (UIColor *)btnDisableColor;
+ (UIColor *)weekGrayColor;

@end
