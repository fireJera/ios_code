//
//  WALMEApiCache.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEApiCache.h"

@implementation WALMEApiCache

@dynamic areaInfoJson;
//@dynamic homeInfoJson;
@dynamic myInfoJson;
//@dynamic UserHomeInfoJson;

#pragma mark - singleton
static WALMEApiCache *cache = nil;
+ (instancetype )defaultCache {
    if (cache == nil) {
        cache = [[WALMEApiCache alloc] init];
    }
    return cache;
}

+ (void)releaseCache {
    cache = nil;
}

@end
