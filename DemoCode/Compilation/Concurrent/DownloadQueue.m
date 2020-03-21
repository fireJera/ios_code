//
//  DownloadQueue.m
//  Concurrent
//
//  Created by Jeremy on 2020/3/14.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "DownloadQueue.h"
#import "DownLoadOperation.h"

@interface DownloadQueue ()

@property (nonatomic, strong) NSMutableArray<FinishOperation *> *finished;

@end

@implementation DownloadQueue

- (instancetype)init {
    if (self = [super init]) {
        _downloadQueue = [[NSOperationQueue alloc] init];
//        _downloadQueue.maxConcurrentOperationCount = 6;
        _downloadQueue.suspended = YES;
        _finished = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinish:) name:DownLoadOperationNotification object:nil];
        [_downloadQueue addObserver:self forKeyPath:@"maxConcurrentOperationCount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
    }
    return self;
}

- (BOOL)isAllStarted {
    __block BOOL allStart = YES;
    [_downloadQueue.operations enumerateObjectsUsingBlock:^(__kindof NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isReady) {
            allStart = NO;
            *stop = YES;
        }
    }];
    if (!allStart) return allStart;
    if (_downloadQueue.isSuspended) {
        allStart = NO;
    }
    return allStart;
}

- (BOOL)isAllPaused {
    __block BOOL allPaused = YES;
    [_downloadQueue.operations enumerateObjectsUsingBlock:^(__kindof NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.executing) {
            allPaused = NO;
            *stop = YES;
        }
        else if (obj.isReady) {
            allPaused = NO;
            *stop = YES;
        }
    }];
    return allPaused;
}

- (void)addOperation:(DownLoadOperation *)operation {
    if (!_downloadQueue) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.suspended = YES;
    }
    [_downloadQueue addOperation:operation];
}

- (void)startAll {
    [_downloadQueue.operations enumerateObjectsUsingBlock:^(__kindof DownLoadOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setDownloadReady];
    }];
//    NSLog(@"_downloadQueue left count : %d", (int)_downloadQueue.operationCount);
//    NSLog(@"finished count : %d", (int)_finished.count);
    _downloadQueue.suspended = NO;
}

- (void)pauseAll {
    NSLog(@"----------------");
    NSLog(@"_downloadQueue left count before enum : %d", (int)_downloadQueue.operationCount);
    NSMutableArray * array = [NSMutableArray array];
    _downloadQueue.suspended = YES;
    [_downloadQueue.operations enumerateObjectsUsingBlock:^(__kindof DownLoadOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DownLoadOperation * op = [obj pauseDownload];
        if (op) {
            [array addObject:op];
        }
//        else {
//            NSLog(@"insert nil");
//        }
    }];
//    NSLog(@"----------------");
    NSLog(@"_downloadQueue left count after enum : %d", (int)_downloadQueue.operationCount);
    NSLog(@"array count : %d", (int)array.count);
    NSLog(@"finished count : %d", (int)_finished.count);
//    NSLog(@"_downloadQueue left count before add : %d", (int)_downloadQueue.operationCount);
    for (DownLoadOperation * op in array) {
        [_downloadQueue addOperation:op];
    }
//    NSLog(@"_downloadQueue left count after add : %d", (int)_downloadQueue.operationCount);
//    NSLog(@"----------------");
}

- (void)resumeAll {
    [self startAll];
}

- (void)removeAll {
    [_downloadQueue.operations enumerateObjectsUsingBlock:^(__kindof DownLoadOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
    _downloadQueue.suspended = NO;
}

- (void)startOperation:(DownLoadOperation *)operation {
    if (![_downloadQueue.operations containsObject:operation]) {
        [self addOperation:operation];
    }
    if (!operation.isReady) {
        [operation setDownloadReady];
    }
    _downloadQueue.suspended = NO;
}

- (void)pauseOperation:(DownLoadOperation *)operation {
    DownLoadOperation * newOp = [operation pauseDownload];
    if (newOp) {
        [self addOperation:newOp];
    }
    if (self.isPaused) {
        _downloadQueue.suspended = YES;
    }
}

- (void)resumeOperation:(DownLoadOperation *)operation {
    [self startOperation:operation];
}

- (void)removeOperation:(id)operation {
    if ([operation isKindOfClass:[DownLoadOperation class]]) {
        _downloadQueue.suspended = NO;
        [operation cancel];
        _downloadQueue.suspended = YES;
    }
    else if ([operation isKindOfClass:[FinishOperation class]]) {
        [_finished removeObject:operation];
    }
}

- (void)p_testAddDownload {
    NSInteger p = arc4random() % 4 + 6;
    p *= 2;
    NSInteger time = pow(3, p);
    NSInteger rand = arc4random() % 1000 + 1000;
    time += rand;
    DownLoadOperation * operation = [[DownLoadOperation alloc] initWithTime:time];
    NSOperationQueuePriority priority;
    if (time < 10000) {
        priority = NSOperationQueuePriorityVeryHigh;
    }
    else if (time < 10000000) {
        priority = NSOperationQueuePriorityHigh;
    }
    else {
        priority = NSOperationQueuePriorityNormal;
    }
    operation.queuePriority = priority;
    [self addOperation:operation];
}

#pragma mark - notification

- (void)downloadFinish:(NSNotification *)notification {
    DownLoadOperation * operation = notification.object;
    if (operation) {
        FinishOperation *op = [[FinishOperation alloc] initWitTime:operation.currentTime name:operation.name];
        NSAssert(op, @"cannot insert nil to _finished");
        if (op) {
            [_finished addObject:op];
        }
    }
}

- (NSArray<FinishOperation *> *)finishedOperations {
    return _finished;
}

- (NSInteger)finishedCount {
    return _finished.count;
}

- (NSInteger)allDownloadCount {
    return _downloadQueue.operations.count + _finished.count;
}

- (id)operationForIndex:(NSInteger)index {
    NSInteger count = _downloadQueue.operations.count;
    if (index < count) {
        return [_downloadQueue.operations objectAtIndex:index];
    }
    index = index - count;
    if (index < _finished.count) {
        return [_finished objectAtIndex:index];
    }
    return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"maxConcurrentOperationCount"]) {
        NSLog(@"maxConcurrentOperationCount value = : %@", change[@"new"]);
    }
}

@end
