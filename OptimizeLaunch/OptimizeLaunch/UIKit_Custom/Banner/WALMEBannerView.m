//
//  WALMEChatBannerFlowView.m
//  UncleCon
//
//  Created by super on 2018/6/4.
//  Copyright © 2018 super. All rights reserved.
//

#import "WALMEBannerView.h"
#import "WALMEGCDTimer.h"
#import "UIView+WALME_Frame.h"

const NSInteger BannerIVTag = 13231;

@interface WALMEBannerView () <UIScrollViewDelegate> {
    BOOL _needReload;
    CGSize _pageSize;
    NSUInteger _pageCount;
    NSUInteger _page;
}

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, strong) NSMutableArray<UIView *> * cells;
@property (nonatomic, strong) NSMutableArray<UIView *> * reuseableCells;
@property (nonatomic, assign) NSRange visibleRange;
@property (nonatomic, strong) WALMEGCDTimer * timer;

@end

@implementation WALMEBannerView

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

- (instancetype)init {
    self = [super init];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

#pragma mark - private method
- (void)p_start {
    if (_originPage > 1 && _openAutoScroll) {
        __weak typeof(self) weakSelf = self;
        _timer = [WALMEGCDTimer scheduledDispatchTimerTimeInterval:_autoTime repeats:YES callBlockNow:NO action:^{
            [weakSelf p_autoNextPage];
        }];
    }
}

- (void)p_stopTimer {
    [_timer cancelDispatchTimer];
}

- (void)p_autoNextPage {
    _page += 1;
    
    switch (_orientation) {
        case WALMEBannerOrientationHorizon:
            [_scrollView setContentOffset:CGPointMake(_page * _pageSize.width, 0) animated:YES];
            break;
        case WALMEBannerOrientationVertical:
            [_scrollView setContentOffset:CGPointMake(0, _page * _pageSize.height) animated:YES];
            break;
        default:
            break;
    }
}

- (void)queueReuseableCell:(UIView *)cell {
    [_reuseableCells addObject:cell];
}

- (void)removeCellAt:(int)index {
    if (index < _cells.count) {
        UIView * cell = _cells[index];
        if (![cell isKindOfClass:[WALMEBannerSubView class]]) {
            [self queueReuseableCell:cell];
            if (cell.superview) {
                [cell removeFromSuperview];
            }
            UIView * view = [_dataSource flowView:self cellForPageAt:(index % _originPage)];
            [_cells replaceObjectAtIndex:index withObject:view];
        }
    }
}

- (void)p_refreshVisibleCellAppearence {
    if (_miniumPageAlpha == 1 && _miniumPageScale == 1) {
        return;
    }
    switch (_orientation) {
        case WALMEBannerOrientationHorizon: {
            CGFloat offset = _scrollView.contentOffset.x;
            for (NSUInteger i = _visibleRange.location; i < _visibleRange.location + _visibleRange.length; i++) {
                UIView * tempCell = _cells[i];
                if (![tempCell isKindOfClass:[WALMEBannerSubView class]]) {
                    return;
                }
                WALMEBannerSubView * cell = (WALMEBannerSubView *)tempCell;
                if (cell) {
                    CGFloat origin = cell.left;
                    CGFloat delta = fabs(origin - offset);
                    CGRect originCellFrame = CGRectMake(_pageSize.width * i, 0, _pageSize.width, _pageSize.height);
                    CGFloat inset;
                    cell.coverView.alpha = 0;
                    if (delta < _pageSize.width) {
                        inset = (_pageSize.width * (1 - _miniumPageScale)) * (delta / _pageSize.width) / 2;
                    } else {
                        inset = _pageSize.width * (1 - _miniumPageScale) / 2;
                    }
                    cell.layer.transform = CATransform3DMakeScale((_pageSize.width - inset * 2) / _pageSize.width, (_pageSize.height - inset * 2) / _pageSize.height, 1.0);
                    cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(inset, inset, inset, inset));
                }
            }
        }
            break;
        case WALMEBannerOrientationVertical: {
            CGFloat offset = _scrollView.contentOffset.y;
            for (NSUInteger i = _visibleRange.location; i < _visibleRange.location + _visibleRange.length; i++) {
                WALMEBannerSubView * cell = (WALMEBannerSubView *)_cells[i];
                if (cell) {
                    CGFloat origin = cell.top;
                    CGFloat delta = fabs(origin - offset);
                    CGRect originCellFrame = CGRectMake(0, _pageSize.height * i, _pageSize.width, _pageSize.height);
                    CGFloat inset;
                    if (delta < _pageSize.height) {
                        cell.coverView.alpha = (delta / _pageSize.height) * (1 - _miniumPageAlpha);
                        inset = (_pageSize.height * (1 - _miniumPageScale)) * (delta / _pageSize.height) / 2;
                        cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(inset, inset, inset, inset));
                        cell.imageView.frame = cell.bounds;
                    }
                }
            }
        }
            break;
    }
}

