
//
//  UIView+HUD.m
//  PhotoPick
//
//  Created by Jeremy on 2019/3/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "UIView+HUD.h"
#import "AlbumTool.h"

@implementation UIView (HUD)

- (void)showImageHUDText:(NSString *)text
{
    CGFloat hudW = [AlbumTool getTextWidth:text height:15 fontSize:14];
    if (hudW > self.frame.size.width - 60) {
        hudW = self.frame.size.width - 60;
    }
    CGFloat hudH = [AlbumTool getTextHeight:text width:hudW fontSize:14];
    if (hudW < 100) {
        hudW = 100;
    }
    HUD *hud = [[HUD alloc] initWithFrame:CGRectMake(0, 0, hudW + 20, 110 + hudH - 15) imageName:@"alert_failed_icon@2x.png" text:text];
    hud.alpha = 0;
    hud.tag = 1008611;
    [self addSubview:hud];
    hud.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [UIView animateWithDuration:0.25 animations:^{
        hud.alpha = 1;
    }];
    [UIView cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(handleGraceTimer) withObject:nil afterDelay:1.5f inModes:@[NSRunLoopCommonModes]];
}

- (void)showLoadingHUDText:(NSString *)text
{
    CGFloat hudW = [AlbumTool getTextWidth:text height:15 fontSize:14];
    if (hudW > self.frame.size.width - 60) {
        hudW = self.frame.size.width - 60;
    }
    CGFloat hudH = [AlbumTool getTextHeight:text width:hudW fontSize:14];
    
    HUD *hud = [[HUD alloc] initWithFrame:CGRectMake(0, 0, 110, 110 + hudH - 15) imageName:@"alert_failed_icon@2x.png" text:text];
    [hud showloading];
    hud.alpha = 0;
    hud.tag = 10086;
    [self addSubview:hud];
    hud.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [UIView animateWithDuration:0.25 animations:^{
        hud.alpha = 1;
    }];
}

- (void)handleLoading
{
    [UIView cancelPreviousPerformRequestsWithTarget:self];
    for (UIView *view in self.subviews) {
        if (view.tag == 10086) {
            [UIView animateWithDuration:0.2f animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
    }
}

- (void)handleGraceTimer
{
    [UIView cancelPreviousPerformRequestsWithTarget:self];
    for (UIView *view in self.subviews) {
        if (view.tag == 1008611) {
            [UIView animateWithDuration:0.2f animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
    }
}

@end


@interface HUD ()
@property (copy, nonatomic) NSString *imageName;
@property (copy, nonatomic) NSString *text;
@property (weak, nonatomic) UIImageView *imageView;
@end

@implementation HUD

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        self.text = text;
        self.imageName = imageName;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
        [self p_letad_setup];
    }
    return self;
}

- (void)p_letad_setup
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[AlbumTool imageNamed:self.imageName]];
    [self addSubview:imageView];
    CGFloat imgW = imageView.image.size.width;
    CGFloat imgH = imageView.image.size.height;
    CGFloat imgCenterX = self.frame.size.width / 2;
    imageView.frame = CGRectMake(0, 20, imgW, imgH);
    imageView.center = CGPointMake(imgCenterX, imageView.center.y);
    self.imageView = imageView;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = self.text;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    [self addSubview:label];
    CGFloat labelX = 10;
    CGFloat labelY = CGRectGetMaxY(imageView.frame) + 10;
    CGFloat labelW = self.frame.size.width - 20;
    CGFloat labelH = [AlbumTool getTextHeight:self.text width:labelW fontSize:14];
    label.frame = CGRectMake(labelX, labelY, labelW, labelH);
}

- (void)showloading
{
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loading startAnimating];
    [self addSubview:loading];
    loading.frame = self.imageView.frame;
    self.imageView.hidden = YES;
}

@end

