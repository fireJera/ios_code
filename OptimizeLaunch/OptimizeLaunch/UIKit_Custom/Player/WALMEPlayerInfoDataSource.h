//
//  WALMEPlayerInfoDataSource.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/5/23.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#ifndef WALMEPlayerInfoDataSource_h
#define WALMEPlayerInfoDataSource_h

#import <UIKit/UIKit.h>

typedef void(^WALMEPlayerViewBlock)(BOOL needRefresh);

@protocol WALMEPlayerInfoDataSource <NSObject>

@property (nonatomic, copy, readonly) NSString * nickname;
@property (nonatomic, copy, readonly) NSURL * avatarUrl;
//@property (nonatomic, copy, readonly) NSURL * coverUrl;
@property (nonatomic, copy, readonly) NSString * videoPath;
@property (nonatomic, copy, readonly) NSURL * videoUrl;
@property (nonatomic, copy, readonly) NSString * userid;
@property (nonatomic, copy, readonly) NSString * signature;
@property (nonatomic, copy, readonly) NSString * selfDesc;
@property (nonatomic, strong, readonly) UIImage * snapImage;

@property (nonatomic, assign, readonly) BOOL isSelf;

@property (nonatomic, assign, readonly) BOOL isShowAd;
@property (nonatomic, strong, readonly) NSDictionary * notPlayAlert;

@property (readonly) BOOL canPlay;
@property (readonly) NSString * blurNote;
@property (readonly) NSString * blurBtnTitle;
//@property (readonly) NSDictionary * blurOperation;
- (void)clickBlurOperation;
- (void)clickBlurOperationsIndex:(NSInteger)index;
//- (void)clickfollow;
- (void)changeFollow:(BOOL)followed;

- (void)setRefreshBlock:(WALMEPlayerViewBlock)refreshBlock;

@property (nonatomic, copy, readonly) NSArray * feedList;
@property (nonatomic, strong, readonly) UIView *feedView;

@end


#endif /* WALMEPlayerInfoDataSource_h */
