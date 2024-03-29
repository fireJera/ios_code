//
//  WALMENetWorkManager.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WALMERequest;
@class AFHTTPSessionManager;

extern NSString * const WALMENetSignKey;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - block
// 成功
typedef void(^WALMENetSuccessBlock)(id _Nullable result);
// 失败
typedef void(^WALMENetFailBlock)(BOOL netReachable, NSString * _Nullable msg, id _Nullable result);

typedef void(^HttpRequestFailBlock)(NSError * _Nullable error);


@interface WALMENetWorkManager : NSObject

+ (BOOL)netReachable;

+ (void)walme_startMonitoringNet:(void(^_Nullable)(BOOL isSuccess))resultBlock;

+ (AFHTTPSessionManager *)walme_get:(NSString *)string
                     withParameters:(nullable NSDictionary *)parameters
                            success:(_Nullable WALMENetSuccessBlock)succeess
                             failed:(_Nullable WALMENetFailBlock)failed;

+ (AFHTTPSessionManager *)walme_post:(NSString *)string
                      withParameters:(nullable NSDictionary *)parameters
                             success:(_Nullable WALMENetSuccessBlock)succeess
                              failed:(_Nullable WALMENetFailBlock)failed;

+ (AFHTTPSessionManager *)walme_postManulCallback:(NSString *)string
                                   withParameters:(nullable NSDictionary *)parameters
                                          success:(_Nullable WALMENetSuccessBlock)succeess
                                           failed:(_Nullable WALMENetFailBlock)failed;

+ (void)walme_sendRequest:(NSMutableDictionary *)postData
                  reqData:(nullable NSDictionary *)reqData
                   method:(NSString *)method
             successBlock:(void (^)(BOOL isSuccess, id result))successBlock
             failureBlock:(_Nullable HttpRequestFailBlock)failureBlock;

+ (NSString *)walme_defaultUserAgentString:(BOOL)isBlockRequet;

//一般用这个
+ (NSString *)walme_urlStringSuffix:(BOOL)isBlockRequest;

//处理点击请求
+ (void)walme_conductRequest:(WALMERequest *)request;

+ (NSString *)return32LetterAndNumber;

@end

NS_ASSUME_NONNULL_END
