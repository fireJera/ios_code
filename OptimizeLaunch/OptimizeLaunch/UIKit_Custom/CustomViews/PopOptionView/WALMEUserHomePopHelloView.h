//
//  WALMEUserHomePopHelloView.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/25.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WALMEPopHelloViewDelegate;

@interface WALMEUserHomePopHelloView : UIView

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) CALayer * lineLayer;
@property (nonatomic, strong) UIButton * refreshBtn;
@property (nonatomic, strong) NSMutableArray<UIButton *> * textBtns;
@property (nonatomic, copy) NSArray * optionStrings;

@property (nonatomic, weak) id<WALMEPopHelloViewDelegate> delegate;

@end

@protocol WALMEPopHelloViewDelegate <NSObject>

- (void)walme_popHelloViewDidSelected:(WALMEUserHomePopHelloView *)popView
                        selectedIndex:(NSInteger)index
                               string:(NSString *)string;
- (void)walme_popHelloViewClose:(WALMEUserHomePopHelloView *)popView;

@end

NS_ASSUME_NONNULL_END
