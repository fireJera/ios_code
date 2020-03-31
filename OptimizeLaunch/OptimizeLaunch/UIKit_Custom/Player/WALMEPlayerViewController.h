//
//  WALMEPlayerViewController.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WALMEPlayerInfoDataSource;

@interface WALMEPlayerViewController : UIViewController

- (instancetype)initWithDataSource:(id<WALMEPlayerInfoDataSource>)dataSource;

@property (nonatomic, strong) id<WALMEPlayerInfoDataSource> dataSource;
@property (nonatomic, strong) UIView * blurBgView;
@property (nonatomic, strong) UIVisualEffectView * blurView;

@property (nonatomic, copy) void(^playendBlock)(void);

- (void)playerDidReachEnd;
- (void)playerSetBlurView;

- (void)p_walme_close;
- (void)playVideo;
- (void)pasueVideo;

@end

NS_ASSUME_NONNULL_END
