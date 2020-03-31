//
//  WALMEChatBannerFlowView.h
//  UncleCon
//
//  Created by super on 2018/6/4.
//  Copyright © 2018 super. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WALMEBannerOrientation) {
    WALMEBannerOrientationHorizon,
    WALMEBannerOrientationVertical,
};

@class WALMEBannerView;

@protocol WALMEBannerDataSource <NSObject>

- (NSUInteger)numberOfPagesIntFlowView:(UIView *)flowView;
- (UIView *)flowView:(WALMEBannerView *)flowView cellForPageAt:(int)index;

@end

@protocol WALMEBannerDelegate <NSObject>

@optional
- (CGSize)sizeForPageInFlowView:(WALMEBannerView *)flowView;
- (void)didScrollToPage:(int)page view:(WALMEBannerView *)flowView;
- (void)didSelectCell:(UIView *)subView index:(int)index;

@end

extern const NSInteger BannerIVTag;

@interface WALMEBannerView : UIView

@property (nonatomic, weak) id<WALMEBannerDelegate> delegate;
@property (nonatomic, weak) id<WALMEBannerDataSource> dataSource;
@property (nonatomic, assign, readonly) WALMEBannerOrientation orientation;
@property (nonatomic, assign) CGFloat miniumPageAlpha;
@property (nonatomic, assign) CGFloat miniumPageScale;
@property (nonatomic, assign) BOOL openAutoScroll;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) float autoTime;
@property (nonatomic, assign) NSUInteger originPage;

@property (nonatomic, weak, readonly) UIView * currentCell;

- (UIView *)dequeueReuseableCell;
- (void)reloadData;
//- (void)refreshBannerWithAdView:(UIView *)adView;
- (void)refreshBannerWithAdViewList:(NSArray *)bannerAdViewList;

@end

@interface WALMEBannerSubView : UIView

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIView * coverView;

@end
