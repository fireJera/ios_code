//
//  ViewController.m
//  RunLoop
//
//  Created by Jeremy on 2019/9/25.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "ViewController.h"
//#import <mach>
//#include <mach/port.h>
#include <mach/mach_port.h>
#include <mach/message.h>
#import "RunLoopSource.h"
#import "RunLoopDelegate.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(timerThreadAction) object:nil];
//    thread.name = @"haocai";
//    [thread start];
//    NSPort * tport = [NSMachPort port];
////    [tport sendBeforeDate:<#(nonnull NSDate *)#> components:<#(nullable NSMutableArray *)#> from:<#(nullable NSPort *)#> reserved:<#(NSUInteger)#>]
//    NSLog(@"[开启了一个线程 ： %@]", thread);
//
//    UIButton * btn = ({
//        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.backgroundColor = [UIColor grayColor];
//        [button setTitle:@"通知子线程做事" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(doSomething:) forControlEvents:UIControlEventTouchUpInside];
//        button.frame = CGRectMake(30, 200, 240, 100);
//        button;
//    });
//    [self.view addSubview:btn];
//
//    UIButton * btn1 = ({
//        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.backgroundColor = [UIColor grayColor];
//        [button setTitle:@"结束source0" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(endSource0:) forControlEvents:UIControlEventTouchUpInside];
//        button.frame = CGRectMake(30, 340, 240, 100);
//        button;
//    });
//    [self.view addSubview:btn1];
//    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopDefaultMode, ^{
//        NSLog(@"CFRunLoopPerformBlock main");
//    });
//    __unused CFRunLoopMode model = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
//    __unused CFAbsoluteTime time = CFRunLoopGetNextTimerFireDate(CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
//    NSRunLoop
//    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, <#CFRunLoopSourceContext *context#>)
//    CFRunLoopSourceContext context =
    
//    CFRunLoopObserverContext observerC;
//    CFRunLoopObserverCallBack back = ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
//        
//    };
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, <#CFOptionFlags activities#>, YES, 0, back, &observerC);
    
//    CFRunLoopAddObserver(CFRunLoopGetMain(), <#CFRunLoopObserverRef observer#>, <#CFRunLoopMode mode#>)
    
    // 切换mode时
//    __CFRunLoopLock()
//    __CFRunLoopModeLock()
//    当运行NSTimer时 我们只能设置为commonMode 如果当前线程的runloop的mode 是private mode的话 那么timer可能就会错过执行了 还在main queue的runloop大部分时间都是在commonmode里的
    
//    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1, true);
}

//void observerCallback() {
//    NSLog(@"observerCallback");
//}

//- (mach_port_t)createPortAndAddListener {
//    mach_port_t server_port;
//    kern_return_t kr = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &server_port);
//    assert(kr == KERN_SUCCESS);
//
//    NSLog(@"create a port : %d", server_port);
//
//    kr = mach_port_insert_right(mach_task_self(), server_port, server_port, MACH_MSG_TYPE_MAKE_SEND);
//    assert(kr == KERN_SUCCESS);
//
//    [self setMachPortListener:server_port];
//    return server_port;
//}
//
//- (void)setMachPortListener:(mach_port_t)mach_port {
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        mach_message mach_message;
//
//        mach_message.Head.msgh_size = 1024;
//        mach_message.Head.msgh_local_port = server_port;
//
//        mach_msg_return_t mr;
//
//        while (true) {
//            mr = mach_msg(&mach_message.Head,
//                          MACH_RCV_MSG | MACH_RCV_LARGE,
//                          0,
//                          mach_message.Head.msgh_size,
//                          mach_message.Head.msgh_local_port,
//                          MACH_MSG_TIMEOUT_NONE,
//                          MACH_PORT_NULL);
//
//            if (mr != MACH_MSG_SUCCESS && mr != MACH_RCV_TOO_LARGE) {
//                NSLog(@"error!");
//            }
//
//            mach_msg_id_t msg_id = mach_message.Head.msgh_id;
//            mach_port_t remote_port = mach_message.Head.msgh_remote_port;
//            mach_port_t local_port = mach_message.Head.msgh_local_port;
//
//            NSLog(@"Receive a mach message:[%d], remote_port: %d, local_port: %d, exception code: %d",
//                  msg_id,
//                  remote_port,
//                  local_port,
//                  mach_message.exception);
//
//            abort();
//        }
//    });
//}

- (void)sendMachPortMessage:(mach_port_t)mach_port {
    kern_return_t kr;
    mach_msg_header_t header;
    header.msgh_bits = MACH_MSGH_BITS(MACH_MSG_TYPE_COPY_SEND, 0);
    header.msgh_size = sizeof(mach_msg_header_t);
    header.msgh_remote_port = mach_port;
    header.msgh_local_port = MACH_PORT_NULL;
    header.msgh_id = 100;
    
    NSLog(@"send a mach message : [%d].", header.msgh_id);
    
    kr = mach_msg(&header,
                  MACH_SEND_MSG,
                  header.msgh_size,
                  0,
                  MACH_PORT_NULL,
                  MACH_MSG_TIMEOUT_NONE,
                  MACH_PORT_NULL);
}

- (void)timerThreadAction {
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    RunLoopSource *src = [[RunLoopSource alloc] init];
    [src addToCurrentRunLoop];
    do {
        [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    } while (YES);
}

- (void)doSomething:(UIButton *)sender {
    NSMutableArray * rlSource = [RunLoopDelegate sharedDelegate].sourcesToPing;
    id obj = rlSource.lastObject;
    if ([obj isKindOfClass:[RunLoopContext class]]) {
        RunLoopContext * context = (RunLoopContext *)obj;
        RunLoopSource *source = context.source;
        [source addCommand:0 withData:@"customCommand"];
        [source fireAllCommandsOnRunLoop:context.runLoop];
    }
    else {
        NSLog(@"obj error");
    }
}

- (void)endSource0:(UIButton *)sender {
    NSMutableArray * rlSource = [RunLoopDelegate sharedDelegate].sourcesToPing;
    id obj = rlSource.lastObject;
    if ([obj isKindOfClass:[RunLoopContext class]]) {
        RunLoopContext * context = (RunLoopContext *)obj;
        RunLoopSource *source = context.source;
        [source invalidate:context.runLoop];
    }
    else {
        NSLog(@"obj error");
    }
}

@end
