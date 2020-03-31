//
//  WALMEBlankView.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WALMEBlankViewType) {
    WALMEBlankViewTypeMessage,                // 消息列表，你还没有收到搭讪，要主动哦
    WALMEBlankViewTypeBadNet,                 // 网络不好，网络出错了，再试试吧
    WALMEBlankViewTypeNoVisitor,              // 没有访客，
    WALMEBlankViewTypeVisitorLock,            // 没有未解锁，
    WALMEBlankViewTypeLoading,                // 个人中心加载中
    WALMEBlankViewTypeBlank,                  // 空列表
    WALMEBlankViewTypeChatLock,               // 聊天锁
};

typedef void(^WALMEBlankViewFuncBlock)(void);

NS_ASSUME_NONNULL_BEGIN

//@interface WALMEBlankVisitorHeaderView : UIView
//
//@property (nonatomic, strong) UIButton * leftBtn;
//@property (nonatomic, strong) UIButton * centerBtn;
//@property (nonatomic, strong) UIButton * rightBtn;
//
//@end

@interface WALMEBlankView : UIView

@property (nonatomic, strong) UIImageView * blankImageView;
@property (nonatomic, strong) UILabel * noteLabel;
@property (nonatomic, strong) UIButton * funcBtn;

//@property (nonatomic, strong) WALMEBlankVisitorHeaderView * visitorHeader;
@property (nonatomic, strong) UIVisualEffectView * blurView;

@property (nonatomic, assign) WALMEBlankViewType blankType;
//@property (nonatomic, copy) WALMEBlankViewFuncBlock funcBlock;

- (void)walme_addBlurView;
- (void)walme_removeBlurView;

@end


NS_ASSUME_NONNULL_END
