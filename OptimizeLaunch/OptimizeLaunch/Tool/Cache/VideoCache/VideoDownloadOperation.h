//
//  VideoDownloadOperation.h
//  VideoCacheDemo
//
//  Created by dangercheng on 2018/7/30.
//  Copyright © 2018年 DandJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoCache.h"
#import "VideoDownloader.h"

@interface VideoDownloadOperation : NSOperation <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic, assign) VideoOptions options;

@property (nonatomic, strong) NSURLCredential *credential;

@property (nonatomic, assign) BOOL isPreloading;

- (instancetype)initWithRequest:(NSURLRequest *)request
                        session:(NSURLSession *)session
                        options:(VideoOptions)options
                       progress:(VideoProgressBlock)progress
                     completion:(VideoCompletionBlock)completion;

- (void)cancelOperation;
@end
