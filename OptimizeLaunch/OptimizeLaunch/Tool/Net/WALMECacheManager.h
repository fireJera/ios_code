//
//  WALMECacheManager.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WALMECacheManager : NSObject

@property (nonatomic, assign) unsigned long long cacheSize;

+ (instancetype)sharedManager;

//+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
//- (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (BOOL)saveInfoConfigCache:(id)data;
+ (id)getInfoConfigCache;

//总共的缓存大小
- (unsigned long long)calculateSize;
//个人中心的缓存大小
- (unsigned long long)calculateUserHomeSize;
//图片缓存大小
- (unsigned long long)calculatePictureSize;
//清除所有缓存
- (void)clearCache:(void(^)(void))handler;
//清除个人中心缓存
- (void)clearUserHomeCache;
//清除图片缓存
- (void)clearPictureCache:(void(^)(void))handler;
//
@end
NS_ASSUME_NONNULL_END
