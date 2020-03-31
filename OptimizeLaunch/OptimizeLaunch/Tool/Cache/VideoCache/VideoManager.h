//
//  VideoManager.h
//  VideoCacheDemo
//
//  Created by dangercheng on 2018/7/31.
//  Copyright © 2018年 DandJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoDownloader.h"

@class VideoCacheConfig, VideoDownloader;

@interface VideoManager : NSObject

@property (nonatomic, strong) VideoCacheConfig *cacheConfig;

@property (nonatomic, strong, readonly) NSArray *prloadingMediaUrls;

+ (instancetype)shareManager;

- (void)loadMediaWithUrl:(NSURL *)url
                 options:(VideoOptions)options
                progress:(VideoProgressBlock)progress
              completion:(VideoCompletionBlock)completion;

- (void)endLoadMediaWithUrl:(NSURL *)url;

- (NSData *)cacheDataFromOffset:(NSUInteger)offset
                         length:(NSUInteger)length
                        withUrl:(NSURL *)url;

- (NSInteger)totalCachedSize;

- (NSString *)totalCachedSizeStr;

- (void)cleanCache;

- (void)resetPreloadingWithMediaUrls:(NSArray<NSURL *> *)mediaUrls;

@end
