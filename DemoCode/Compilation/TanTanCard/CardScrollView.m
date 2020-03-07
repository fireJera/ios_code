//
//  CardScrollView.m
//  TanTanCard
//
//  Created by Jeremy on 2020/2/20.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "CardScrollView.h"


static const int kInset = 10;

@interface CardScrollView () <CardViewDelegate> {
    struct {
        unsigned int cardCountForCardScrollView : 1;
        unsigned int setCardContent : 1;
//        unsigned int cardCountForCardScrollView : 1;
//        unsigned int cardCountForCardScrollView : 1;
//        unsigned int cardCountForCardScrollView : 1;
    } _delegateFlgas;
    CGFloat _seperatorDistance;
    int _index;
}

@property (nonatomic, strong) NSMutableArray<CardView *> * innerLoadedCards;

@end

@implementation CardScrollView

- (void)setBufferSize:(int)bufferSize {
    if (bufferSize > 3)
        bufferSize = 3;
    _bufferSize = bufferSize;
}

- (void)setDelegate:(id<CardScrollViewDelegate>)delegate {
//    if ([_delegate respondsToSelector:@selector(<#selector#>)]) {
//
//    }
}

- (void)setDataSource:(id<CardScrollViewDataSource>)dataSource {
    _delegateFlgas.cardCountForCardScrollView = [_dataSource respondsToSelector:@selector(cardCountForCardScrollView:)];
    _delegateFlgas.setCardContent = [_dataSource respondsToSelector:@selector(setCardContent:cardView:index:)];
}

- (void)showTinderCardsIfDummyShow:(BOOL)isDummuShow {
    if (!_delegateFlgas.cardCountForCardScrollView) return;
    NSInteger count = [_dataSource cardCountForCardScrollView:self];
    if (count <= 0) return;
    for (int i = 0; i < count; i++) {
        if (_innerLoadedCards.count < _bufferSize) {
            CardView * cardView = [self createTinderCard:i];
            if (_innerLoadedCards.count == 0) {
                [self addSubview:cardView];
            }
            else {
                [self insertSubview:cardView belowSubview:_innerLoadedCards.lastObject];
            }
            [_innerLoadedCards addObject:cardView];
        }
    }
    [self animateCardAfterSwiping];
    if (isDummuShow) {
        [self performSelector:@selector(loadAnimation) withObject:nil afterDelay:1.0];
    }
}

//- (void)appendTinderCardsWithModels:(NSArray *)models {
//    if (models) {
//        [_allModels addObjectsFromArray:models];
//    }
//}

- (CardView *)createTinderCard:(int)index {
    CardView * card = [[CardView alloc] initWithFrame:CGRectMake(kInset, kInset + (_innerLoadedCards.count * _seperatorDistance), self.bounds.size.width - (kInset * 2), self.bounds.size.height - (_bufferSize * _seperatorDistance) - (kInset * 2))];
    card.delegate = self;
    return card;
}

- (void)animateCardAfterSwiping {
    if (_innerLoadedCards.count == 0) {
        if ([_delegate respondsToSelector:@selector(endOfCardReached)]) {
            [_delegate endOfCardReached];
            return;
        }
    }
    [_innerLoadedCards enumerateObjectsUsingBlock:^(CardView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [UIView animateWithDuration:0.5 animations:^{
            obj.userInteractionEnabled = idx == 0;
            CGRect frame = obj.frame;
            frame.origin.y = kInset + idx * _seperatorDistance;
            obj.frame = frame;
        }];
    }];
}

- (void)loadAnimation {
    CardView * card = _innerLoadedCards.firstObject;
    if (!card) return;
    [card shakeAnimationCard:^(BOOL finish) {
        if ([_delegate respondsToSelector:@selector(dummyAnimationDone)]) {
            [_delegate dummyAnimationDone];
        }
    }];
}

- (void)removeCardAndAddNewCard {
    _index += 1;
    CardView * card = _innerLoadedCards.firstObject;
    card.index = _index;
    [NSTimer scheduledTimerWithTimeInterval:1.01 target:self selector:@selector(enableUndoButton:) userInfo:card repeats:NO];
    [_innerLoadedCards removeObjectAtIndex:0];
    
    if (_delegateFlgas.cardCountForCardScrollView) {
        NSInteger count = [_dataSource cardCountForCardScrollView:self];
        if (_index + _innerLoadedCards.count < count) {
            CardView * card = [self createTinderCard:(int)(_index + _innerLoadedCards.count)];
            [self insertSubview:card belowSubview:_innerLoadedCards.lastObject];
            [_innerLoadedCards addObject:card];
        }
        [self animateCardAfterSwiping];
    }
}

- (void)makeLeftSwipeAction {
    CardView * card = _innerLoadedCards.firstObject;
    [card leftClick];
}

- (void)makeRightSipeAction {
    CardView * card = _innerLoadedCards.firstObject;
    [card rightClick];
}

- (void)undoCurrentTinderCard {
    CardView * undoCard = _currentCard;
    if (undoCard) {
        _index -= 1;
        if (_innerLoadedCards.count == _bufferSize) {
            CardView * lastCard = _innerLoadedCards.lastObject;
            [lastCard rollBackCard];
            [_innerLoadedCards removeLastObject];
        }
    }
    [undoCard.layer removeAllAnimations];
    [self insertSubview:undoCard aboveSubview:_innerLoadedCards.firstObject];
    [_innerLoadedCards insertObject:undoCard atIndex:0];
    [undoCard makeUndoAction];
    [self animateCardAfterSwiping];
    if ([_delegate respondsToSelector:@selector(undoCardDone:)]) {
        //        [_delegate undoCardDone:undoCard.model];
    }
    _currentCard = nil;
}

- (void)enableUndoButton:(NSTimer *)timer {
    CardView * card = timer.userInfo;
    if (card.index == _index) {
        _currentCard = card;
    }
}

#pragma mark - CardDelegate

- (void)didSelectCard:(CardView *)cardView {
    if ([_delegate respondsToSelector:@selector(didSelectCard:)]) {
        [_delegate didSelectCard:nil];
    }
}

- (void)cardScollToLeft:(CardView *)cardView {
    if ([_delegate respondsToSelector:@selector(cardScrollLeft:)]) {
        [_delegate cardScrollLeft:nil];
    }
}

- (void)cardScollToRight:(CardView *)cardView {
    if ([_delegate respondsToSelector:@selector(cardScrollRight:)]) {
        [_delegate cardScrollRight:nil];
    }
}

- (void)currentCardStatus:(CardView *)cardView distance:(CGFloat)distance {
    if ([_delegate respondsToSelector:@selector(currentCardStatus:distance:)]) {
        [_delegate currentCardStatus:cardView distance:distance];
    }
}

- (void)cardFallback:(CardView *)cardView {
    if ([_delegate respondsToSelector:@selector(fallbackCard:)]) {
        [_delegate fallbackCard:cardView];
    }
}

- (NSArray<CardView *> *)loadedCards {
    return _innerLoadedCards;
}

- (instancetype)initWithFrame:(CGRect)frame bufferSize:(int)bufferSize {
    self = [super initWithFrame:frame];
    if (self) {
        self.bufferSize = bufferSize;
        _innerLoadedCards = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (void)p_commonInit {
    _bufferSize = 2;
    _seperatorDistance = 8;
}

- (void)reloadData {
    [self showTinderCardsIfDummyShow:YES];
}


@end