- (void)p_setPageAtIndex:(int)pageIndex {
    if (pageIndex < _cells.count) {
        UIView * cell = _cells[pageIndex];
        if ([cell isKindOfClass:[WALMEBannerSubView class]]) {
            if (cell) {
                [_cells replaceObjectAtIndex:pageIndex withObject:cell];
            } else {
                cell = [_dataSource flowView:self cellForPageAt:pageIndex % _originPage];
            }
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)];
            [cell addGestureRecognizer:tap];
            cell.tag = pageIndex % _originPage;
            switch (_orientation) {
                case WALMEBannerOrientationHorizon:
                    cell.frame = CGRectMake(_pageSize.width * pageIndex, 0, _pageSize.width, _pageSize.height);
                    break;
                case WALMEBannerOrientationVertical:
                    cell.frame = CGRectMake(0, _pageSize.height * pageIndex, _pageSize.width, _pageSize.height);
                    break;
            }
            if (!cell.superview) {
                [_scrollView addSubview:cell];
            }
        }
    }
}

- (void)p_setPageContentOffset:(CGPoint)offset {
    CGPoint startPoint = CGPointMake(offset.x - _scrollView.left, offset.y - _scrollView.top);
    CGPoint endPoint = CGPointMake(startPoint.x + self.width, startPoint.y + self.height);
    
    switch (_orientation) {
        case WALMEBannerOrientationHorizon: {
            int startIndex = 0;
            for (int i = 0; i < _cells.count; i++) {
                if (_pageSize.width * (i + 1) > startPoint.x) {
                    startIndex = i;
                    break;
                }
            }
            int endIndex = startIndex;
            for (int i = startIndex; i < _cells.count; i++) {
                if ((_pageSize.width * (i + 1) < endPoint.x && _pageSize.width * (i + 2) >= endPoint.x) || i + 2 == _cells.count) {
                    endIndex = i + 1;
                    break;
                }
            }
            
            startIndex = MAX(startIndex - 1, 0);
            endIndex = MIN(endIndex + 1, MAX((int)_cells.count - 1, 1));
            
            _visibleRange = NSMakeRange(startIndex, endIndex - startIndex + 1);
            for (int i = startIndex; i < endIndex; i++) {
                [self p_setPageAtIndex:i];
            }
            for (int i = 0; i < startIndex; i++) {
                [self removeCellAt:i];
            }
            for (int i = endIndex + 1; i < _cells.count; i++) {
                [self removeCellAt:i];
            }
        }
            break;
        case WALMEBannerOrientationVertical: {
            int startIndex = 0;
            for (int i = 0; i < _cells.count; i++) {
                if (_pageSize.height * (i + 1) > startPoint.y) {
                    startIndex = i;
                    break;
                }
            }
            int endIndex = startIndex;
            for (int i = startIndex; i < _cells.count; i++) {
                if ((_pageSize.height * (i + 1) < endPoint.y && _pageSize.height * (i + 2) >= endPoint.y) || i + 2 == _cells.count) {
                    endIndex = i + 1;//i+2 是以个数，所以其index需要减去1
                    break;
                }
            }
            
            startIndex = MAX(startIndex - 1, 0);
            endIndex = MIN(endIndex + 1,(int)_cells.count - 1);
            _visibleRange.location = startIndex;
            _visibleRange.length = endIndex - startIndex + 1;
            for (int i = startIndex; i < endIndex; i++) {
                [self p_setPageAtIndex:i];
            }
            for (int i = 0; i < startIndex; i++) {
                [self removeCellAt:i];
            }
            for (int i = endIndex + 1; i < _cells.count; i++) {
                [self removeCellAt:i];
            }
        }
            break;
    }
}

- (UIView *)currentCell {
    for (WALMEBannerSubView * subView in _cells) {
        if (subView.centerX > _scrollView.contentOffset.x && subView.centerX < _scrollView.contentOffset.x + _scrollView.width) {
            return subView;
        }
    }
    return nil;
}

