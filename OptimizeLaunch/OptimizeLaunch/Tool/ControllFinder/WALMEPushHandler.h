//
//  WALMEPushHandler.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

//处理收到的通知类

NS_ASSUME_NONNULL_BEGIN

@interface WALMEPushHandler : NSObject

+ (void)walme_dealDictionary:(NSDictionary *)funcdata;
+ (void)walme_dealPush;
@end

NS_ASSUME_NONNULL_END
