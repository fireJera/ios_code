//
//  RunLoopSource.h
//  RunLoop
//
//  Created by Jeremy on 2020/3/5.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RLCommand : NSObject

@property (nonatomic, assign, readonly) NSInteger priority;
@property (nonatomic, strong, readonly) id data;

- (id)initWithPriority:(NSInteger)prior withData:(id)data;

@end

@interface RunLoopSource : NSObject {
    CFRunLoopSourceRef runLoopSource;
    NSMutableArray *commands;
}

- (instancetype)init;
- (void)addToCurrentRunLoop;
- (void)invalidate:(CFRunLoopRef)runloop;

- (void)sourceFired;

- (void)addCommand:(NSInteger)command withData:(id)data;
- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop;

@end

void RunLoopSourcesScheduleRoutine(void *info, CFRunLoopRef rl, CFStringRef mode);
void RunLoopSourcesPerformRoutine(void * info);
void RunLoopSourcesCancenRoutine(void *info, CFRunLoopRef rl, CFStringRef mode);

@interface RunLoopContext : NSObject {
    CFRunLoopRef runloop;
    RunLoopSource *source;
}

@property (readonly) CFRunLoopRef runLoop;
@property (readonly) RunLoopSource* source;

- (id)initWithSource:(RunLoopSource *)src andLoop:(CFRunLoopRef)loop;

@end

NS_ASSUME_NONNULL_END