- (void)reloadData {
    _needReload = YES;
    for (UIView * view in _scrollView.subviews) {
        if ([view isKindOfClass:[WALMEBannerSubView class]]) {
            [view removeFromSuperview];
        }
    }
    
    [self p_stopTimer];
    if (_needReload) {
        if ([_dataSource respondsToSelector:@selector(numberOfPagesIntFlowView:)]) {
            _originPage = [_dataSource numberOfPagesIntFlowView:self];
            _pageCount = _originPage == 1 ? 1 : _originPage * 3;
            if (_pageCount == 0) {
                return;
            }
            
            if (_pageControl) {
                _pageControl.numberOfPages = _originPage;
            }
        }
        if ([_delegate respondsToSelector:@selector(sizeForPageInFlowView:)]) {
            _pageSize = [_delegate sizeForPageInFlowView:self];
        }
        [_reuseableCells removeAllObjects];
        _visibleRange = NSMakeRange(0, 0);
        
        [_cells removeAllObjects];
        for (int i = 0; i < _pageCount; i++) {
            [_cells addObject:[_dataSource flowView:self cellForPageAt:i % _originPage]];
//            [_cells addObject:[[UIView alloc] init]];
        }
        switch (_orientation) {
            case WALMEBannerOrientationHorizon: {
                _scrollView.frame = CGRectMake(0, 0, _pageSize.width, _pageSize.height);
                _scrollView.contentSize = CGSizeMake(_pageSize.width * _pageCount, _pageSize.height);
                CGPoint theCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
                _scrollView.center = theCenter;
                if (_originPage > 1) {
                    [_scrollView setContentOffset:CGPointMake(_pageSize.width * _originPage, 0) animated:YES];
                    _page = _originPage;
                }
            }
                break;
            case WALMEBannerOrientationVertical: {
                _scrollView.frame = CGRectMake(0, 0, _pageSize.width, _pageSize.height);
                _scrollView.contentSize = CGSizeMake(_pageSize.width, _pageSize.height * _pageCount);
                CGPoint theCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
                _scrollView.center = theCenter;
                
                if (_originPage > 1) {
                    [_scrollView setContentOffset:CGPointMake(0, _pageSize.height * _originPage) animated:YES];
                    _page = _originPage;
                }
            }
                break;
        }
        [self p_start];
        _needReload = NO;
    }
    [self p_setPageContentOffset:_scrollView.contentOffset];
    [self p_refreshVisibleCellAppearence];
}

- (UIView *)dequeueReuseableCell {
    UIView * cell = _reuseableCells.lastObject;
    if ([cell isKindOfClass:[WALMEBannerSubView class]]) {
        [_reuseableCells removeLastObject];
        return cell;
    }
    return nil;
}

- (void)p_scrollToPage:(int)page {
    if (page < _pageCount) {
        [self p_stopTimer];
        _page = page + _originPage;
        
        switch (_orientation) {
            case WALMEBannerOrientationHorizon:
                [_scrollView setContentOffset:CGPointMake(_pageSize.width * (page + _originPage), 0) animated:YES];
                break;
            case WALMEBannerOrientationVertical:
                [_scrollView setContentOffset:CGPointMake(0, _pageSize.height * (page + _originPage)) animated:YES];
                break;
        }
        [self p_setPageContentOffset:_scrollView.contentOffset];
        [self p_refreshVisibleCellAppearence];
        [self p_start];
    }
}

- (void)refreshBannerWithAdView:(UIView *)adView {
    [self.scrollView setHidden:YES];
    [self addSubview:adView];
    adView.frame = self.bounds;
}

#pragma mark - touch event

- (void)tapCell:(UITapGestureRecognizer *)tap {
    if ([_delegate respondsToSelector:@selector(didSelectCell:index:)]) {
        [_delegate didSelectCell:tap.view index:(int)tap.view.tag];
    }
}

