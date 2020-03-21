//
//  ViewController.m
//  Concurrent
//
//  Created by super on 2018/12/25.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import "TaskOperation.h"
#import "DownLoadOperation.h"
#import "DownloadQueue.h"

@interface ViewController ()

@property (nonatomic, strong) DownloadQueue *queue;
@property (nonatomic, strong) UILabel * progressLabel;

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self testOperationStart];
//    [self testOperationQueue];
    [self testDownload];
    [self addOpeation];
}

- (void)testDownload {
    _queue = [[DownloadQueue alloc] init];
    NSInteger time = 999999999;
    DownLoadOperation * operation = [[DownLoadOperation alloc] initWithTime:time];
    __weak typeof(self) weakSelf = self;
    operation.progresBlock = ^(float progress, NSInteger time) {
        NSString * string = [NSString stringWithFormat:@"progress: %.2f, time : %d", progress, (int)time];
        weakSelf.progressLabel.text = string;
    };
    [_queue addOperation:operation];
}

- (void)addOpeation {
    _progressLabel = ({
        UILabel * label = [[UILabel alloc] init];
        label.text = @"progress : 0.0%, time : 0";
        label.frame = CGRectMake(50, 100, 300, 40);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label;
    });
    [self.view addSubview:_progressLabel];
    UIButton * start = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"start" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(16, 400, 100, 60);
        button;
    });
    [self.view addSubview:start];
    
    UIButton * pause = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"pause" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(132, 400, 100, 60);
        button;
    });
    [self.view addSubview:pause];
    UIButton * delete = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"delete" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(248, 400, 100, 60);
        button;
    });
    [self.view addSubview:delete];
}

- (void)start:(UIButton *)sender {
    _progressLabel.text = @"正在下载";
    [_queue startAll];
}

- (void)pause:(UIButton *)sender {
    _progressLabel.text = @"已暂停";
    [_queue pauseAll];
}

- (void)delete:(UIButton *)sender {
    _progressLabel.text = @"已删除";
    [_queue removeAll];
}

- (void)testOperationQueue {
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
//    [queue setMaxConcurrentOperationCount:2];
    [queue addOperation:[[TaskOperation alloc] initWithTaskName:@"task1"]];
    TaskOperation *task2 = [[TaskOperation alloc] initWithTaskName:@"task2"];
    [queue addOperation:task2];
    [queue addOperation:[[TaskOperation alloc] initWithTaskName:@"task3"]];
    [queue addOperation:[[TaskOperation alloc] initWithTaskName:@"task4"]];
//    [task2 cancel];
//    [queue setSuspended:NO];
//    [queue waitUntilAllOperationsAreFinished];
}

- (void)testOperationStart {
    TaskOperation * op = [[TaskOperation alloc] initWithTaskName:@"main task"];
    [op start];
    
    NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(otherTask) object:nil];
    [thread setName:@"global thread"];
    [thread start];
    
    TaskOperation * op2 = [[TaskOperation alloc] initWithTaskName:@"second main task"];
    [op2 start];
}

- (void)otherTask {
    TaskOperation * op1 = [[TaskOperation alloc] initWithTaskName:@"global task"];
    [op1 start];
}

- (void)test_dispatch_setTarget {
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("queue3", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue4 = dispatch_queue_create("queue4", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue5 = dispatch_queue_create("queue5", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue6 = dispatch_queue_create("queue6", DISPATCH_QUEUE_SERIAL);
    
        dispatch_set_target_queue(queue2, queue1);
    //    dispatch_set_target_queue(queue3, queue2);
    //    dispatch_set_target_queue(queue4, queue3);
    //    dispatch_set_target_queue(queue5, queue4);
    //    dispatch_set_target_queue(queue6, queue5);
    
    dispatch_async(queue1, ^{
        NSLog(@"queue1 current thread:%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue2, ^{
        NSLog(@"queue2 current thread:%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue3, ^{
        NSLog(@"queue3 current thread:%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue4, ^{
        NSLog(@"queue4 current thread:%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue5, ^{
        NSLog(@"queue5 current thread:%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue6, ^{
        NSLog(@"queue6 current thread:%@", [NSThread currentThread]);
    });
}


@end
