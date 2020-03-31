//
//  UIFont+WALME_Custom.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "UIFont+WALME_Custom.h"

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

@implementation UIFont (WALME_Common)

static NSString * const kWALMEPINGFANGSCLIGHT = @"PingFangSC-Light";
static NSString * const kWALMEPINGFANGSCMEDIUM = @"PingFangSC-Medium";
NSString * const kWALMEPINGFANGSCREGULAR = @"PingFangSC-Regular";
static NSString * const kWALMEPINGFANGSCSemibold = @"PingFangSC-Semibold";
static NSString * const kWALMEPINGFANGSCBold = @"PingFangSC-Bold";

+ (UIFont *)walme_PingFangMediumWithSize:(CGFloat)size {
    return [UIFont fontWithName:kWALMEPINGFANGSCMEDIUM size:size];
}

+ (UIFont *)walme_PingFangRegularWithSize:(CGFloat)size {
    return [UIFont fontWithName:kWALMEPINGFANGSCREGULAR size:size];
}

+ (UIFont *)walme_PingFangSemboldWithSize:(CGFloat)size {
    return [UIFont fontWithName:kWALMEPINGFANGSCSemibold size:size];
}

+ (UIFont *)walme_PingFangBoldWithSize:(CGFloat)size {
    return [UIFont fontWithName:kWALMEPINGFANGSCBold size:size];
}

+ (UIFont *)walme_PingFangMedium10 {
    return [self walme_PingFangMediumWithSize:10];
}

+ (UIFont *)walme_PingFangMedium11 {
    return [self walme_PingFangMediumWithSize:11];
}

+ (UIFont *)walme_PingFangMedium12 {
    return [self walme_PingFangMediumWithSize:12];
}

+ (UIFont *)walme_PingFangMedium13 {
    return [self walme_PingFangMediumWithSize:13];
}

+ (UIFont *)walme_PingFangMedium14 {
    return [self walme_PingFangMediumWithSize:14];
}

+ (UIFont *)walme_PingFangMedium15 {
    return [self walme_PingFangMediumWithSize:15];
}

+ (UIFont *)walme_PingFangMedium16 {
    return [self walme_PingFangMediumWithSize:16];
}

+ (UIFont *)walme_PingFangMedium17 {
    return [self walme_PingFangMediumWithSize:17];
}

+ (UIFont *)walme_PingFangMedium18 {
    return [self walme_PingFangMediumWithSize:18];
}

+ (UIFont *)walme_PingFangMedium19 {
    return [self walme_PingFangMediumWithSize:19];
}

+ (UIFont *)walme_PingFangMedium20 {
    return [self walme_PingFangMediumWithSize:20];
}

+ (UIFont *)walme_PingFangMedium24 {
    return [self walme_PingFangMediumWithSize:24];
}

+ (UIFont *)walme_PingFangMedium25 {
    return [self walme_PingFangMediumWithSize:25];
}

+ (UIFont *)walme_PingFangMedium30 {
    return [self walme_PingFangMediumWithSize:30];
}

+ (UIFont *)walme_PingFangMedium35 {
    return [self walme_PingFangMediumWithSize:35];
}

+ (UIFont *)walme_PingFangMedium50 {
    return [self walme_PingFangMediumWithSize:50];
}
//
//+ (UIFont *)PingFangRegular13 {
//    return [self systemFontOfSize:13];
//}
//
//+ (UIFont *)PingFangRegular15 {
//    return [self systemFontOfSize:15];
//}
//
//+ (UIFont *)PingFangRegular18 {
//    return [self systemFontOfSize:18];
//}

@end
