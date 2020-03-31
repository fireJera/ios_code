//
//  UIFont+WALME_Custom.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kWALMEPINGFANGSCREGULAR;

//@interface UIFont (JER_Custom)
//
//@property (nonatomic, readonly) BOOL isBold NS_AVAILABLE_IOS(7_0);
//@property (nonatomic, readonly) BOOL isItalic NS_AVAILABLE_IOS(7_0);
//@property (nonatomic, readonly) BOOL isMonoSpace NS_AVAILABLE_IOS(7_0);
//@property (nonatomic, readonly) BOOL isColorGlyphs NS_AVAILABLE_IOS(7_0);
//@property (nonatomic, readonly) CGFloat fontWeight NS_AVAILABLE_IOS(7_0);
//
//- (nullable UIFont *)fontWithBold NS_AVAILABLE_IOS(7_0);
//
//- (nullable UIFont *)fontWithItalic NS_AVAILABLE_IOS(7_0);
//
//- (nullable UIFont *)fontWithBoldItalic NS_AVAILABLE_IOS(7_0);
//
//- (nullable UIFont *)fontWithNormal NS_AVAILABLE_IOS(7_0);
//
//#pragma mark - creat font
//+ (nullable UIFont *)fontWithCTFont:(CTFontRef)CTFont;
//
//+ (nullable UIFont *)fontWithCGFont:(CGFontRef)CGFont size:(CGFloat)size;
//
//- (nullable CTFontRef)CTFontRef CF_RETURNS_RETAINED;
//
//- (nullable CGFontRef)CGFontRef CF_RETURNS_RETAINED;
//
////+ (BOOL)loadFontFromPath:(NSString *)path;
//
////+ (void)unloadFontFromPath:(NSString *)path;
//
////+ (nullable UIFont *)loadFontFromData:(NSData *)data;
//
////+ (BOOL)unloadFontFromData:(UIFont *)font;
//
////+ (nullable NSData *)dataFromFont:(UIFont *)font;
//
////+ (nullable NSData *)dataFromCGFont:(CGFontRef)cgFont;
//
//@end


@interface UIFont (WALME_Common)

+ (UIFont *)walme_PingFangMediumWithSize:(CGFloat)size;
+ (UIFont *)walme_PingFangRegularWithSize:(CGFloat)size;
+ (UIFont *)walme_PingFangSemboldWithSize:(CGFloat)size;
+ (UIFont *)walme_PingFangBoldWithSize:(CGFloat)size NS_UNAVAILABLE;

+ (UIFont *)walme_PingFangMedium10;
+ (UIFont *)walme_PingFangMedium11;
+ (UIFont *)walme_PingFangMedium12;
+ (UIFont *)walme_PingFangMedium13;
+ (UIFont *)walme_PingFangMedium14;
+ (UIFont *)walme_PingFangMedium15;
+ (UIFont *)walme_PingFangMedium16;
+ (UIFont *)walme_PingFangMedium17;
+ (UIFont *)walme_PingFangMedium18;
+ (UIFont *)walme_PingFangMedium19;
+ (UIFont *)walme_PingFangMedium20;
+ (UIFont *)walme_PingFangMedium24;
+ (UIFont *)walme_PingFangMedium25;
+ (UIFont *)walme_PingFangMedium30;
+ (UIFont *)walme_PingFangMedium35;
+ (UIFont *)walme_PingFangMedium50;

//+ (UIFont *)PingFangRegular13;
//+ (UIFont *)PingFangRegular15;
//+ (UIFont *)PingFangRegular18;

@end

NS_ASSUME_NONNULL_END
