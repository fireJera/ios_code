////
////  SwipView.h
////  TanTanCard
////
////  Created by Jeremy on 2019/7/18.
////  Copyright © 2019 Jeremy. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//@class Card;
//NS_ASSUME_NONNULL_BEGIN
//
//@protocol SwipeViewDelegate, SwipeViewDataSource;
//
//typedef UIView *(^ContentBlock)(int index, CGRect frame, id model);
//
//@interface SwipView : UIView
//
//@property (nonatomic, weak) id<SwipeViewDelegate> delegate;
//@property (nonatomic, copy, readonly) NSArray * models;
////@property (nonatomic, assign, readonly) NSUInteger cardCount;
//@property (nonatomic, copy, readonly) NSArray<Card *> * loadedCards;
//@property (nonatomic, copy, readonly) Card * currentCard;
//
//@property (nonatomic, copy) ContentBlock contentBlock;
//@property (nonatomic, assign) int bufferSize;
//
//- (instancetype)initWithFrame:(CGRect)frame contentView:(ContentBlock)contentBlock bufferSize:(int)bufferSize;
//- (void)showTinderCards:(NSArray *)models isDummyShow:(BOOL)isDummuShow;
//
//@end
//
//@protocol SwipeViewDelegate <NSObject>
//
//- (void)dummyAnimationDone;
//
//- (void)currentCardStatus:(Card *)cardView distance:(CGFloat)distance;
//
//- (void)fallbackCard:(id)model;
//- (void)didSelectCard:(id)model;
//- (void)cardScrollLeft:(id)model;
//- (void)cardScrollRight:(id)model;
//- (void)undoCardDone:(id)model;
//- (void)endOfCardReached;
//
//@end
//
//@protocol SwipeViewDataSource <NSObject>
//
//- (NSInteger)cardCountForSwipeView:(SwipView *)swipeView;
//
//
//
//@end
//
//NS_ASSUME_NONNULL_END
