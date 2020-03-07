//
//  RunLoopSource.m
//  RunLoop
//
//  Created by Jeremy on 2020/3/5.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "RunLoopSource.h"
#import "RunLoopDelegate.h"

void RunLoopSourcesScheduleRoutine(void *info, CFRunLoopRef rl, CFStringRef mode) {
    NSLog(@"RunLoopSourcesScheduleRoutine 对象地址 %p",info);
    RunLoopSource *obj = (__bridge RunLoopSource*)info;
    RunLoopDelegate * del = [RunLoopDelegate sharedDelegate];
    RunLoopContext * theContext = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
    NSLog(@"RunLoopSourceScheduleRoutine 对象引用计数为：%@", [obj valueForKey:@"retainCount"]);
    [del performSelectorOnMainThread:@selector(registerSource:) withObject:theContext waitUntilDone:NO];
}

void RunLoopSourcesPerformRoutine(void *info) {
    NSLog(@"RunLoopSourcesPerformRoutine 对象地址 %p", info);
    RunLoopSource *obj = (__bridge RunLoopSource *)info;
    NSLog(@"RunLoopSourcePerformRoutine 对象引用计数 %@", [obj valueForKey:@"retainCount"]);
    [obj sourceFired];
    obj = nil;
}

void RunLoopSourcesCancelRoutine(void *info, CFRunLoopRef rl, CFStringRef mode) {
    NSLog(@"RunLoopSourceCancelRoutine 对象地址 %p", info);
    RunLoopSource * obj = (__bridge RunLoopSource *)info;
    RunLoopDelegate *delegate = [RunLoopDelegate sharedDelegate];
    RunLoopContext * context = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
    [delegate performSelectorOnMainThread:@selector(removeSources:) withObject:context waitUntilDone:YES];
}

@implementation RLCommand

- (id)initWithPriority:(NSInteger)prior withData:(id)data {
    if (self = [super init]) {
        _priority = prior;
        _data = data;
    }
    return self;
}

@end

@implementation RunLoopSource

- (instancetype)init {
    CFRunLoopSourceContext context = {
        0,
        (__bridge void *)self,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        &RunLoopSourcesScheduleRoutine,
        RunLoopSourcesCancelRoutine,
        RunLoopSourcesPerformRoutine,
    };
    runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
    commands = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)addToCurrentRunLoop {
    CFRunLoopRef rl = CFRunLoopGetCurrent();
    CFRunLoopAddSource(rl, runLoopSource, kCFRunLoopDefaultMode);
}

- (void)addCommand:(NSInteger)command withData:(id)data {
    RLCommand *rlm = [[RLCommand alloc] initWithPriority:command withData:data];
    [commands addObject:rlm];
}

- (void)sourceFired {
    NSLog(@"source  fired");
    for (RLCommand *command in commands) {
        NSLog(@"【线程：%@】 执行command：%@", [NSThread currentThread], command.data);
    }
}

- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop {
    CFRunLoopSourceSignal(runLoopSource);
    CFRunLoopWakeUp(runloop);
}

- (void)invalidate:(CFRunLoopRef)runloop {
    CFRunLoopRemoveSource(runloop, runLoopSource, kCFRunLoopDefaultMode);
    CFRunLoopStop(runloop);
    CFRelease(runloop);
}

- (void)dealloc
{
    
}

@end




@interface RunLoopContext ()

@end

@implementation RunLoopContext

- (id)initWithSource:(RunLoopSource *)src andLoop:(CFRunLoopRef)loop {
    if (self = [super init]) {
        _source = src;
        _runLoop = loop;
    }
    return self;
}

@end
