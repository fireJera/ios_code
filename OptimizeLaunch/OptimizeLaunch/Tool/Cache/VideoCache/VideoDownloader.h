//
//  VideoDownloader.h
//  VideoCacheDemo
//
//  Created by dangercheng on 2018/8/7.
//  Copyright © 2018年 DandJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoCache.h"

typedef NS_OPTIONS(NSUInteger, VideoOptions) {
    VideoOptionsHandleCookies = 1 << 0,
    VideoOptionsOptionAllowInvalidSSLCertificates = 1 << 1,
};

typedef void(^VideoProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
typedef void(^VideoCompletionBlock)(NSError *error);

@interface VideoDownloader : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign, readonly) BOOL canPreload;

+ (instancetype)shareDownloader;

- (void)downloadMediaWithUrl:(NSURL *)url
                     options:(VideoOptions)options
                    progress:(VideoProgressBlock)progress
                  completion:(VideoCompletionBlock)completion;

- (void)preloadMediaWithUrl:(NSURL *)url
                    options:(VideoOptions)options
                   progress:(VideoProgressBlock)progress
                 completion:(VideoCompletionBlock)completion;

- (void)cancelDownloadWithUrl:(NSURL *)url;

@end
