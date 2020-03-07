//
//  YYThreadSafeDictionary.m
//  YYKit
//
//  Created by super on 2018/12/27.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#define INIT(...) if (self = [super init]) { \
__VA_ARGS__; \
if (!_dic) return nil; \
_lock = dispatch_semaphore_create(1); \
} \
return self;

#import "YYThreadSafeDictionary.h"

@implementation YYThreadSafeDictionary {
    NSMutableDictionary * _dic;
    dispatch_semaphore_t _lock;
}

- (instancetype)init {
    INIT(_dic = [[NSMutableDictionary alloc] init])
}

@end
