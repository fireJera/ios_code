//
//  WALMEViewmodel.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALMEViewControllerInfoDataSource.h"
//
//typedef void(^WALMEViewmodelProgessBlock)(float progress);
//typedef void(^WALMEViewmodelSuccessBlock)(NSString * _Nullable msg, id _Nullable result);
//typedef void(^WALMEViewmodelFailBlock)(BOOL isSuccess, BOOL netReachable, NSString * _Nullable msg);

NS_ASSUME_NONNULL_BEGIN

@interface WALMEViewmodel : NSObject <WALMEViewControllerInfoDataSource> {
    int _currentPage;
    NSString * _lastId;
    BOOL _hasMore;
    WALMEViewControllerRefreshBlock _refreshBlock;
}

- (NSString *)uid;

- (WALMEUserSex)sex;

- (int)currentPage;
- (BOOL)hasMore;
- (NSString *)lastId;
- (BOOL)netReachable;
- (void)walme_fetchData;
- (void)walme_fetchFirstPageData;
- (void)walme_fetchNextPageData;
- (void)walme_startMonitoringNet:(void (^_Nullable )(BOOL isSuccess))resultBlock;
- (void)walme_dealRequest:(NSDictionary *)dictionary;
- (void)walme_dealRequest:(nonnull NSDictionary *)dictionary completion:(WALMEViewmodelDataBlock _Nullable)completion;
- (void)setRefreshBlock:(WALMEViewControllerRefreshBlock)refreshBlock;

@end

NS_ASSUME_NONNULL_END
