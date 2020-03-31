//
//  UITabBar+WALME_Custom.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (WALME_Custom)

//重写是为了修改badge小红点儿的颜色
- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
- (void)showBadgeOnItemIndex:(int)index; //显示小红点
- (void)showBadgeOnItemIndex:(int)index badgeValue:(NSUInteger)badgeValue; //显示带badge的红点

@end

NS_ASSUME_NONNULL_END
