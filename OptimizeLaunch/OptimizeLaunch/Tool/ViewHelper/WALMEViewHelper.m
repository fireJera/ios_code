//
//  WALMEViewHelper.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEViewHelper.h"
#import "UIFont+WALME_Custom.h"
#import "UIView+WALME_Frame.h"

@implementation WALMEViewHelper

+ (nonnull UIButton *)walme_buttonWithFrame:(CGRect)frame
                                    bgImage:(nullable NSString *)bgImageName
                                      image:(nullable NSString *)imageName
                                      title:(nullable NSString *)title
                                  textColor:(nullable UIColor *)color
                                     method:(nullable SEL)method
                                     target:(nullable id)target;
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (color) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    if (imageName) {
        UIImage * image = [UIImage imageNamed:imageName];
        if (CGRectEqualToRect(frame, CGRectZero)) {
            if (image) {
                frame.size = image.size;
            }
        }
        [button setImage:image forState:UIControlStateNormal];
    }
    if (bgImageName) {
        [button setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    if (target && method) {
        [button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    }
    button.frame = frame;
    return button;
}

+ (nonnull UILabel *)walme_labelWithFrame:(CGRect)frame
                                    title:(nullable NSString *)title
                                 fontSize:(int)font
                                textColor:(nullable UIColor *)textColor
{
    return [self walme_labelWithFrame:frame title:title font:[UIFont systemFontOfSize:font] textColor:textColor];
}

+ (nonnull UILabel *)walme_labelWithFrame:(CGRect)frame
                                    title:(nullable NSString *)title
                                     font:(UIFont *)font
                                textColor:(nullable UIColor *)textColor
{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    if (textColor) {
        label.textColor = textColor;
    } else {
        label.textColor = [UIColor blackColor];
    }
    if (title) {
        label.text = title;
    }
    label.font = font;
    return label;
}

//+ (nonnull UITableView *)tableViewWithFrame:(CGRect)frame
//                               deleagte:(nullable id)delegate
//                             dateSource:(nullable id)dataSource
//                                  style:(UITableViewStyle)style
//{
//    UITableView * tableView = [[UITableView alloc] initWithFrame:frame style:style];
//    if (dataSource) {
//        tableView.dataSource = dataSource;
//    }
//    if (delegate) {
//        tableView.delegate = delegate;
//    }
//    return tableView;
//}

+ (nonnull UIImageView *)imageViewWithFrame:(CGRect)frame
                                  imageName:(nullable NSString *)imageName
{
    return [WALMEViewHelper imageViewWithFrame:frame
                                         image:[UIImage imageNamed:imageName]];
}

+ (nonnull UIImageView *)imageViewWithFrame:(CGRect)frame
                                      image:(nullable UIImage *)image
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    if (image) {
        [imageView setImage:image];
    }
    return imageView;
}

//+ (nonnull UIScrollView *)scrollViewWithFrame:(CGRect)frame delegate:(nullable id)delegate {
//    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:frame];
//    if (delegate) {
//        scrollView.delegate = delegate;
//    }
//    return scrollView;
//}

//+ (CAShapeLayer *)shadowLayer {
//    CAShapeLayer * shadowLayer = [CAShapeLayer new];
//    shadowLayer.fillColor = [UIColor whiteColor].CGColor;
//    [self addShadowTo:shadowLayer];
//    return shadowLayer;
//}
//
//+ (void)addShadowTo:(CALayer *)layer {
//    [self addShadowTo:layer opacity:0.4 offset:CGSizeMake(4, 4) radius:9 color:[UIColor shadowColor]];
//}

+ (void)addShadowTo:(CALayer *)layer opacity:(float)opacity offset:(CGSize)offset radius:(int)radius color:(UIColor *)color {
    layer.shadowColor = color.CGColor;
    layer.shadowOpacity = opacity;
    layer.shadowRadius = radius;
    layer.shadowOffset = offset;
    //    layer.shouldRasterize = YES;
    //    layer.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
