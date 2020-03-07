//
//  CardScrollView.h
//  TanTanCard
//
//  Created by Jeremy on 2020/2/20.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

NS_ASSUME_NONNULL_BEGIN

@class CardView;

@protocol CardScrollViewDelegate, CardScrollViewDataSource;

typedef UIView *_Nullable(^ContentBlock)(int index, CGRect frame, id model);

@interface CardScrollView : UIView

@property (nonatomic, weak) id<CardScrollViewDelegate> delegate;
@property (nonatomic, weak) id<CardScrollViewDataSource> dataSource;
@property (nonatomic, copy, readonly) NSArray<CardView *> * loadedCards;
@property (nonatomic, copy, readonly) CardView * currentCard;
@property (nonatomic, assign, readonly) NSInteger currentIndex;

/// max Value is 3, default is 2.
@property (nonatomic, assign) int bufferSize;

- (instancetype)initWithFrame:(CGRect)frame bufferSize:(int)bufferSize;
- (void)showTinderCardsIfDummyShow:(BOOL)isDummuShow;

- (void)reloadData;

@end

@protocol CardScrollViewDelegate <NSObject>

- (void)dummyAnimationDone;

- (void)currentCardStatus:(CardView *)cardView distance:(CGFloat)distance;

- (void)fallbackCard:(id)model;
- (void)didSelectCard:(id)model;
- (void)cardScrollLeft:(id)model;
- (void)cardScrollRight:(id)model;
- (void)undoCardDone:(id)model;
- (void)endOfCardReached;

@end

@protocol CardScrollViewDataSource <NSObject>

- (NSInteger)cardCountForCardScrollView:(CardScrollView *)cardScrollView;
- (void)setCardContent:(CardScrollView *)cardScrollView cardView:(CardView *)cardView index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
