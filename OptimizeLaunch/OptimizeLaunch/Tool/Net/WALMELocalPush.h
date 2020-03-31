//
//  WALMELocalPush.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class RCMessage;

NS_ASSUME_NONNULL_BEGIN

@interface WALMELocalPush : NSObject

//+ (void)sendLocalPush:(RCMessage *)pushMessage;
+ (void)sendLocalPushTitle:(NSString *)title userInfo:(NSDictionary *)userInfo;

@end


NS_ASSUME_NONNULL_END
