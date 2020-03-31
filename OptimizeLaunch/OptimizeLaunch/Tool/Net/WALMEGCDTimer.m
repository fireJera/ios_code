//
//  WALMEGCDTimer.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEGCDTimer.h"

@implementation WALMEGCDTimer

+ (instancetype)scheduledDispatchTimerTimeInterval:(double)interval
                                           repeats:(BOOL)repeats
                                      callBlockNow:(BOOL)callBlockNow
                                            action:(dispatch_block_t)action {
    if(callBlockNow) {
        action();
    }
    WALMEGCDTimer *gcdTimer = [WALMEGCDTimer new];
    return  [gcdTimer createDispatchTimerTimeInterval:interval repeats:repeats action:action];
}

- (instancetype)createDispatchTimerTimeInterval:(double)interval
                                        repeats:(BOOL)repeats
                                         action:(dispatch_block_t)action {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    _timer = timer;
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        // NSLog(@"---------当前线程----%@----",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            action();
        });
        if(!repeats) {
            dispatch_source_cancel(timer);
        }
    });
    dispatch_resume(timer);
    
    return self;
}

- (void)cancelDispatchTimer {
    if(!self.timer) {
        return;
    }
    dispatch_source_cancel(self.timer);
    self.timer = nil;
}

@end
