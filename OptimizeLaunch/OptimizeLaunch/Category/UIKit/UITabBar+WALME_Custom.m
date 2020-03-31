    //
//  UITabBar+WALME_Custom.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "UITabBar+WALME_Custom.h"
#import "WALMETabBarBtn.h"
#import "UIColor+WALME_Hex.h"

@implementation UITabBar (WALME_Badge)

- (void)initUnreadCountButton:(CGRect)frame tag:(NSUInteger)tag badgeValue:(NSUInteger)badgeValue {
    WALMETabBarBtn *btn = [[WALMETabBarBtn alloc] initWithFrame:frame];
    btn.layer.borderWidth = 2;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.cornerRadius = 9; //圆形
    btn.unreadCount = [NSString stringWithFormat:@"%lu", (unsigned long)badgeValue];
    btn.tag = tag;
    [self addSubview:btn];
}
//移除小红点
- (void)removeBadgeOnItemIndex:(int)index {
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888 + index) {
            //            [((WALMETabBarBtn *)subView).shapeLayer removeFromSuperlayer];
            [subView removeFromSuperview];
        }
    }
}
//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index {
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

- (void)showBadgeOnItemIndex:(int)index {
    //新建小红点
    const CGFloat width = 8;
    UIView *badgeView = [[UIView alloc] init];
    badgeView.backgroundColor = [UIColor walme_colorWithRGB:0xff6161]; //颜色：红色
    badgeView.layer.cornerRadius = width / 2;                                           //圆形
    badgeView.tag = 888 + index;
    
    NSInteger itemCount = self.items.count;
    float percentX = (index + 0.55) / itemCount;
    CGFloat y = ceilf(0.1 * self.frame.size.height);
    CGFloat x = ceilf(percentX * self.frame.size.width);
    badgeView.frame = CGRectMake(x, y, width, width); //圆形大小为10
    [self removeBadgeOnItemIndex:index];
    [self addSubview:badgeView];
}

- (void)showBadgeOnItemIndex:(int)index badgeValue:(NSUInteger)badgeValue {
    //新建小红点
    NSInteger itemCount = self.items.count;
    float percentX = (index + 0.55) / itemCount;
    CGFloat y = ceilf(0.1 * self.frame.size.height);
    CGFloat x = ceilf(percentX * self.frame.size.width);
    [self removeBadgeOnItemIndex:index];
    if (badgeValue == 0) {
        
    }
    else if (badgeValue < 10) {
        [self initUnreadCountButton:CGRectMake(x, y, 18, 18) tag:888 + index badgeValue:badgeValue];
    }
    else if (badgeValue >= 10 && badgeValue < 100) {
        [self initUnreadCountButton:CGRectMake(x, y, 22, 18) tag:888 + index badgeValue:badgeValue];
    }
    else if (badgeValue >= 100) {
        WALMETabBarBtn *btn = [[WALMETabBarBtn alloc] initWithFrame:CGRectMake(x, y, 22, 18)];
        [self initUnreadCountButton:CGRectMake(x, y, 22, 18) tag:888 + index badgeValue:1];
        [btn setTitle:@"..." forState:UIControlStateNormal];
        //        [btn setImage:[UIImage imageNamed:@"walme_forall_10"] forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.tag = 888 + index;
    }
}

@end
