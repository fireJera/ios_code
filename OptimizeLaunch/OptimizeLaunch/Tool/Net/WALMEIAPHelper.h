//
//  WALMEIAPHelper.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol IAPHelperDelegate <NSObject>

- (void)walme_IAPFailedWithError:(NSError *_Nullable)error;

- (void)walme_IAPPaySuccessFunctionWithBase64:(NSString *)base64Str finished:(BOOL)finished;

@end

extern NSString * WALMEIAPCancelString;

@interface WALMEIAPHelper : NSObject

@property(nonatomic ,weak) id<IAPHelperDelegate> IAPDelegate;

@property (nonatomic, copy) NSString * orderId;

+ (instancetype)sharedManager;

- (void)getProductInfo:(NSString *)productIdentifier orderId:(NSString *)orderId;

- (void)checkAllFailOrder:(void(^ _Nullable)(BOOL hasPurchsedOrder, BOOL verifySuccess))resultBlock;

- (void)removePaymentObserver;

@end

NS_ASSUME_NONNULL_END
