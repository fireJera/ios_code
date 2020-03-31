//
//  UIColor+WALME_Hex.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/* color */
#define kColorWithRGB(rgb_)             ([UIColor walme_colorWithRGB:rgb_])
#define kColorWithRGBAlpah(rgb_,alpha_) ([UIColor walme_colorWithRGB:rgb_ alpha:alpha_])
#define kColorWithHexStr(hexStr)        [UIColor walme_colorWithHexString:hexStr]

@interface UIColor (WALME_Hex)

+ (UIColor *)walme_colorWithRGB:(int)rgb;
+ (UIColor *)walme_colorWithRGB:(int)rgb alpha:(CGFloat)alpha;

// new use this #ffffff #ffffffff都可以
+ (UIColor *)walme_colorWithHexString:(NSString *)hexStr;

@end

NS_ASSUME_NONNULL_END
