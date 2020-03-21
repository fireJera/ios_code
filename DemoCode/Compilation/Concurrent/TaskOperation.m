//
//  TaskOperation.m
//  Concurrent
//
//  Created by Jeremy on 2020/3/12.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "TaskOperation.h"

NSString * const TaskOperationStartNotification = @"TaskOperationStartNotification";
NSString * const TaskOperationReceiveResponseNotification = @"TaskOperationReceiveResponseNotification";
NSString * const TaskOperationStopNotification = @"TaskOperationStopNotification";
NSString * const TaskOperationFinishNotification = @"TaskOperationFinishNotification";

@interface TaskOperation ()

@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, assign, getter=isFinished) BOOL finished;
@property (nonatomic, assign, getter=isAsynchronous) BOOL asynchronous;
//
@property (nonatomic, assign, getter=isReady) BOOL ready;
@property (nonatomic, strong, nullable) NSMutableData * imageData;
@property (nonatomic, strong, nonnull) dispatch_semaphore_t callbacksLock;
@property (nonatomic, strong, nonnull) dispatch_queue_t coderQueue;

@end

@implementation TaskOperation

@synthesize executing = _executing;
@synthesize finished = _finished;
@synthesize asynchronous = _asynchronous;
@synthesize ready = _ready;

- (instancetype)initWithTaskName:(NSString *)taskName {
    if (self = [super init]) {
        _taskName = taskName;
        _executing = NO;
        _finished = NO;
        _callbacksLock = dispatch_semaphore_create(1);
        _asynchronous = YES;
        _ready = YES;
    }
    return self;
}

- (void)start {
    // never call super start, when real start the task, check the cancel value, if cancel, finish operation.
    @synchronized (self) {
        if (self.isCancelled) {
            NSLog(@"task : %@ canceled before start", _taskName);
            self.finished = YES;
            [self reset];
            return;
        }
        //    [super main];
        NSLog(@"current thread : %@", [NSThread currentThread]);
        NSLog(@"%@ : downloading ", _taskName);
        [NSThread sleepForTimeInterval:1];
        NSLog(@"task name : %@ finished", _taskName);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:TaskOperationStartNotification object:nil];
        });
        [self done];
    }
    ////        NSLog(@"%@ start", _taskName);
    ////        [self willChangeValueForKey:@"executing"];
    ////        [self didChangeValueForKey:@"executing"];
}

//- (void)main {
////    [super main];
//    NSLog(@"current thread : %@", [NSThread currentThread]);
//    NSLog(@"%@ : downloading ", _taskName);
////    for (int i = 0; i < 10; i++) {
////        NSLog(@"%@ : %d", _taskName, i);
////    }
//    [NSThread sleepForTimeInterval:1];
//    NSLog(@"task name : %@  finished", _taskName);
//}

- (void)cancel {
    @synchronized (self) {
        NSLog(@"task : %@ canceled", _taskName);
        [self cancelTask];
    }
}

- (void)cancelTask {
    if (self.isFinished) return;
    [super cancel];

    [[NSNotificationCenter defaultCenter] postNotificationName:TaskOperationStopNotification object:nil];
    if (self.isExecuting) _executing = NO;
    if (!self.isFinished) _finished = YES;
    [self reset];
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

//- (BOOL)isExecuting {
//    return [self valueForKey:@"executing"];
//}
//
//- (BOOL)isFinished {
//
//}

- (BOOL)isConcurrent {
    return YES;
}

- (void)reset {
    @synchronized (self) {

    }
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

- (void)setAsynchronous:(BOOL)asynchronous {
    [self willChangeValueForKey:@"isAsynchronous"];
    _asynchronous = asynchronous;
    [self didChangeValueForKey:@"isAsynchronous"];
}

- (void)setReady:(BOOL)ready {
    [self willChangeValueForKey:@"ready"];
    _ready = ready;
    [self didChangeValueForKey:@"ready"];
}

@end
