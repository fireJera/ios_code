//
//  WALMEApiCache.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEUserDefaults.h"

NS_ASSUME_NONNULL_BEGIN

@interface WALMEApiCache : WALMEUserDefaults

+ (instancetype)defaultCache;
+ (void)releaseCache;

/* 城市列表缓存 */
@property (nonatomic, strong) id areaInfoJson;

/* 首页缓存 */
//@property (nonatomic, strong) id homeInfoJson;

/* 个人中心缓存 */
@property (nonatomic, strong) id myInfoJson;

/* 个人主页缓存  */
//@property (nonatomic, strong) id UserHomeInfoJson;

@end
NS_ASSUME_NONNULL_END
