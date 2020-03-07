//
//  YYTimer.m
//  YYKit
//
//  Created by super on 2018/12/27.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "YYTimer.h"

#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);

@interface YYTimer ()

@end

@implementation YYTimer {
    BOOL _valid;
    NSTimeInterval _timeInterval;
    BOOL _repeats;
    __weak id _target;
    SEL _selector;
    dispatch_source_t _source;
    dispatch_semaphore_t _lock;
}

//+ (YYTimer *)scheduleTimerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats block:(void (^)(YYTimer * _Nonnull))block {
//    if (timeInterval <= 0) return nil;
//    YYTimer * timer = [YYTimer new];
//    timer->_time = timeInterval;
//    timer->_repeats = repeats;
//    timer->_timer =
//
//
////    dispatch_source_set_cancel_handler(timer->_timer, ^{
////
////    });
//    return timer;
//}

+ (YYTimer *)scheduleTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats {
    return [[self alloc] initWithFireTime:0 interval:timeInterval target:target selector:selector repeats:repeats];
}

//- (instancetype)initWithFireTime:(NSTimeInterval)start interval:(NSTimeInterval)interval block:(void (^)(YYTimer * _Nonnull))block {
//    if (self = [super init]) {
//        _valid = YES;
//        _timeInterval = interval;
//        _repeats = repeats;
//        
//        __weak typeof(self) weakSelf = self;
//        _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
//        dispatch_source_set_timer(_source, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
//        dispatch_source_set_event_handler(_source, ^{[weakSelf fire];});
//        dispatch_resume(_source);
//        _lock = dispatch_semaphore_create(1);
//    }
//    return self;
//}

- (instancetype)initWithFireTime:(NSTimeInterval)start interval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats {
    if (self = [super init]) {
        _valid = YES;
        _timeInterval = interval;
        _repeats = repeats;
        _target = target;
        _selector = selector;
        
        __weak typeof(self) weakSelf = self;
        _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(_source, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_source, ^{[weakSelf fire];});
        dispatch_resume(_source);
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)invalidate {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    if (_valid) {
        dispatch_source_cancel(_source);
        _source = NULL;
        _target = nil;
        _valid = NO;
    }
    dispatch_semaphore_signal(_lock);
}

- (void)fire {
    if (_valid) return;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    id target = _target;
    if (!target) {
        dispatch_semaphore_signal(_lock);
        [self invalidate];
    } else {
        dispatch_semaphore_signal(_lock);
        [target performSelector:_selector];
        if (!_repeats) {
            [self invalidate];
        }
    }
#pragma clang diagnostic pop
}

- (BOOL)repeats {
    LOCK(BOOL repeat = _repeats; return repeat;)
}

- (NSTimeInterval)timeInterval {
    LOCK(NSTimeInterval time = _timeInterval; return time;);
}

- (BOOL)isValid {
    LOCK(BOOL valid = _valid; return valid;)
}

- (void)dealloc {
    [self invalidate];
}

@end
