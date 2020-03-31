//
//  WALMETextUtils.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMETextUtils.h"
#import "WALMECoreTextData.h"
#import "WALMETextLinkData.h"

@implementation WALMETextUtils

+ (WALMETextLinkData *)walme_touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(WALMECoreTextData *)data {
    CTFrameRef textFrame = data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFrame);
    if (!lines) {
        return nil;
    }
    CFIndex count = CFArrayGetCount(lines);
    WALMETextLinkData * foundLink = nil;
    
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGRect flippedRect = [self p_walme_getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        if (CGRectContainsPoint(rect, point)) {
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            CFIndex idx = CTLineGetStringIndexForPosition(line, relativePoint);
            foundLink = [self p_walme_linkAtIndex:idx linkArray:data.linkArray];
            return foundLink;
        }
    }
    return nil;
}

+ (CGRect)p_walme_getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y, width, height);
}

+ (WALMETextLinkData *)p_walme_linkAtIndex:(CFIndex)i linkArray:(NSArray<WALMETextLinkData *> *)linkArray {
    WALMETextLinkData * link = nil;
    for (WALMETextLinkData * data in linkArray) {
        if (NSLocationInRange(i, data.range)) {
            link = data;
            break;
        }
    }
    return link;
}

@end
