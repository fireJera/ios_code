//
//  CardView.h
//  TanTanCard
//
//  Created by Jeremy on 2020/2/20.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CardViewDelegate;

@interface CardView : UIView

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIButton * bgBtn;
@property (nonatomic, strong) UIImageView * statusImageView;
@property (nonatomic, strong) UIImageView * overlayImageView;
@property (nonatomic, weak) id<CardViewDelegate> delegate;
@property (nonatomic, assign) int index;

- (void)shakeAnimationCard:(void(^)(BOOL))completion;

- (void)leftClick;
- (void)rightClick;
- (void)rollBackCard;
- (void)makeUndoAction;

@end

@protocol CardViewDelegate <NSObject>

- (void)didClickCard:(CardView *)cardView;
- (void)didSelectCard:(CardView *)cardView;
- (void)cardScollToLeft:(CardView *)cardView;
- (void)cardScollToRight:(CardView *)cardView;
- (void)currentCardStatus:(CardView *)cardView distance:(CGFloat)distance;
- (void)cardFallback:(CardView *)cardView;

@end

NS_ASSUME_NONNULL_END
