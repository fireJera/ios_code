////
////  Card.m
////  TanTanCard
////
////  Created by Jeremy on 2019/7/18.
////  Copyright © 2019 Jeremy. All rights reserved.
////
//
//#import "Card.h"
//
//static const int kStength = 4;
//static const CGFloat kRange = 0.90;
//
//@interface Card () <UIGestureRecognizerDelegate> {
//    CGFloat _xCenter;
//    CGFloat _yCenter;
//    CGPoint _originPoint;
//    BOOL _isLiked;
//}
//
//@end
//
//@implementation Card
//
//- (void)layoutSubviews {
//    _originPoint = self.center;
//    _contentView.frame = self.bounds;
//    const CGFloat width = 75;
//    _statusImageView.frame = CGRectMake((_contentView.frame.size.width - width) / 2, 25, width, width);
//    _overlayImageView.frame = _contentView.bounds;
//}
//
//#pragma mark - touch event
//
//- (void)beingDragged:(UIPanGestureRecognizer *)pan {
//    _xCenter = [pan translationInView:self].x;
//    _yCenter = [pan translationInView:self].y;
//    switch (pan.state) {
//        case UIGestureRecognizerStateBegan: {
//            _originPoint = self.center;
//            [self addSubview:_contentView];
//            if ([_delegate respondsToSelector:@selector(didSelectCard:)]) {
//                [_delegate didSelectCard:self];
//            }
//        }
//            break;
//        case UIGestureRecognizerStateChanged: {
//            float rotationStrength = MIN(_xCenter / [UIScreen mainScreen].bounds.size.width, 1);
//            float rotationAngle = M_PI / 8 * rotationStrength;
//            float scale = MAX(1 - fabs(rotationStrength) / kStength, kRange);
////            CGPoint center = CGPointMake(_originPoint.x + _xCenter, _originPoint.y + _yCenter);
//            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngle);
//            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
//            //CGAffineTransformMakeScale(scale, scale);
//            self.transform = scaleTransform;
//            [self updateOverlay:_xCenter];
//        }
//            break;
//        case UIGestureRecognizerStateEnded: {
//            [_contentView removeFromSuperview];
//            [self afterSwipeAction];
//        }
//            break;
//        case UIGestureRecognizerStatePossible:
//        case UIGestureRecognizerStateCancelled:
//        case UIGestureRecognizerStateFailed:
//            break;
//        default:
//            break;
//    }
//}
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self p_commonInit];
//    }
//    return self;
//}
//
//- (instancetype)initWithCoder:(NSCoder *)coder {
//    self = [super initWithCoder:coder];
//    if (self) {
//        [self p_commonInit];
//    }
//    return self;
//}
//
//- (void)p_commonInit {
//    _xCenter = 0;
//    _yCenter = 0;
//    _originPoint = CGPointZero;
//    _isLiked = NO;
//    _originPoint = self.center;
//    self.layer.cornerRadius = 10;
//    self.layer.shadowRadius = 3;
//    self.layer.shadowOpacity = 0.4;
//    self.layer.shadowOffset = CGSizeMake(0.5, 3);
//    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
//    self.clipsToBounds = YES;
//    self.backgroundColor = UIColor.whiteColor;
//    
//    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(beingDragged:)];
//    pan.delegate = self;
//    [self addGestureRecognizer:pan];
//    
//    _contentView = [[UIView alloc] init];
//    _contentView.backgroundColor = [UIColor clearColor];
////    [self addSubview:_contentView];
//    
//    _statusImageView = [[UIImageView alloc] init];
//    _statusImageView.alpha = 0;
//    [_contentView addSubview:_statusImageView];
//    
//    _overlayImageView = [[UIImageView alloc] init];
//    _overlayImageView.alpha = 0;
//    [_contentView addSubview:_overlayImageView];
//}
//
//- (void)addContentView:(UIView *)subView {
//    UIView * overLay = subView;
//    _overlayView = overLay;
//    [self insertSubview:_overlayView belowSubview:_contentView];
//}
//
//- (void)scrollRight {
//    if ([_delegate respondsToSelector:@selector(cardScollToRight:)]) {
//        [_delegate cardScollToRight:self];
//    }
//    CGPoint finishPoint = CGPointMake(self.frame.size.width * 2, 2 * _yCenter + _originPoint.y);
//    [UIView animateWithDuration:0.5 animations:^{
//        self.center = finishPoint;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
//    _isLiked = YES;
//}
//
//- (void)scrollLeft {
//    if ([_delegate respondsToSelector:@selector(cardScollToLeft:)]) {
//        [_delegate cardScollToLeft:self];
//    }
//    CGPoint finishPoint = CGPointMake(-self.frame.size.width * 2, 2 * _yCenter + _originPoint.y);
//    [UIView animateWithDuration:0.5 animations:^{
//        self.center = finishPoint;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
//    _isLiked = NO;
//}
//
//- (void)rightClick {
//    [self setInitialLayoutStatus:NO];
//    CGPoint finishPoint = CGPointMake(self.center.x + self.frame.size.width * 2, self.center.y);
//    [UIView animateWithDuration:1.0 animations:^{
//        [self animateCard:finishPoint angle:1 alpha:1.0];
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
//    _isLiked = YES;
//    if ([_delegate respondsToSelector:@selector(cardScollToRight:)]) {
//        [_delegate cardScollToRight:self];
//    }
//}
//
//- (void)leftClick {
//    [self setInitialLayoutStatus:YES];
//    CGPoint finishPoint = CGPointMake(self.center.x + self.frame.size.width * 2, self.center.y);
//    [UIView animateWithDuration:1.0 animations:^{
//        [self animateCard:finishPoint angle:1 alpha:1.0];
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
//    _isLiked = YES;
//    if ([_delegate respondsToSelector:@selector(cardScollToRight:)]) {
//        [_delegate cardScollToRight:self];
//    }
//}
//
//- (void)makeUndoAction {
//    _statusImageView.image = [self makeImage:_isLiked ? @"ic_like" : @"overlay_skip"];
//    _overlayImageView.image = [self makeImage:_isLiked ? @"overlay_like" : @"overlay_skip"];
//    _statusImageView.alpha = 1.0;
//    _overlayImageView.alpha = 1.0;
//    [UIView animateWithDuration:0.4 animations:^{
//        self.center = _originPoint;
//        self.transform = CGAffineTransformMakeRotation(0);
//        self.statusImageView.alpha = 0;
//        self.overlayImageView.alpha = 0;
//    }];
//}
//
//- (void)rollBackCard {
//    [UIView animateWithDuration:0.5 animations:^{
//        self.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
//}
//
//- (void)shakeAnimationCard:(void(^)(BOOL))completion {
//    _statusImageView.image = [self makeImage:@"is_skip"];
//    _overlayImageView.image = [self makeImage:@"overlay_skip"];
//    [UIView animateWithDuration:0.5 animations:^{
//        CGPoint finishPoint = CGPointMake(self.center.x - (self.frame.size.width / 2), self.center.y);
//        [self animateCard:finishPoint angle:-0.2 alpha:1.0];
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.5 animations:^{
//            [self animateCard:_originPoint angle:0 alpha:0];
//        } completion:^(BOOL finished) {
//            _statusImageView.image = [self makeImage:@"ic_like"];
//            _overlayImageView.image = [self makeImage:@"overlay_like"];
//            [UIView animateWithDuration:0.5 animations:^{
//                CGPoint finishPoint = CGPointMake(self.center.x + (self.frame.size.width / 2), self.center.y);
//                [self animateCard:finishPoint angle:0.2 alpha:1];
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.5 animations:^{
//                    [self animateCard:_originPoint angle:0 alpha:0];
//                } completion:^(BOOL finished) {
//                    if (completion) {
//                        completion(YES);
//                    }
//                }];
//            }];
//        }];
//    }];
//}
//
//- (void)setInitialLayoutStatus:(BOOL)isLeft {
//    _statusImageView.alpha = 0.5;
//    _overlayImageView.alpha = 0.5;
//    
//    _statusImageView.image = [self makeImage:isLeft ? @"ic_skip" : @"ic_like"];
//    _statusImageView.image = [self makeImage:isLeft ? @"overlay_skip" : @"overlay_like"];
//}
//
//- (UIImage *)makeImage:(NSString *)name {
//    UIImage * image = [UIImage imageNamed:name];
//    return image;
//}
//
//- (void)animateCard:(CGPoint)toCenter angle:(CGFloat)angle alpha:(CGFloat)alpha {
//    self.center = toCenter;
//    self.transform = CGAffineTransformMakeRotation(angle);
//    _statusImageView.alpha = alpha;
//    _overlayImageView.alpha = alpha;
//}
//
//#pragma mark - UIGestureRecognizerDelegate
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}
//
//- (void)afterSwipeAction {
//    float theresoldMargin = ([UIScreen mainScreen].bounds.size.width / 2) * 0.75;
//    if (_xCenter > theresoldMargin) {
//        [self scrollRight];
//    }
//    else if (_xCenter < - theresoldMargin) {
//        [self scrollLeft];
//    }
//    else {
//        if ([_delegate respondsToSelector:@selector(cardFallback:)]) {
//            [_delegate cardFallback:self];
//        }
//        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:0 animations:^{
//            self.center = _originPoint;
//            self.transform = CGAffineTransformMakeRotation(0);
//            _statusImageView.alpha = 0;
//            _overlayImageView.alpha = 0;
//        } completion:nil];
//    }
//}
//
//- (void)updateOverlay:(CGFloat)distance {
//    _statusImageView.image = [self makeImage:distance > 0 ? @"ic_like" : @"ic_skip"];
//    _overlayImageView.image = [self makeImage:distance > 0 ? @"overlay_like" : @"overlay_skip"];
//    _statusImageView.alpha = MIN(fabs(distance) / 100, 0.8);
//    _overlayImageView.alpha = MIN(fabs(distance) / 100, 0.8);
//    if ([_delegate respondsToSelector:@selector(currentCardStatus:distance:)]) {
//        [_delegate currentCardStatus:self distance:distance];
//    }
//}
//
//@end
