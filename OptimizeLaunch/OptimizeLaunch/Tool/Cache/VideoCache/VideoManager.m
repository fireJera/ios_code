//
//  VideoManager.m
//  VideoCacheDemo
//
//  Created by dangercheng on 2018/7/31.
//  Copyright © 2018年 DandJ. All rights reserved.
//

#import "VideoManager.h"
#import <UIKit/UIKit.h>
#import "VideoCacheConfig.h"

#define Lock() dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER)
#define UnLock() dispatch_semaphore_signal(self.lock)

@interface VideoManager()
@property (nonatomic, strong)  NSMutableArray *waitingPreloadingUrls;
@property (nonatomic, strong) dispatch_semaphore_t lock;
@end

@implementation VideoManager
+ (instancetype)shareManager {
    static VideoManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VideoManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if(!self) return nil;
    _lock = dispatch_semaphore_create(1);
    _cacheConfig = [VideoCacheConfig defaultConfig];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetCache)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetCacheInbackgroud)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    return self;
}

- (void)loadMediaWithUrl:(NSURL *)url
                 options:(VideoOptions)options
                progress:(VideoProgressBlock)progress
              completion:(VideoCompletionBlock)completion {
    [[VideoDownloader shareDownloader] downloadMediaWithUrl:url options:options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(progress) progress(receivedSize, expectedSize);
        });
    } completion:^(NSError *error) {
        if(!error) {
            [self startPreloading];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion) completion(error);
        });
    }];
}

- (void)endLoadMediaWithUrl:(NSURL *)url {
    [[VideoDownloader shareDownloader] cancelDownloadWithUrl:url];
}

- (NSData *)cacheDataFromOffset:(NSUInteger)offset
                         length:(NSUInteger)length
                        withUrl:(NSURL *)url {
    return [[VideoCache shareCache] cacheDataFromOffset:offset length:length withUrl:url];
}

- (void)resetCache {
    [[VideoCache shareCache] resetCacheWithConfig:_cacheConfig completion:nil];
}

- (void)resetCacheInbackgroud {
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
    __block UIBackgroundTaskIdentifier backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:backgroundTask];
        backgroundTask = UIBackgroundTaskInvalid;
    }];

    [[VideoCache shareCache] resetFinalCacheWithConfig:_cacheConfig completion:^{
        [application endBackgroundTask:backgroundTask];
        backgroundTask = UIBackgroundTaskInvalid;
    }];
}

- (NSInteger)totalCachedSize {
    return [[VideoCache shareCache] totalCachedSize];
}

- (NSString *)totalCachedSizeStr {
    NSInteger size = [self totalCachedSize];
    if (size <= 0) {
        return @"0.00M";
    }
    if (size < 1023 && size > 0)
        return([NSString stringWithFormat:@"%libytes",(long)size]);
    CGFloat floatSize = size / 1024.0;
    if (floatSize < 1023) return ([NSString stringWithFormat:@"%.2fKB", floatSize]);
    floatSize = floatSize / 1024.0;
    if (floatSize < 1023) return ([NSString stringWithFormat:@"%.2fMB", floatSize]);
    floatSize = floatSize / 1024.0;
    
    return ([NSString stringWithFormat:@"%.2fGB", floatSize]);
}

- (void)cleanCache {
    [[VideoCache shareCache] cleanCache];
}

- (void)resetPreloadingWithMediaUrls:(NSArray<NSURL *> *)mediaUrls {
    for (NSURL *url in mediaUrls) {
        [[VideoDownloader shareDownloader] cancelDownloadWithUrl:url];
    }
    Lock();
    _prloadingMediaUrls = mediaUrls;
    _waitingPreloadingUrls = [NSMutableArray arrayWithArray:mediaUrls];
    UnLock();
    [self startPreloading];
}

- (void)startPreloading {
    Lock();
    BOOL canPreload = YES;
    if(!([_waitingPreloadingUrls count] > 0)) {
        NSLog(@"No preloading waitting");
        canPreload = NO;
    }
    else if(![VideoDownloader shareDownloader].canPreload) {
        NSLog(@"Can not start preloading");
        canPreload = NO;
    }
   
    if(canPreload) {
        NSLog(@"start preloading");
        NSURL *url = _waitingPreloadingUrls.firstObject;
        __weak typeof(self) _self = self;
        UnLock();
        [[VideoDownloader shareDownloader] preloadMediaWithUrl:url options:kNilOptions progress:nil completion:^(NSError *error) {
            __strong typeof(_self) self = _self;
            NSLog(@"End preloading");
            if(!error) {
                Lock();
                [self.waitingPreloadingUrls removeObject:url];
                UnLock();
                [self startPreloading];
            }
        }];
    }
    else {
        UnLock();
    }
}

@end
