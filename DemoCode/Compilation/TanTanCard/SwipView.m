////
////  SwipView.m
////  TanTanCard
////
////  Created by Jeremy on 2019/7/18.
////  Copyright © 2019 Jeremy. All rights reserved.
////
//
//#import "SwipView.h"
//#import "Card.h"
//
//static const int kInset = 10;
//
//@interface SwipView () <CardDelegate> {
//    CGFloat _seperatorDistance;
//    int _index;
//}
//
//@property (nonatomic, strong) NSMutableArray * allModels;
////@property (nonatomic, assign, readwrite) NSUInteger cardCount;
//@property (nonatomic, strong) NSMutableArray<Card *> * innerLoadedCards;
//
//@end
//
//@implementation SwipView
//
//- (void)setBufferSize:(int)bufferSize {
//    if (bufferSize > 3)
//        bufferSize = 3;
//    _bufferSize = bufferSize;
//}
//
//- (void)showTinderCards:(NSArray *)models isDummyShow:(BOOL)isDummuShow {
//    if (!models || models.count == 0) {
//        return;
//    }
//    
//    [_allModels addObjectsFromArray:models];
//    
//    [models enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (_innerLoadedCards.count < _bufferSize) {
//            Card * cardView = [self createTinderCard:(int)idx model:obj];
//            if (_innerLoadedCards.count == 0) {
//                [self addSubview:cardView];
//            }
//            else {
//                [self insertSubview:cardView belowSubview:_innerLoadedCards.lastObject];
//            }
//            [_innerLoadedCards addObject:cardView];
//        }
//    }];
//    [self animateCardAfterSwiping];
//    if (isDummuShow) {
//        [self performSelector:@selector(loadAnimation) withObject:nil afterDelay:1.0];
//    }
//}
//
//- (void)appendTinderCardsWithModels:(NSArray *)models {
//    if (models) {
//        [_allModels addObjectsFromArray:models];
//    }
//}
//
//- (Card *)createTinderCard:(int)index model:(id)model {
//    Card * card = [[Card alloc] initWithFrame:CGRectMake(kInset, kInset + (_innerLoadedCards.count * _seperatorDistance), self.bounds.size.width - (kInset * 2), self.bounds.size.height - (_bufferSize * _seperatorDistance) - (kInset * 2))];
//    card.delegate = self;
////    card.
//    UIView * view;
//    if (_contentBlock) {
//        view = _contentBlock(index, card.bounds, model);
//    }
//    [card addContentView:view];
//    return card;
//}
//
//- (void)animateCardAfterSwiping {
//    if (_innerLoadedCards.count == 0) {
//        if ([_delegate respondsToSelector:@selector(endOfCardReached)]) {
//            [_delegate endOfCardReached];
//            return;
//        }
//    }
//    [_innerLoadedCards enumerateObjectsUsingBlock:^(Card * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [UIView animateWithDuration:0.5 animations:^{
//            obj.userInteractionEnabled = idx == 0;
//            CGRect frame = obj.frame;
//            frame.origin.y = kInset + idx * _seperatorDistance;
//            obj.frame = frame;
//        }];
//    }];
//}
//
//- (void)loadAnimation {
//    Card * card = _innerLoadedCards.firstObject;
//    if (!card) return;
//    [card shakeAnimationCard:^(BOOL finish) {
//        if ([_delegate respondsToSelector:@selector(dummyAnimationDone)]) {
//            [_delegate dummyAnimationDone];
//        }
//    }];
//}
//
//- (void)removeCardAndAddNewCard {
//    _index += 1;
//    Card * card = _innerLoadedCards.firstObject;
//    card.index = _index;
//    [NSTimer scheduledTimerWithTimeInterval:1.01 target:self selector:@selector(enableUndoButton:) userInfo:card repeats:NO];
//    [_innerLoadedCards removeObjectAtIndex:0];
//    
//    if (_index + _innerLoadedCards.count < _allModels.count) {
//        Card * card = [self createTinderCard:(int)(_index + _innerLoadedCards.count) model:_allModels[_index + _innerLoadedCards.count]];
//        [self insertSubview:card belowSubview:_innerLoadedCards.lastObject];
//        [_innerLoadedCards addObject:card];
//    }
//    [self animateCardAfterSwiping];
//}
//
//- (void)makeLeftSwipeAction {
//    Card * card = _innerLoadedCards.firstObject;
//    [card leftClick];
//}
//
//- (void)makeRightSipeAction {
//    Card * card = _innerLoadedCards.firstObject;
//    [card rightClick];
//}
//
//- (void)undoCurrentTinderCard {
//    Card * undoCard = _currentCard;
//    if (undoCard) {
//        _index -= 1;
//        if (_innerLoadedCards.count == _bufferSize) {
//            Card * lastCard = _innerLoadedCards.lastObject;
//            [lastCard rollBackCard];
//            [_innerLoadedCards removeLastObject];
//        }
//    }
//    [undoCard.layer removeAllAnimations];
//    [self insertSubview:undoCard aboveSubview:_innerLoadedCards.firstObject];
//    [_innerLoadedCards insertObject:undoCard atIndex:0];
//    [undoCard makeUndoAction];
//    [self animateCardAfterSwiping];
//    if ([_delegate respondsToSelector:@selector(undoCardDone:)]) {
//        //        [_delegate undoCardDone:undoCard.model];
//    }
//    _currentCard = nil;
//}
//
//- (void)enableUndoButton:(NSTimer *)timer {
//    Card * card = timer.userInfo;
//    if (card.index == _index) {
//        _currentCard = card;
//    }
//}
//
//#pragma mark - CardDelegate
//
//- (void)didSelectCard:(Card *)cardView {
//    if ([_delegate respondsToSelector:@selector(didSelectCard:)]) {
//        [_delegate didSelectCard:nil];
//    }
//}
//
//- (void)cardScollToLeft:(Card *)cardView {
//    if ([_delegate respondsToSelector:@selector(cardScrollLeft:)]) {
//        [_delegate cardScrollLeft:nil];
//    }
//}
//
//- (void)cardScollToRight:(Card *)cardView {
//    if ([_delegate respondsToSelector:@selector(cardScrollRight:)]) {
//        [_delegate cardScrollRight:nil];
//    }
//}
//
//- (void)currentCardStatus:(Card *)cardView distance:(CGFloat)distance {
//    if ([_delegate respondsToSelector:@selector(currentCardStatus:distance:)]) {
//        [_delegate currentCardStatus:cardView distance:distance];
//    }
//}
//
//- (void)cardFallback:(Card *)cardView {
//    if ([_delegate respondsToSelector:@selector(fallbackCard:)]) {
//        [_delegate fallbackCard:cardView];
//    }
//}
//
//- (NSArray *)models {
//    return _allModels;
//}
//
//- (NSArray<Card *> *)loadedCards {
//    return _innerLoadedCards;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame contentView:(nonnull ContentBlock)contentBlock bufferSize:(int)bufferSize {
//    self = [super initWithFrame:frame];
//    if (self) {
//        _contentBlock = contentBlock;
//        self.bufferSize = bufferSize;
//        _innerLoadedCards = [NSMutableArray array];
//        _allModels = [NSMutableArray array];
//    }
//    return self;
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
//    _bufferSize = 3;
//    _seperatorDistance = 8;
//}
//
//@end
