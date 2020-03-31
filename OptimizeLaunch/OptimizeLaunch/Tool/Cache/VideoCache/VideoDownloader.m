//
//  VideoDownloader.m
//  VideoCacheDemo
//
//  Created by dangercheng on 2018/8/7.
//  Copyright © 2018年 DandJ. All rights reserved.
//

#import "VideoDownloader.h"
#import "VideoDownloadOperation.h"

#define Lock() dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER)
#define UnLock() dispatch_semaphore_signal(self.lock)

@interface VideoDownloader()<NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSMutableDictionary *operationCache;

@property (nonatomic, strong) dispatch_semaphore_t lock;
@end

@implementation VideoDownloader

+ (instancetype)shareDownloader {
    static VideoDownloader *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VideoDownloader alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if(!self) return nil;
    _lock = dispatch_semaphore_create(1);
    _queue = [NSOperationQueue new];
    _operationCache = [NSMutableDictionary dictionary];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    return self;
}

- (void)downloadMediaWithUrl:(NSURL *)url
                     options:(VideoOptions)options
                    progress:(VideoProgressBlock)progress
                  completion:(VideoCompletionBlock)completion {
    [self downloadMediaWithUrl:url options:options preload:NO progress:progress completion:completion];
}

- (void)preloadMediaWithUrl:(NSURL *)url
                    options:(VideoOptions)options
                   progress:(VideoProgressBlock)progress
                 completion:(VideoCompletionBlock)completion {
    [self downloadMediaWithUrl:url options:options preload:YES progress:progress completion:completion];
}

- (void)downloadMediaWithUrl:(NSURL *)url
                     options:(VideoOptions)options
                     preload:(BOOL)preload
                    progress:(VideoProgressBlock)progress
                  completion:(VideoCompletionBlock)completion {
    BOOL cached = [[VideoCache shareCache] isCacheCompletedWithUrl:url];
    if(cached) {
        NSInteger fileSize = [[VideoCache shareCache] finalCachedSizeWithUrl:url];
        if(progress) progress(fileSize, fileSize);
        if(completion) completion(nil);
        return;
    }
    
    [self cancelDownloadWithUrl:url];
    NSInteger cachedSize = [[VideoCache shareCache] cachedSizeWithUrl:url];
    NSMutableURLRequest *downloadRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *range = [NSString stringWithFormat:@"bytes=%ld-", (long)cachedSize];
    [downloadRequest setValue:range forHTTPHeaderField:@"Range"];
    downloadRequest.HTTPShouldHandleCookies = (options & VideoOptionsHandleCookies);
    downloadRequest.HTTPShouldUsePipelining = YES;
    
    __weak typeof(self) _self = self;
    VideoDownloadOperation *downloadOperation = [[VideoDownloadOperation alloc] initWithRequest:downloadRequest session:_session options:options progress:progress completion:^(NSError *error) {
        __strong typeof(_self) self = _self;
        if(!self) return;
        Lock();
        [self.operationCache removeObjectForKey:url];
        UnLock();
        if(completion) completion(error);
    }];
    if(_userName && _password) {
        downloadOperation.credential = [NSURLCredential credentialWithUser:_userName password:_password persistence:NSURLCredentialPersistenceForSession];
    }
    downloadOperation.isPreloading = preload;
    Lock();
    if(!preload) {
        NSMutableArray *needCancelUrls = [NSMutableArray array];
        for (NSURL *url in _operationCache.allKeys) {
            VideoDownloadOperation *operation = _operationCache[url];
            if(operation.isPreloading) {
                [needCancelUrls addObject:url];
            }
        }
        for (NSURL *url in needCancelUrls) {
            [_operationCache removeObjectForKey:url];
        }
    }
    [_operationCache setObject:downloadOperation forKey:url];
    [_queue addOperation:downloadOperation];
    UnLock();
}

- (void)cancelDownloadWithUrl:(NSURL *)url {
    if(!url) {
        return;
    }
    Lock();
    VideoDownloadOperation *operation = [_operationCache objectForKey:url];
    if(operation) {
        [operation cancel];
        [_operationCache removeObjectForKey:url];
    }
    UnLock();
}

- (BOOL)canPreload {
    BOOL retValue = YES;
    Lock();
    for (VideoDownloadOperation *operation in self.operationCache.allValues) {
        if(!operation.isPreloading) {
            retValue = NO;
            break;
        }
    }
    UnLock();
    return retValue;
}

- (void)dealloc {
    [_session invalidateAndCancel];
}

#pragma mark NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    Lock();
    VideoDownloadOperation *operation = [_operationCache objectForKey:task.originalRequest.URL];
    UnLock();
    [operation URLSession:session task:task didCompleteWithError:error];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    VideoDownloadOperation *operation = [_operationCache objectForKey:task.originalRequest.URL];
    [operation URLSession:session task:task didReceiveChallenge:challenge completionHandler:completionHandler];
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    Lock();
    VideoDownloadOperation *operation = [_operationCache objectForKey:dataTask.originalRequest.URL];
    UnLock();
    [operation URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    Lock();
    VideoDownloadOperation *operation = [_operationCache objectForKey:dataTask.originalRequest.URL];
    UnLock();
    [operation URLSession:session dataTask:dataTask didReceiveData:data];
}

@end
