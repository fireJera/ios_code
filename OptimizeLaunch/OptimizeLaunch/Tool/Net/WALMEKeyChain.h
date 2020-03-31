//
//  WALMEKeyChain.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const WALMEUUIDKey;
extern NSString * const WALMEIDFAKey;

@interface WALMEKeyChain : NSObject

+ (BOOL)saveValue:(id)value ForKey:(NSString *)key;
+ (id)load:(NSString *)key;
+ (BOOL)remove:(NSString *)key;

+ (void)saveUUid;
+ (NSString *)UUId;

+ (NSString *)idfaStr;

@end

NS_ASSUME_NONNULL_END
