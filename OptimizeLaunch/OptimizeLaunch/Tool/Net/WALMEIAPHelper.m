//
//  WALMEIAPHelper.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEIAPHelper.h"
#import "WALMEViewmodelHeader.h"
#import <StoreKit/StoreKit.h>
//#import "AppDelegate.h"
#import "WALMEViewHeader.h"
#import "WALMEFilePathHelper.h"

static NSString * const kIAPReceiptUrl = @"apple/verify-receipt";
NSString * WALMEIAPCancelString = @"取消购买";

@interface WALMEIAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, assign) BOOL hasUnfinishedOrder;

@end

@implementation WALMEIAPHelper

+ (instancetype)sharedManager {
    static WALMEIAPHelper * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
        [_instance p_init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedManager];
}

- (void)p_init {
    _hasUnfinishedOrder = NO;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

/*
 从Apple查询用户点击购买的产品的信息
 获取到信息以后，根据获取的商品详细信息
 */
- (void)getProductInfo:(NSString *)productIdentifier orderId:(NSString *)orderId
{
    //移除上次未完成的交易订单
    if (!orderId) {
        if (_IAPDelegate && [_IAPDelegate respondsToSelector:@selector(walme_IAPFailedWithError:)])
        {
            NSString * domain = @"com.runworld.runworld.IAPError";
            NSError * error = [NSError errorWithDomain:domain code:-11111 userInfo:@{NSLocalizedDescriptionKey: @"订单创建失败"}];
            [_IAPDelegate walme_IAPFailedWithError:error];
        }
    }
    
    [self checkAllFailOrder:^(BOOL hasPurchsedOrder, BOOL verifySuccess) {
        if (hasPurchsedOrder) {
            if (verifySuccess) {
                [self startPurchse:productIdentifier orderId:orderId];
            }
            else {
                if (_IAPDelegate && [_IAPDelegate respondsToSelector:@selector(walme_IAPFailedWithError:)])
                {
                    NSString * domain = @"com.runworld.runworld.IAPError";
                    NSError * error = [NSError errorWithDomain:domain code:-11111 userInfo:@{NSLocalizedDescriptionKey: @"当前有已支付订单，但是系统并没有发放到账，请联系客服！！！"}];
                    [_IAPDelegate walme_IAPFailedWithError:error];
                }
            }
        } else {
            [self startPurchse:productIdentifier orderId:orderId];
        }
    }];
}

- (void)startPurchse:(NSString *)productIdentifier orderId:(NSString *)orderId {
    _orderId = orderId;
    if (![SKPaymentQueue canMakePayments])
    {
        if (_IAPDelegate && [_IAPDelegate respondsToSelector:@selector(walme_IAPFailedWithError:)])
        {
            NSString * domain = @"com.runworld.runworld.IAPError";
            NSError * error = [NSError errorWithDomain:domain code:-11111 userInfo:@{NSLocalizedDescriptionKey: @"不允许程序内付费购买"}];
            [_IAPDelegate walme_IAPFailedWithError:error];
        }
        return;
    }
    
    if (productIdentifier.length > 0)
    {
        NSArray * product = [[NSArray alloc] initWithObjects:productIdentifier, nil];
        NSSet *set = [NSSet setWithArray:product];
        SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
        request.delegate = self;
        [request start];
    }
    else
    {
        if (_IAPDelegate && [_IAPDelegate respondsToSelector:@selector(walme_IAPFailedWithError:)])
        {
            NSString * domain = @"com.runworld.runworld.IAPError";
            NSError * error = [NSError errorWithDomain:domain code:-11111 userInfo:@{NSLocalizedDescriptionKey: @"商品ID为空"}];
            [_IAPDelegate walme_IAPFailedWithError:error];
        }
    }
}

- (void)checkAllFailOrder:(void (^)(BOOL, BOOL))resultBlock {
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count == 0 || !transactions) {
        if (resultBlock) {
            resultBlock(NO, YES);
        }
        return;
    }
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
                //交易完成
            case SKPaymentTransactionStatePurchased:
                //发送购买凭证到服务器验证是否有效
                [self completeTransaction:transaction resultBlock:resultBlock];
                _hasUnfinishedOrder = YES;
                break;
                //交易失败
            case SKPaymentTransactionStateFailed:
                [self p_walme_failedTransaction:transaction];
                break;
                //已经购买过该商品
            case SKPaymentTransactionStateRestored:
                //                NSLog(@"已经购买过该商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                //商品添加进列表
            case SKPaymentTransactionStatePurchasing:
                //                NSLog(@"StatePurchasing");
                //                break;
            case SKPaymentTransactionStateDeferred:
                //                NSLog(@"StateDeferred");
                break;
        }
    }
}

