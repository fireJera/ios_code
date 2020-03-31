    //
//  UIImageView+WALME_Custom.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "UIImageView+WALME_Custom.h"
#import "UIImage+WALME_Custom.h"

@implementation UIImageView (WALME_Custom)

- (void)addCornerToImage:(CGFloat)radius {
    self.image = [self.image addCornerRadius:radius];
}

@end
