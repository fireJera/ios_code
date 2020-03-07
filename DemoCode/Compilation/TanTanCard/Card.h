////
////  Card.h
////  TanTanCard
////
////  Created by Jeremy on 2019/7/18.
////  Copyright © 2019 Jeremy. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//
//NS_ASSUME_NONNULL_BEGIN
//
//@protocol CardDelegate;
//
//@interface Card : UIView
//
//@property (nonatomic, strong) UIView * contentView;
//@property (nonatomic, strong) UIView * overlayView;
//@property (nonatomic, strong) UIImageView * statusImageView;
//@property (nonatomic, strong) UIImageView * overlayImageView;
//@property (nonatomic, weak) id<CardDelegate> delegate;
//@property (nonatomic, assign) int index;
//
//- (void)addContentView:(UIView *)subView;
//
//- (void)shakeAnimationCard:(void(^)(BOOL))completion;
//
//- (void)leftClick;
//- (void)rightClick;
//- (void)rollBackCard;
//- (void)makeUndoAction;
//
//@end
//
//@protocol CardDelegate <NSObject>
//
//- (void)didSelectCard:(Card *)cardView;
//- (void)cardScollToLeft:(Card *)cardView;
//- (void)cardScollToRight:(Card *)cardView;
//- (void)currentCardStatus:(Card *)cardView distance:(CGFloat)distance;
//- (void)cardFallback:(Card *)cardView;
//
//@end
//
//NS_ASSUME_NONNULL_END