#pragma mark - override method
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    if ([self pointInside:point withEvent:event]) {
//        CGPoint newPoint = CGPointZero;
//        newPoint.x = point.x - _scrollView.left + _scrollView.contentOffset.x;
//        newPoint.y = point.y - _scrollView.top + _scrollView.contentOffset.y;
//        if ([_scrollView pointInside:newPoint withEvent:event]) {
//            return [_scrollView hitTest:newPoint withEvent:event];
//        }
//        return _scrollView;
//    }
//    return nil;
//}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_originPage == 0) {
        return;
    }
    int pageIndex;
    
    switch (_orientation) {
        case WALMEBannerOrientationHorizon:
            pageIndex = (int)(floor(scrollView.contentOffset.x / _pageSize.width)) % _originPage;
            break;
        case WALMEBannerOrientationVertical:
            pageIndex = (int)(floor(scrollView.contentOffset.y / _pageSize.height)) % _originPage;
            break;
    }
    
    if (_originPage > 1) {
        switch (_orientation) {
            case WALMEBannerOrientationHorizon: {
                if ((scrollView.contentOffset.x / _pageSize.width >= (2 * _originPage))) {
                    [scrollView setContentOffset:CGPointMake(_pageSize.width * _originPage, 0) animated:NO];
                    _page = _originPage;
                }
                
                if (scrollView.contentOffset.x / _pageSize.width <= (_originPage - 1)) {
                    [scrollView setContentOffset:CGPointMake((2 * _originPage - 1) * _pageSize.width, 0) animated:NO];
                    _page = 2 * _originPage;
                }
            }
                break;
            case WALMEBannerOrientationVertical: {
                if (scrollView.contentOffset.y / _pageSize.height >= (2 * _originPage)) {
                    [scrollView setContentOffset:CGPointMake(_pageSize.height * _originPage, 0) animated:NO];
                    _page = _originPage;
                }
                
                if (scrollView.contentOffset.y / _pageSize.height <= (_originPage - 1)) {
                    [scrollView setContentOffset:CGPointMake(0, (2 * _originPage - 1) * _pageSize.height) animated:NO];
                    _page = 2 * _originPage;
                }
            }
                break;
        }
    } else {
        pageIndex = 0;
    }
    [self p_setPageContentOffset:scrollView.contentOffset];
    [self p_refreshVisibleCellAppearence];
    if (_pageControl) {
        _pageControl.currentPage = pageIndex;
    }
    if (_currentPage != pageIndex) {
        if ([_delegate respondsToSelector:@selector(didScrollToPage:view:)]) {
            [_delegate didScrollToPage:pageIndex view:self];
        }
    }
    _currentPage = pageIndex;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer cancelDispatchTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (_originPage > 1 && _openAutoScroll) {
        
        _timer = [WALMEGCDTimer scheduledDispatchTimerTimeInterval:_autoTime repeats:YES callBlockNow:NO action:^{
            [self p_autoNextPage];
        }];
        
        switch (_orientation) {
            case WALMEBannerOrientationHorizon: {
                if (_page == (int)(floor(scrollView.contentOffset.x / _pageSize.width))) {
                    _page = (int)(floor(scrollView.contentOffset.x / _pageSize.width)) + 1;
                } else {
                    _page = (int)(floor(scrollView.contentOffset.x / _pageSize.width));
                }
                
            }
                break;
            case WALMEBannerOrientationVertical: {
                if (_page == (int)(floor(scrollView.contentOffset.y / _pageSize.height))) {
                    _page = (int)(floor(scrollView.contentOffset.y / _pageSize.height)) + 1;
                } else {
                    _page = (int)(floor(scrollView.contentOffset.y / _pageSize.height));
                }
            }
                break;
        }
    }
}

#pragma mark - init method

- (void)p_commonInit {
    self.clipsToBounds = YES;
    _needReload = YES;
    _pageSize = self.bounds.size;
    _pageCount = 0;
    _openAutoScroll = YES;
    _currentPage = 0;
    _miniumPageAlpha = 1;
    _miniumPageScale = 1;
    _autoTime = 5;
    _orientation = WALMEBannerOrientationHorizon;
    
    _reuseableCells = [NSMutableArray arrayWithCapacity:0];
    _cells = [NSMutableArray arrayWithCapacity:0];
    
    _visibleRange = NSMakeRange(0, 0);
    _scrollView = ({
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.clipsToBounds = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView;
    });
    
    UIView * superViewOfScrollView = [[UIView alloc] initWithFrame:self.bounds];
    superViewOfScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    superViewOfScrollView.backgroundColor = [UIColor clearColor];
    [superViewOfScrollView addSubview:_scrollView];
    [self addSubview:superViewOfScrollView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
    UIView * tempView = _scrollView.superview;
    tempView.frame = self.bounds;
    [self reloadData];
}

@end

@interface WALMEBannerSubView ()

@end

@implementation WALMEBannerSubView

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
    _imageView = ({
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
//        imageView.backgroundColor = [UIColor imageBgColor];
        [self addSubview:imageView];
        imageView;
    });
//    _pageControl = ({
//        UIPageControl * pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height - 20, 100, 20)];
//        pageControl.centerX = self.width / 2;
//        [self addSubview:pageControl];
//        pageControl;
//    });
//    _coverView = ({
//        UIView * view = [[UIView alloc] initWithFrame:self.bounds];
//        view.backgroundColor = [UIColor blackColor];
//        [self addSubview:view];
//        view;
//    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    _coverView.frame = self.bounds;
}

@end
