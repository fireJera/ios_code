//
//  UIFont+LETAD_Common.h
//  Test
//
//  Created by super on 2018/11/16.
//  Copyright © 2018 JerRen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

extern NSString * const kLETADPINGFANGSCREGULAR;

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END

@interface UIFont (LETAD_Common)

+ (UIFont *)letad_PingFangMediumWithSize:(CGFloat)size;
//+ (UIFont *)letad_PingFangRegularWithSize:(CGFloat)size;
+ (UIFont *)letad_PingFangSemboldWithSize:(CGFloat)size;
+ (UIFont *)letad_PingFangBoldWithSize:(CGFloat)size;

+ (UIFont *)letad_PingFangMedium11;
+ (UIFont *)letad_PingFangMedium12;
+ (UIFont *)letad_PingFangMedium13;
+ (UIFont *)letad_PingFangMedium14;
+ (UIFont *)letad_PingFangMedium15;
+ (UIFont *)letad_PingFangMedium16;
+ (UIFont *)letad_PingFangMedium18;
+ (UIFont *)letad_PingFangMedium20;
+ (UIFont *)letad_PingFangMedium24;
+ (UIFont *)letad_PingFangMedium25;
+ (UIFont *)letad_PingFangMedium30;
+ (UIFont *)letad_PingFangMedium35;
+ (UIFont *)letad_PingFangMedium50;

//+ (UIFont *)PingFangRegular13;
//+ (UIFont *)PingFangRegular15;
//+ (UIFont *)PingFangRegular18;

@end
