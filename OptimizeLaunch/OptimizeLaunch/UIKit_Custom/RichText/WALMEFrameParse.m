//
//  WALMEFrameParse.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEFrameParse.h"
#import "WALMEFrameParseConfig.h"
#import "WALMECoreTextData.h"
#import "WALMETextLinkData.h"
#import "UIFont+WALME_Custom.h"
#import "UIColor+WALME_Hex.h"

@implementation WALMEFrameParse

+ (NSDictionary *)walme_attributesWithConfig:(WALMEFrameParseConfig *)config {
    CGFloat lineSpcing = config.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat),&lineSpcing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat),&lineSpcing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat),&lineSpcing},
    };
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    UIColor * textColor = config.textColor;
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)kWALMEPINGFANGSCREGULAR, fontSize, NULL);
    
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(fontRef);
    CFRelease(theParagraphRef);
    return dict;
}

+ (WALMECoreTextData *)walme_parseContent:(NSString *)content config:(WALMEFrameParseConfig *)config {
    NSDictionary * attributes = [self walme_attributesWithConfig:config];
    NSAttributedString * contextString = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    
    //创建CTFrameSetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contextString);
    
    //获得要绘制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    //生成CTFrameRef实例
    CTFrameRef frame = [self p_walme_createFrameWithFrameSetter:framesetter config:config height:textHeight];
    
    //将生成好的CTFrameRef实例和计算好的绘制高度保存到CoreTextData实例中，最后返回CoreTextData实例
    WALMECoreTextData * data = [[WALMECoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    
    //释放内存
    CFRelease(framesetter);
    CFRelease(frame);
    return data;
}

+ (CTFrameRef)p_walme_createFrameWithFrameSetter:(CTFramesetterRef)framesetter
                                          config:(WALMEFrameParseConfig *)config
                                          height:(CGFloat)height {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(config.leftInterval, config.topInterval, config.width, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

+ (WALMECoreTextData *)walme_parseTemplateFile:(NSString *)path config:(WALMEFrameParseConfig *)config {
    NSMutableArray<WALMETextLinkData *> * linkArray = [NSMutableArray array];
    NSMutableArray * imageArray = [NSMutableArray array];
    NSAttributedString * content = [self p_walme_loadTemplateFile:path
                                                           config:config
                                                       imageArray:imageArray
                                                        linkArray:linkArray];
    WALMECoreTextData * data = [self p_walme_parseAttributedContent:content config:config];
    //    data.imageArray = imageArray;
    data.linkArray = linkArray;
    return data;
}

+ (WALMECoreTextData *)walme_parseDictionary:(NSDictionary *)dictionary config:(WALMEFrameParseConfig *)config {
    NSMutableArray<WALMETextLinkData *> * linkArray = [NSMutableArray array];
    NSMutableArray * imageArray = [NSMutableArray array];
    NSAttributedString * content = [self p_walme_parseData:nil
                                                    config:config
                                                imageArray:imageArray
                                                 linkArray:linkArray];
    
    WALMECoreTextData * data = [self p_walme_parseAttributedContent:content config:config];
    data.linkArray = linkArray;
    //    data.imageArray = imageArray;
    return data;
}

+ (WALMECoreTextData *)walme_parseArray:(NSArray *)array config:(WALMEFrameParseConfig *)config {
    NSMutableArray<WALMETextLinkData *> * linkArray = [NSMutableArray array];
    NSMutableArray * imageArray = [NSMutableArray array];
    NSAttributedString * content = [self p_walme_parseData:array
                                                    config:config
                                                imageArray:imageArray
                                                 linkArray:linkArray];
    
    WALMECoreTextData * data = [self p_walme_parseAttributedContent:content config:config];
    data.linkArray = linkArray;
    //    data.imageArray = imageArray;
    return data;
}

+ (NSAttributedString *)p_walme_loadTemplateFile:(NSString *)path
                                          config:(WALMEFrameParseConfig *)config
                                      imageArray:(NSMutableArray *)imageArray
                                       linkArray:(NSMutableArray<WALMETextLinkData *> *)linkArray {
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString * result = [[NSMutableAttributedString alloc] init];
    if (data) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        result = [self p_walme_parseData:array config:config imageArray:imageArray linkArray:linkArray];
    }
    return result;
}

+ (NSMutableAttributedString *)p_walme_parseData:(NSArray *)array
                                          config:(WALMEFrameParseConfig *)config
                                      imageArray:(NSMutableArray *)imageArray
                                       linkArray:(NSMutableArray<WALMETextLinkData *> *)linkArray {
    NSMutableAttributedString * result = [[NSMutableAttributedString alloc] init];
    if ([array isKindOfClass:[NSArray class]]) {
        for (NSDictionary * dict in array) {
            NSString * type = dict[@"type"];
            if ([type isEqualToString:@"txt"]) {
                NSAttributedString * as = [self p_walme_parseAttributeContentFromNSDictionary:dict config:config];
                [result appendAttributedString:as];
            }
            else if ([type isEqualToString:@"event"]) {
                NSUInteger startPos = result.length;
                NSAttributedString * as = [self p_walme_parseAttributeContentFromNSDictionary:dict config:config];
                [result appendAttributedString:as];
                
                NSUInteger length = result.length - startPos;
                NSRange linkRange = NSMakeRange(startPos, length);
                WALMETextLinkData * linkData = [[WALMETextLinkData alloc] init];
                linkData.title = dict[@"content"];
                linkData.request = dict[@"request"];
                linkData.range = linkRange;
                [linkArray addObject:linkData];
            }
        }
    }
    return result;
}

+ (NSAttributedString *)p_walme_loadTemplateFile:(NSString *)path config:(WALMEFrameParseConfig *)config {
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString * result = [[NSMutableAttributedString alloc] init];
    
    if (data) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary * dict in array) {
                NSString * type = dict[@"type"];
                if ([type isEqualToString:@"txt"]) {
                    NSAttributedString * as = [self p_walme_parseAttributeContentFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];
                }
            }
        }
    }
    return result;
}

