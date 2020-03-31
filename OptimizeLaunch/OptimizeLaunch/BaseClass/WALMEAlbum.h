//
//  WALMEAlbum.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WALMEAlbum : NSObject

@property (nonatomic, copy) NSString * photoId;
@property (nonatomic, assign) int userid;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, copy) NSString * link;
@property (nonatomic, copy) NSString * linkThumb;
@property (nonatomic, assign) int type;                 // 1 普通照片 2 私密照片 3 形象信息(头像) 1-2只有删除 3只能更换
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * gif;
//@property (nonatomic, assign) int comment;
//@property (nonatomic, assign) int zan;

@end

NS_ASSUME_NONNULL_END
