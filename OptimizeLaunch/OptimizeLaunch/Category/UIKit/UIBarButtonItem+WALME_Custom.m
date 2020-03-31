//
//  UIBarButtonItem+WALME_Custom.m
//  CodeFrame
//
//  Created by Jeremy on 2019/5/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "UIBarButtonItem+WALME_Custom.h"

@implementation UIBarButtonItem (WALME_Custom)

- (void)walme_titleColor:(UIColor *)color {
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName: color}
                        forState:UIControlStateNormal];
}

@end
