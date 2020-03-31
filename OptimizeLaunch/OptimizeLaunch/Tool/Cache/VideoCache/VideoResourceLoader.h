//
//  VideoResourceLoader.h
//  VideoCacheDemo
//
//  Created by dangercheng on 2018/7/30.
//  Copyright © 2018年 DandJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "VideoManager.h"

@protocol VideoResourceLoaderDelegate <NSObject>
@end

@interface VideoResourceLoader : NSObject

- (instancetype)initWithDelegate:(id<VideoResourceLoaderDelegate>)delegate;

@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, assign, readonly) float duration;

@property (nonatomic, weak) id<VideoResourceLoaderDelegate> delegate;

- (AVPlayerItem *)playItemWithUrl:(NSURL *)url;

- (AVPlayerItem *)playItemWithUrl:(NSURL *)url options:(VideoOptions)options;

- (void)endLoading;

@end
