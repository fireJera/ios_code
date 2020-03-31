//
//  UIWindow+WALME_Custom.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "UIWindow+WALME_Custom.h"

@implementation UIWindow (WALME_Custom)

- (UIImage *)snapImage {
    CGSize imageSize = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.center.x, self.center.y);
    CGContextConcatCTM(context, self.transform);
    CGContextTranslateCTM(context, - self.bounds.size.width * self.layer.anchorPoint.x, -self.bounds.size.height * self.layer.anchorPoint.y);
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
