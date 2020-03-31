//
//  WALMETabbar.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMETabbar.h"
#import "WALMEViewHelper.h"
#import "UIView+WALME_Frame.h"

@implementation WALMETabBar

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    _centerBtn = [WALMEViewHelper walme_buttonWithFrame:CGRectZero
                                                bgImage:nil
                                                  image:@"walme_tab_3"
                                                  title:nil
                                              textColor:nil
                                                 method:nil
                                                 target:nil];
    [self addSubview:_centerBtn];
    //    self.barTintColor = [UIColor whiteColor];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    Class class = NSClassFromString(@"UITabBarButton");
    _centerBtn.centerX = self.width / 2;
    _centerBtn.top = -20;
    
    NSInteger btnIndex = 0;
    for (UIView *btn in self.subviews) {
        if ([btn isKindOfClass:class]) {
            btn.width = (self.width - self.centerBtn.width) * 0.5;
            if (btnIndex < 1) {
                btn.left = btn.width * btnIndex;
            } else {
                btn.left = btn.width * btnIndex + self.centerBtn.width;
            }
            btnIndex++;
            if (btnIndex == 0) {
                btnIndex++;
            }
        }
    }
    [self bringSubviewToFront:_centerBtn];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isHidden) {
        CGPoint btnPoint = [self convertPoint:point toView:_centerBtn];
        if ([_centerBtn pointInside:btnPoint withEvent:event]) {
            return _centerBtn;
        }
    }
    return [super hitTest:point withEvent:event];
}

@end

