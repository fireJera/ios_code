//
//  VideoCacheConfig.m
//  VideoCacheDemo
//
//  Created by dangercheng on 2018/8/16.
//  Copyright © 2018年 DandJ. All rights reserved.
//

#import "VideoCacheConfig.h"

@implementation VideoCacheConfig

+ (instancetype)defaultConfig {
    VideoCacheConfig *config = [VideoCacheConfig new];
    config.maxTempCacheSize = 1024 * 1024 * 100;//100MB
    config.maxFinalCacheSize = 1024 * 1024 * 200;//200MB
    config.maxTempCacheTimeInterval = 1 * 24 * 60 * 60;//1days
    config.maxFinalCacheTimeInterval = 1 * 24 * 60 * 60;//2days
    return config;
}

@end
