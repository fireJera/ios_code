//
//  WALMETabBarBtn.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMETabbarBtn.h"
//#import "AppDelegate.h"
#import "UIColor+WALME_Hex.h"

#define kBtnWidth self.bounds.size.width
#define kBtnHeight self.bounds.size.height

@interface WALMETabBarBtn ()

@property(nonatomic, strong) NSString *tabBarIndex;

@end

@implementation WALMETabBarBtn

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_walme_setTabBarIndexStr:)
                                                 name:@"NotifyTabBarIndex"
                                               object:nil];
    [self p_walme_setup];
    self.tabBarIndex = 0;
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self p_walme_setup];
}

- (void)p_walme_setup {
    self.backgroundColor = [UIColor walme_colorWithRGB:0xff6161];
    self.layer.masksToBounds = YES;
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:12.f];
    CGFloat cornerRadius = (kBtnHeight > kBtnWidth ? kBtnWidth / 2.0 : kBtnHeight / 2.0);
    self.layer.cornerRadius = cornerRadius;
    _maxDistance = cornerRadius * 5;
    
    CGRect samllCireleRect = CGRectMake(0, 0, cornerRadius * (2 - 0.5), cornerRadius * (2 - 0.5));
    self.samllCircleView.bounds = samllCireleRect;
    _samllCircleView.center = self.center;
    _samllCircleView.layer.cornerRadius = _samllCircleView.bounds.size.width / 2;
    
    [self addTarget:self action:@selector(p_walme_btnClick) forControlEvents:UIControlEventTouchUpInside];
}

//- (void)walme_shakeAnimation {
//    [self setHighlighted:YES];
//}

#pragma mark - 懒加载
- (NSMutableArray *)images {
    if (_images == nil) {
        _images = [NSMutableArray array];
        for (int i = 1; i < 9; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", i]];
            [_images addObject:image];
        }
    }
    
    return _images;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = [self.backgroundColor CGColor];
        [self.superview.layer insertSublayer:_shapeLayer below:self.layer];
    }
    return _shapeLayer;
}

- (UIView *)samllCircleView {
    if (!_samllCircleView) {
        _samllCircleView = [[UIView alloc] init];
        _samllCircleView.backgroundColor = self.backgroundColor;
        [self.superview insertSubview:_samllCircleView belowSubview:self];
    }
    return _samllCircleView;
}

#pragma mark - 俩个圆心之间的距离
- (CGFloat)p_walme_pointToPoitnDistanceWithPoint:(CGPoint)pointA potintB:(CGPoint)pointB {
    CGFloat offestX = pointA.x - pointB.x;
    CGFloat offestY = pointA.y - pointB.y;
    CGFloat dist = sqrtf(offestX * offestX + offestY * offestY);
    
    return dist;
}


- (void)p_walme_btnClick {
    int index = (int)(self.tag - 888);
//    UITabBarController * tab = (UITabBarController *)WALMEINSTANCE_KEYWINDOW.rootViewController;
    UITabBarController * tab = (UITabBarController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    [tab setSelectedIndex:index];
}

#pragma mark - 设置长按时候左右摇摆的动画

- (void)setUnreadCount:(NSString *)unreadCount {
    [self setTitle:unreadCount forState:UIControlStateNormal];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

- (void)p_walme_setTabBarIndexStr:(NSNotification *)notify {
    if (notify != nil) {
        self.tabBarIndex = notify.object;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