- (void)removePaymentObserver {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

/*
 查询成功后的回调
 经由getProductInfo函数发起的产品信息查询，成功后返回执行的回调。再更具回调内容发起购买请求
 */
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProduct = response.products;
    if (myProduct.count == 0)
    {
        if (_IAPDelegate && [_IAPDelegate respondsToSelector:@selector(walme_IAPFailedWithError:)])
        {
            NSString * domain = @"com.runworld.runworld.IAPError";
            NSError * error = [NSError errorWithDomain:domain code:-11111 userInfo:@{NSLocalizedDescriptionKey: @"无法获取商品信息"}];
            [_IAPDelegate walme_IAPFailedWithError:error];
        }
        return;
    }
    
    SKProduct * product = myProduct[0];
    
    SKMutablePayment * payment = [SKMutablePayment paymentWithProduct:product];
    payment.applicationUsername = self.orderId;
    //发起购买操作，下边的代码
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

/*
 查询失败后的回调
 */
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    if (_IAPDelegate && [_IAPDelegate respondsToSelector:@selector(walme_IAPFailedWithError:)])
    {
        [_IAPDelegate walme_IAPFailedWithError:error];
    }
//    NSLog(@"打印错误信息：%@",[error localizedDescription]);
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
                //交易完成
            case SKPaymentTransactionStatePurchased:
                //发送购买凭证到服务器验证是否有效
                [self completeTransaction:transaction resultBlock:nil];
                break;
                //交易失败
            case SKPaymentTransactionStateFailed:
                [self p_walme_failedTransaction:transaction];
                break;
                //已经购买过该商品
            case SKPaymentTransactionStateRestored:
                //                NSLog(@"已经购买过该商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                //商品添加进列表
            case SKPaymentTransactionStatePurchasing:
                WALMEINSTANCE_USER.lastIAPOrderId = _orderId;
                //                NSLog(@"StatePurchasing");
                //                break;
            case SKPaymentTransactionStateDeferred:
                //                NSLog(@"StateDeferred");
                break;
        }
    }
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error NS_AVAILABLE_IOS(3_0) {
    //    NSLog(@"---------restoreCompletedTransactionsFailedWithError--------");
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue NS_AVAILABLE_IOS(3_0) {
    //    NSLog(@"---------paymentQueueRestoreCompletedTransactionsFinished--------");
}

// Sent when the download state has changed.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray<SKDownload *> *)downloads NS_AVAILABLE_IOS(6_0) {
    //    NSLog(@"---------updatedDownloads--------");
}

- (void)p_walme_failedTransaction:(SKPaymentTransaction *)transaction {
    NSString * errStr;
    switch (transaction.error.code) {
        case SKErrorUnknown:
            errStr = @"未知的错误，您可能正在使用越狱手机";
            break;
        case SKErrorPaymentCancelled: {
            errStr = WALMEIAPCancelString;
        }
            break;
        case SKErrorClientInvalid:
            errStr = @"当前苹果账户无法购买商品(如有疑问，可以询问苹果客服)";
            break;
        case SKErrorPaymentInvalid:
            errStr = @"支付参数错误";
            break;
        case SKErrorPaymentNotAllowed:
            errStr = @"当前苹果设备无法购买商品(如有疑问，可以询问苹果客服)";
            break;
        case SKErrorStoreProductNotAvailable:
            errStr = @"当前商品不可用";
            break;
        default:
            errStr = [transaction.error localizedDescription];
            break;
    }
    if (_IAPDelegate && [_IAPDelegate respondsToSelector:@selector(walme_IAPFailedWithError:)])
    {
        NSString * domain = @"com.runworld.runworld.IAPError";
        NSError * error = [NSError errorWithDomain:domain code:-11111 userInfo:@{NSLocalizedDescriptionKey: errStr}];
        [_IAPDelegate walme_IAPFailedWithError:error];
        //        NSLog(@"打印错误信息：%@",[transaction.error localizedDescription]);
    }
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
}