+ (NSAttributedString *)p_walme_parseAttributeContentFromNSDictionary:(NSDictionary *)dict
                                                               config:(WALMEFrameParseConfig *)config {
    NSMutableDictionary * attributes = [NSMutableDictionary dictionaryWithDictionary:[self walme_attributesWithConfig:config]];
    UIColor * color = [self p_walme_colorFromTemplate:dict[@"color"]];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    } else {
        color = config.textColor;
    }
    
    if (dict[@"style"]) {
        NSString * style = dict[@"style"];
        if ([style isEqualToString:@"Underline"]) {
            attributes[(id)kCTUnderlineStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
            //设置下划线颜色
            attributes[(id)kCTUnderlineColorAttributeName] = (__bridge id)(color.CGColor);
        }
    }
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)kWALMEPINGFANGSCREGULAR, fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    NSString * content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

+ (UIColor *)p_walme_colorFromTemplate:(NSString *)name {
    if (name) {
        return [UIColor walme_colorWithHexString:name];
    } else {
        return nil;
    }
}

+ (WALMECoreTextData *)p_walme_parseAttributedContent:(NSAttributedString *)content config:(WALMEFrameParseConfig *)config {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    CGFloat textWidth = coreTextSize.width;
    
    CTFrameRef frame = [self p_walme_createFrameWithFrameSetter:framesetter config:config height:textHeight];
    
    WALMECoreTextData * data = [[WALMECoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight + config.topInterval * 2;
    data.width = textWidth + config.leftInterval * 2;
    
    CFRelease(framesetter);
    CFRelease(frame);
    
    return data;
}

#pragma mark - 添加设置CTRunDelegate信息的方法

static CGFloat p_walme_ascentCallback(void *ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
}

static CGFloat p_walme_descentCallback(void *ref) {
    return 0;
}

static CGFloat p_walme_widthCallback(void *ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"width"] floatValue];
}

+ (NSAttributedString *)p_walme_parseImageDataFromNSDictionary:(NSDictionary *)dict config:(WALMEFrameParseConfig *)config {
    
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = p_walme_ascentCallback;
    callbacks.getDescent = p_walme_descentCallback;
    callbacks.getWidth = p_walme_widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)dict);
    
    unichar objectReplacementChar = 0xFFFC;
    NSString * content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary * attributes = [self walme_attributesWithConfig:config];
    NSMutableAttributedString * space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}

@end
