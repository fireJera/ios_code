//
//  WALMELabelView.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMELabelView.h"
#import "WALMETextUtils.h"
#import "UIView+WALME_Frame.h"

#import "WALMECoreTextData.h"
#import "WALMETextLinkData.h"
#import "WALMEFrameParse.h"
#import "WALMEFrameParseConfig.h"

//@interface WALMELabelView () <UIGestureRecognizerDelegate>
//
//@end

@implementation WALMELabelView

//+ (instancetype)labelWithTextComponent:(NSArray<WALMELabelComponent *> *)components {
//    return [[self alloc] initWithTextComponent:components];
//}
//
//- (instancetype)initWithTextComponent:(NSArray<WALMELabelComponent *> *)components {
//    
//}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self p_walme_setupEvents];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self p_walme_setupEvents];
    }
    return self;
}

- (void)p_walme_setupEvents {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_walme_TapDetected:)];
    //    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)p_walme_TapDetected:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    WALMETextLinkData * linkData = [WALMETextUtils walme_touchLinkInView:self atPoint:point data:_data];
    if (linkData) {
        if (_clickBlock) {
            _clickBlock(linkData);
        }
//        if ([_delegate respondsToSelector:@selector(walme_clickText:)]) {
//            [_delegate walme_clickText:linkData];
//        }
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //获取当前绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //旋转坐标系(默认和UIKit坐标是相反的)
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (_data) {
        CTFrameDraw(_data.ctFrame, context);
    }
}

@end
