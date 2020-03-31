//
//  VideoCache.h
//  VideoCacheDemo
//
//  Created by dangercheng on 2018/7/30.
//  Copyright © 2018年 DandJ. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "VideoDiskCache.h"

@class VideoDiskCache;

//https://blog.csdn.net/yst19910702/article/details/78026521
//https://www.cnblogs.com/ios4app/p/6928806.html

@class VideoCacheConfig;

typedef void(^CompletionBlock)(void);

@interface VideoCache : NSObject

@property (nonatomic, strong) VideoDiskCache *diskCache;

+ (instancetype)shareCache;

- (NSString *)createCacheFileWithUrl:(NSURL *)url;

- (void)appendWithData:(NSData *)data url:(NSURL *)url;

- (NSData *)cacheDataFromOffset:(NSUInteger)offset
                         length:(NSUInteger)length
                        withUrl:(NSURL *)url;

- (void)cacheCompletedWithUrl:(NSURL *)url;

- (BOOL)isCacheCompletedWithUrl:(NSURL *)url;

- (NSInteger)cachedSizeWithUrl:(NSURL *)url;

- (NSInteger)finalCachedSizeWithUrl:(NSURL *)url;

- (NSInteger)totalCachedSize;

- (void)cleanCache;

- (void)resetCacheWithConfig:(VideoCacheConfig *)cacheConfig completion:(CompletionBlock)completion;

- (void)resetFinalCacheWithConfig:(VideoCacheConfig *)cacheConfig completion:(CompletionBlock)completion;

@end
