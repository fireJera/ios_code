//
//  WALMENetCallback.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//TODO: - 后期可模仿SDWebImage进行优化 将任务放进队列中管理 执行完回调释放

@interface WALMENetCallback : NSObject

@property (nonatomic, strong, class) Class openCls;

@property (nonatomic, strong) NSDictionary  *funcData;
//@property (nonatomic, strong) UIViewController * topController;

- (WALMENetCallback *(^)(NSDictionary * _Nullable json))walme_deal;

//- (instancetype)walme_dealCallbackWithJson:(NSDictionary *)json;

//- (void)walme_openNetAlert;

@end

NS_ASSUME_NONNULL_END
