//
//  WALMEPlayerProgressView.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEPlayerProgressView.h"
#import "WALMEViewHeader.h"

@interface WALMEPlayerProgressView() {
    UIView * _viewTop;
    UIView * _viewBottom;
}
@end

@implementation WALMEPlayerProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.backgroundColor = [UIColor clearColor];
    [self p_walme_buildUI];
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _viewBottom.frame = self.bounds;
    _viewTop.frame = CGRectMake(0, 0, 0, _viewBottom.frame.size.height);
}

- (void)p_walme_buildUI {
    _viewBottom = [[UIView alloc]init];
    _viewBottom.backgroundColor = [UIColor walme_colorWithRGB:0x212121];
    _viewBottom.layer.cornerRadius = 3;
    _viewBottom.layer.masksToBounds = YES;
    _viewTop = [[UIView alloc] init];
    _viewTop.backgroundColor = [UIColor whiteColor];
    _viewTop.layer.cornerRadius = 3;
    _viewTop.layer.masksToBounds = YES;
    [self addSubview:_viewBottom];
    [_viewBottom addSubview:_viewTop];
}

- (void)setProgressValue:(float)progressValue {
    _progressValue = progressValue;
    _viewTop.frame = CGRectMake(_viewTop.left, _viewTop.top, _viewBottom.width * _progressValue, _viewTop.height);
}

- (void)setBottomColor:(UIColor *)bottomColor {
    _bottomColor = bottomColor;
    _viewBottom.backgroundColor = bottomColor;
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    _viewTop.backgroundColor = progressColor;
}

@end
