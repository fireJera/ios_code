//
//  DownLoadOperation.m
//  Concurrent
//
//  Created by Jeremy on 2020/3/13.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "DownLoadOperation.h"

NSString * const DownLoadOperationNotification = @"DownLoadOperationNotification";

@implementation FinishOperation

- (instancetype)initWitTime:(NSInteger)time name:(NSString *)name {
    self = [super init];
    if (self) {
        _time = time;
        _name = name;
    }
    return self;
}

@end

@interface DownLoadOperation ()
// if ready can download if not pause download, if cancel removed from queue
@property (nonatomic, assign, getter=isReady) BOOL ready;
@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, assign, getter=isFinished) BOOL finished;
@property (nonatomic, assign, getter=isPaused) BOOL paused;

@property (nonatomic, assign) NSInteger totalTime;
@property (nonatomic, assign) NSInteger downLoadInterval;
@property (nonatomic, assign, readwrite) float progress;
@property (nonatomic, assign, readwrite) NSInteger currentTime;
@property (nonatomic, assign, readwrite) BOOL realCancel;
@property (nonatomic, assign, readwrite) BOOL realPause;

- (instancetype)initWithTime:(NSInteger)time
                  realCancel:(BOOL)realCancel
                   realPause:(BOOL)realPause
                      paused:(BOOL)paused
                        name:(NSString *)name
                 currentTime:(NSInteger)currentTime
                    progress:(float)progress
            downLoadInterval:(float)downLoadInterval
                 progressBlk:(void(^)(float, NSInteger))progresBlock
                   finishBlk:(void(^)(void))finishBlk;

@end

@implementation DownLoadOperation

@synthesize ready = _ready;
@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithTime:(NSInteger)time realCancel:(BOOL)realCancel realPause:(BOOL)realPause {
    if (self = [super init]) {
        _totalTime = time;
        _realCancel = realCancel;
        _realPause = realPause;
        _ready = NO;
        _progress = 0.0;
        _currentTime = 0;
        _paused = NO;
        if (_totalTime > 10000) {
            _downLoadInterval = _totalTime / 10000;
        }
        else {
            _totalTime += 10000;
            _downLoadInterval = _totalTime / 100;
        }
        self.name = [NSString stringWithFormat:@"task_%ld", (long)time];
    }
    return self;
}

- (instancetype)initWithTime:(NSInteger)time
                  realCancel:(BOOL)realCancel
                   realPause:(BOOL)realPause
                      paused:(BOOL)paused
                        name:(NSString *)name
                 currentTime:(NSInteger)currentTime
                    progress:(float)progress
            downLoadInterval:(float)downLoadInterval
                 progressBlk:(void(^)(float, NSInteger))progresBlock
                   finishBlk:(void(^)(void))finishBlk {
    if (self = [super init]) {
        _totalTime = time;
        _realCancel = realCancel;
        _realPause = realPause;
        _ready = NO;
        _progress = progress;
        _currentTime = currentTime;
        _paused = paused;
        _downLoadInterval = downLoadInterval;
        _progresBlock = progresBlock;
        _finishBlk = finishBlk;
        self.name = name;
    }
    return self;
}


- (instancetype)initWithTime:(NSInteger)time {
    return [self initWithTime:time realCancel:YES realPause:YES];
}

- (void)start {
    @synchronized (self) {
        self.executing = YES;
    }
    for (NSInteger i = _currentTime; i < _totalTime; i++) {
        @synchronized (self) {
            if (self.cancelled) {
                self.finished = YES;
                [self reset];
                return;
            }
            if (self.isFinished) return;
            else if (_paused) {
                if (_realPause) {
                    self.finished = YES;
                    self.executing = NO;
                    [self reset];
                    return;
                }
            }
        }
        _currentTime = i;
        _progress = (float)((float)i / (float)_totalTime);
        if (i % _downLoadInterval == 0) {
            float tempProgress = _progress;
            NSInteger tempTime = _currentTime;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_progresBlock) {
                    self.progresBlock(tempProgress, tempTime);
                }
            });
        }
    }
    _progress = 1.0;
    NSInteger total = _totalTime;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_progresBlock) {
            self.progresBlock(1.0, total);
        }
    });
    @synchronized (self) {
        [self done];
        return;
    }
}

- (void)setDownloadReady {
    @synchronized (self) {
        _paused = NO;
        self.ready = YES;
    }
}

- (void)cancel {
    @synchronized (self) {
        [self cancelDownLoad];
    }
}

- (void)cancelDownLoad {
    if (self.finished) return;
    if (!self.isReady) self.ready = YES;
    [super cancel];
    
    if (self.isExecuting) self.executing = NO;
    if (!self.finished) self.finished = YES;
}

- (void)reset {
    _progresBlock = nil;
}

- (instancetype)pauseDownload {
    @synchronized (self) {
        if (self.cancelled) return nil;
        if (self.finished) return nil;
        _paused = YES;
        if (self.executing) {
            self.executing = NO;
            if (_realPause) {
                self.finished = YES;
                return [[DownLoadOperation alloc] initWithTime:_totalTime realCancel:_realCancel realPause:_realPause paused:_paused name:self.name currentTime:_currentTime progress:_progress downLoadInterval:_downLoadInterval progressBlk:_progresBlock finishBlk:_finishBlk];
            }
        }
        else {
            self.ready = NO;
            return nil;
        }
    }
    return nil;
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:DownLoadOperationNotification object:self];
    });
    [self reset];
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setReady:(BOOL)ready {
    [self willChangeValueForKey:@"isReady"];
    _ready = ready;
    [self didChangeValueForKey:@"isReady"];
}

@end
