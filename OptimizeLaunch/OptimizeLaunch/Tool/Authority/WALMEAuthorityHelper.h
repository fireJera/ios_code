//
//  WALMEAuthorityHelper.h
//  CodeFrame
//
//  Created by Jeremy on 2019/4/17.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WALMEAuthorityHelper : NSObject

//+ (void)checkCameraAuthorityDenied:(WALMEVoidBlock)deniedBlock
//                     notDetermined:(WALMEVoidBlock)notDeterminedBlock
//                         authBlock:(WALMEVoidBlock)authBlock
//                        restricted:(WALMEVoidBlock)restrictedBlock;

+ (void)requestMicroAuthroity;

+ (void)hasPushAuthority:(void(^)(BOOL hasAuth))block;
+ (void)openPushAuthoritySetting;

//+ (void)checkMicroAuthroityDenied:(WALMEVoidBlock)deniedBlock
//                    notDetermined:(WALMEVoidBlock)notDeterminedBlock
//                        authBlock:(WALMEVoidBlock)authBlock
//                       restricted:(WALMEVoidBlock)restrictedBlock;

@end

NS_ASSUME_NONNULL_END
