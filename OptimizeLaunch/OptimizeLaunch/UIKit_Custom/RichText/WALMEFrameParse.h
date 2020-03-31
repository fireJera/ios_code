//
//  WALMEFrameParse.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WALMECoreTextData;

@class WALMEFrameParseConfig;

NS_ASSUME_NONNULL_BEGIN
@interface WALMEFrameParse : NSObject

+ (WALMECoreTextData *)walme_parseContent:(NSString *)content
                                   config:(WALMEFrameParseConfig *)config;

+ (NSDictionary *)walme_attributesWithConfig:(WALMEFrameParseConfig *)config;

+ (WALMECoreTextData *)walme_parseTemplateFile:(NSString *)path
                                        config:(WALMEFrameParseConfig *)config;

//+ (WALMECoreTextData *)walme_parseAttributedContent:(NSAttributedString *)content
//                                               config:(WALMEFrameParseConfig *)config;

+ (WALMECoreTextData *)walme_parseDictionary:(NSDictionary *)dictionary
                                      config:(WALMEFrameParseConfig *)config;

+ (WALMECoreTextData *)walme_parseArray:(NSArray *)array
                                 config:(WALMEFrameParseConfig *)config;

@end

NS_ASSUME_NONNULL_END
