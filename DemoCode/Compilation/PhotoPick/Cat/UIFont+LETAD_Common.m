//
//  UIFont+JER_Custom.m
//  Test
//
//  Created by super on 2018/11/16.
//  Copyright © 2018 JerRen. All rights reserved.
//

#import "UIFont+LETAD_Common.h"

//@implementation UIFont (JER_Custom)
//
//- (BOOL)isBold {
//    if (![self respondsToSelector:@selector(fontDescriptor)]) return NO;
//    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold) > 0;
//}
//
//- (BOOL)isItalic {
//    if (![self respondsToSelector:@selector(fontDescriptor)]) return NO;
//    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitItalic) > 0;
//}
//
//- (BOOL)isMonoSpace {
//    if (![self respondsToSelector:@selector(fontDescriptor)]) return NO;
//    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitMonoSpace) > 0;
//}
//
//- (BOOL)isColorGlyphs {
//    if (![self respondsToSelector:@selector(fontDescriptor)]) return NO;
//    return (CTFontGetSymbolicTraits((__bridge CTFontRef)self) & kCTFontColorGlyphsTrait) != 0;
//}
//
//- (CGFloat)fontWeight {
//    NSDictionary * traits = [self.fontDescriptor objectForKey:UIFontDescriptorTraitsAttribute];
//    return [traits[UIFontWeightTrait] floatValue];
//}
//
//- (UIFont *)fontWithBold {
//    if (![self respondsToSelector:@selector(fontDescriptor)]) return self;
//    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:self.pointSize];
//}
//
//- (UIFont *)fontWithItalic {
//    if (![self respondsToSelector:@selector(fontDescriptor)]) return self;
//    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:self.pointSize];
//}
//
//- (UIFont *)fontWithBoldItalic {
//    if (![self respondsToSelector:@selector(fontDescriptor)]) return self;
//    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic] size:self.pointSize];
//}
//
//- (UIFont *)fontWithNormal {
//    if (![self respondsToSelector:@selector(fontDescriptor)]) return self;
//    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:0] size:self.pointSize];
//}
//
//+ (UIFont *)fontWithCTFont:(CTFontRef)CTFont {
//    if (!CTFont) return nil;
//    CFStringRef name = CTFontCopyPostScriptName(CTFont);
//    if (!name) return nil;
//    CGFloat size = CTFontGetSize(CTFont);
//    UIFont * font = [UIFont fontWithName:(__bridge NSString *)name size:size];
//    CFRelease(name);
//    return font;
//}
//
//+ (UIFont *)fontWithCGFont:(CGFontRef)CGFont size:(CGFloat)size {
//    if (!CGFont) return nil;
//    CFStringRef name = CGFontCopyPostScriptName(CGFont);
//    if (!name) return nil;
//    UIFont * font = [UIFont fontWithName:(__bridge NSString *)name size:size];
//    CFRelease(name);
//    return font;
//}
//
//- (CTFontRef)CTFontRef {
//    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)self.fontName, self.pointSize, NULL);
//    return font;
//}
//
//- (CGFontRef)CGFontRef {
//    CGFontRef font = CGFontCreateWithFontName((__bridge CFStringRef)self.fontName);
//    return font;
//}
//
//@end

@implementation UIFont (LETAD_Common)

static NSString * const kLETADPINGFANGSCLIGHT = @"PingFangSC-Light";
static NSString * const kLETADPINGFANGSCMEDIUM = @"PingFangSC-Medium";
NSString * const kLETADPINGFANGSCREGULAR = @"PingFangSC-Regular";
static NSString * const kLETADPINGFANGSCSemibold = @"PingFangSC-Semibold";
static NSString * const kLETADPINGFANGSCBold = @"PingFangSC-Bold";

+ (UIFont *)letad_PingFangMediumWithSize:(CGFloat)size {
    return [UIFont fontWithName:kLETADPINGFANGSCMEDIUM size:size];
}
//
//+ (UIFont *)letad_PingFangRegularWithSize:(CGFloat)size {
//    return [UIFont fontWithName:kLETADPINGFANGSCREGULAR size:size];
//}
//
+ (UIFont *)letad_PingFangSemboldWithSize:(CGFloat)size {
    return [UIFont fontWithName:kLETADPINGFANGSCSemibold size:size];
}

+ (UIFont *)letad_PingFangBoldWithSize:(CGFloat)size {
    return [UIFont fontWithName:kLETADPINGFANGSCBold size:size];
}

+ (UIFont *)letad_PingFangMedium11 {
    return [self letad_PingFangMediumWithSize:11];
}

+ (UIFont *)letad_PingFangMedium12 {
    return [self letad_PingFangMediumWithSize:12];
}

+ (UIFont *)letad_PingFangMedium13 {
    return [self letad_PingFangMediumWithSize:13];
}

+ (UIFont *)letad_PingFangMedium14 {
    return [self letad_PingFangMediumWithSize:14];
}

+ (UIFont *)letad_PingFangMedium15 {
    return [self letad_PingFangMediumWithSize:15];
}

+ (UIFont *)letad_PingFangMedium16 {
    return [self letad_PingFangMediumWithSize:16];
}

+ (UIFont *)letad_PingFangMedium18 {
    return [self letad_PingFangMediumWithSize:18];
}

+ (UIFont *)letad_PingFangMedium20 {
    return [self letad_PingFangMediumWithSize:20];
}

+ (UIFont *)letad_PingFangMedium24 {
    return [self letad_PingFangMediumWithSize:24];
}

+ (UIFont *)letad_PingFangMedium25 {
    return [self letad_PingFangMediumWithSize:25];
}

+ (UIFont *)letad_PingFangMedium30 {
    return [self letad_PingFangMediumWithSize:30];
}

+ (UIFont *)letad_PingFangMedium35 {
    return [self letad_PingFangMediumWithSize:35];
}

+ (UIFont *)letad_PingFangMedium50 {
    return [self letad_PingFangMediumWithSize:50];
}
//
//+ (UIFont *)PingFangRegular13 {
//    return [self letad_PingFangRegularWithSize:13];
//}
//
//+ (UIFont *)PingFangRegular15 {
//    return [self letad_PingFangRegularWithSize:15];
//}
//
//+ (UIFont *)PingFangRegular18 {
//    return [self letad_PingFangRegularWithSize:18];
//}

@end
