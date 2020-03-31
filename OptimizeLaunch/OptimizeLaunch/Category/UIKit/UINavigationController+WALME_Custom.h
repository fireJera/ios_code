//
//  UINavigationController+WALME_Custom.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (WALME_Custom)

- (void)setNeedsNavigationBackground:(CGFloat)alpha;

@end

@interface UINavigationController (JER_NavBarDelegate) <UINavigationBarDelegate>

@end
NS_ASSUME_NONNULL_END