- (BOOL)paymentQueue:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product {
    return YES;
}

- (NSString *)p_walme_receiptString {
    NSURL * receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData * receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    NSString * base64String = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return base64String;
}

//交易成功，与服务器比对传输货单号
- (void)completeTransaction:(SKPaymentTransaction *)transaction resultBlock:(void (^)(BOOL hasPurchasedOrder, BOOL verifySuccess))resultBlock {
    NSString * transactionReceiptString = [self p_walme_receiptString];
    NSString * trasId = transaction.transactionIdentifier;
    if (!trasId) {
        return;
    }
    NSString * orderId = transaction.payment.applicationUsername;
    if (!orderId) {
        orderId = WALMEINSTANCE_USER.lastIAPOrderId;
    }
//    [self p_walme_verifyReceipt:transactionReceiptString transId:trasId orderId:orderId transaction:transaction result:^(BOOL isSuccess, NSString *msg) {
//        if (isSuccess) {
//            if (resultBlock) {
//                resultBlock(_hasUnfinishedOrder, YES);
//            }
//            if (_hasUnfinishedOrder) {
//                _hasUnfinishedOrder = NO;
//            }
//        } else {
//            if (resultBlock) {
//                resultBlock(_hasUnfinishedOrder, NO);
//            }
//        }
//    }];
}

- (void)p_walme_verifyReceipt:(NSString *)transactionReceiptString
                      transId:(NSString *)transId
                      orderId:(NSString *)orderId
                  transaction:(SKPaymentTransaction *)transaction {
    if (orderId) {
        NSDictionary * dic = @{@"receipt": transactionReceiptString, @"transaction_id": transId, @"order_id": orderId};
        //        NSString * urlString = [NSString stringWithFormat:@"%@?token=%@", kIAPReceiptUrl, WALMEINSTANCE_USER.token];
        [WALMENetWorkManager walme_post:kIAPReceiptUrl withParameters:dic success:^(id result) {
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            if (!_hasUnfinishedOrder) {
                if (_IAPDelegate && [_IAPDelegate respondsToSelector:@selector(walme_IAPPaySuccessFunctionWithBase64:finished:)])
                {
                    [_IAPDelegate walme_IAPPaySuccessFunctionWithBase64:transactionReceiptString finished:!_hasUnfinishedOrder];
                }
            }
//            if (resultBolck) {
//                resultBolck(YES, nil);
//            }
        } failed:^(BOOL netReachable, NSString *msg, id result) {
//            [self p_walme_verrifyAgain:transactionReceiptString transId:transId orderId:orderId transaction:transaction result:resultBolck];
        }];
    }
}

- (void)p_walme_verrifyAgain:(NSString *)transactionReceiptString
                     transId:(NSString *)transId
                     orderId:(NSString *)orderId
                 transaction:(SKPaymentTransaction *)transaction {
    NSDictionary * dic = @{@"receipt": transactionReceiptString, @"transaction_id": transId, @"order_id": orderId};
    
    [WALMENetWorkManager walme_post:kIAPReceiptUrl withParameters:dic success:^(id result) {
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        if (!_hasUnfinishedOrder) {
            if (_IAPDelegate && [_IAPDelegate respondsToSelector:@selector(walme_IAPPaySuccessFunctionWithBase64:finished:)])
            {
                [_IAPDelegate walme_IAPPaySuccessFunctionWithBase64:transactionReceiptString finished:!_hasUnfinishedOrder];
            }
        }
//        if (resultBolck) {
//            resultBolck(YES, nil);
//        }
    } failed:^(BOOL netReachable, NSString *msg, id result) {
        NSString * str;
//        if (IsDictionaryWithItems(result)) {
//            NSString * msg = result[@"msg"];
//            str = msg.length > 0 ? msg : @"验证失败";
//        }
        if (_IAPDelegate && [_IAPDelegate respondsToSelector:@selector(walme_IAPFailedWithError:)])
        {
            NSString * domain = @"com.runworld.runworld.IAPError";
            NSError * error = [NSError errorWithDomain:domain code:-11111 userInfo:@{NSLocalizedDescriptionKey: str}];
            [_IAPDelegate walme_IAPFailedWithError:error];
        }
    }];
}

@end
