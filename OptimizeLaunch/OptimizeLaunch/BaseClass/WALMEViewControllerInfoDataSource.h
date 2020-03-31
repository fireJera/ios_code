//
//  WALMEViewControllerInfoDataSource.h
//  CodeFrame
//
//  Created by Jeremy on 2019/4/20.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#ifndef WALMEViewControllerInfoDataSource_h
#define WALMEViewControllerInfoDataSource_h
#import "WALMEEnum.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^WALMEViewControllerRefreshBlock)(BOOL needRefresh);
typedef void(^WALMEViewmodelDataBlock)(BOOL isSuccess, BOOL netReachable, NSString * _Nullable msg);

extern NSString * const WALMECellIdentifier;

@protocol WALMEViewControllerInfoDataSource <NSObject>

#pragma mark - page
@optional
@property (nonatomic, copy, readonly) NSString * uid;
@property (nonatomic, copy, readonly) NSString * lastId;
@property (nonatomic, readonly) WALMEUserSex sex;
@property (nonatomic, readonly) int currentPage;
@property (nonatomic, readonly) BOOL hasMore;
//网络监测
@property (nonatomic, assign, readonly) BOOL netReachable;
//@property (nonatomic, assign, readonly) BOOL isSelf;

- (void)setRefreshBlock:(WALMEViewControllerRefreshBlock)refreshBlock;
- (void)walme_fetchData;
- (void)walme_fetchFirstPageData;
- (void)walme_fetchNextPageData;

- (void)walme_startMonitoringNet:(void(^_Nullable)(BOOL isSuccess))resultBlock;

- (void)walme_dealRequest:(NSDictionary *)dictionary;
- (void)walme_dealRequest:(NSDictionary *)dictionary completion:(_Nullable WALMEViewmodelDataBlock)completion;

#pragma mark - cell
@property (nonatomic, assign, readonly) NSInteger sectionCount;
- (CGFloat)heightForSection:(NSInteger)section;
- (NSInteger)cellCountInSection:(NSInteger)section;
- (NSString *)cellIdentifierInSection:(NSInteger)section;
- (NSString *)cellIdentifierInIndex:(NSInteger)index;
- (NSString *)cellIdentifierInIndexPath:(NSIndexPath *)indexPath;

- (void)clickCellInIndexPath:(nullable NSIndexPath *)indexPath;

@end
NS_ASSUME_NONNULL_END

#endif /* WALMEViewControllerInfoDataSource_h */
