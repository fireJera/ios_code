//
//  WALMEViewmodel.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEViewmodel.h"
#import "WALMEViewmodelHeader.h"

NSString * const WALMECellIdentifier = @"WALMECellIdentifier";

@implementation WALMEViewmodel

- (void)setRefreshBlock:(nonnull WALMEViewControllerRefreshBlock)refreshBlock {
    _refreshBlock = refreshBlock;
}

- (NSString *)uid {
    return WALMEINSTANCE_USER.uid;
}

- (WALMEUserSex)sex {
    return WALMEINSTANCE_USER.sex;
}

- (int)currentPage {
    return _currentPage;
}

- (BOOL)hasMore {
    return _hasMore;
}

- (NSString *)lastId {
    return _lastId;
}

- (BOOL)netReachable {
    return [WALMENetWorkManager netReachable];
}

- (void)walme_fetchData {
    if (!self.netReachable) {
        _refreshBlock(NO);
        return;
    }
}

- (void)walme_fetchFirstPageData {
    _currentPage = 0;
    _lastId = nil;
    [self walme_fetchData];
}

- (void)walme_fetchNextPageData {
    _currentPage++;
    [self walme_fetchData];
}

- (NSInteger)cellCountInSection:(NSInteger)section {
    return 0;
}

- (NSString *)icellIdentifierInIndex:(NSInteger)index {
    return nil;
}

- (NSString *)cellIdentifierInSection:(NSInteger)section {
    return [self cellIdentifierInIndex:section];
}

- (NSString *)cellIdentifierInIndexPath:(NSIndexPath *)indexPath {
    return [self cellIdentifierInIndex:indexPath.row];
}

- (void)walme_startMonitoringNet:(void (^)(BOOL isSuccess))resultBlock {
    [WALMENetWorkManager walme_startMonitoringNet:resultBlock];
}

- (void)walme_dealRequest:(NSDictionary *)dictionary {
    [WALMENetCallback new].walme_deal(dictionary);
}

- (void)walme_dealRequest:(nonnull NSDictionary *)dictionary completion:(WALMEViewmodelDataBlock _Nullable)completion {
    
}

@end
