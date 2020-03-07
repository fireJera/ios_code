//
//  ViewController.m
//  Lock
//
//  Created by super on 2018/12/26.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>
#import <libkern/OSAtomic.h>
#import <QuartzCore/QuartzCore.h>
#import <os/lock.h>

typedef NS_ENUM(NSUInteger, LockType) {
    LockTypeos_unfair_lock,
    LockTypeOSSpinLock,
    LockTypedispatch_seamphore,
    LockTypepthread_mutex,
    LockTypeNSCondition,
    LockTypeNSLock,
    LockTypepthread_mutex_recursive,
    LockTypeNSRecursiveLock,
    LockTypeNSConditionLock,
    LockTypeSynchronized,
    LockTypeCount,
};

NSTimeInterval timeCosts[LockTypeCount] = {0};
int TimeCount = 0;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self sychronizedLock];
    //    [self nsLock];
    //    [self pThreadLock];
    //    [self lock5];
    //    [self lock16];
    [self addTestView];
}

#pragma mark - huchisuo

- (void)sychronizedLock {
    @synchronized (self) {
        NSLog(@"1");
    }
    @synchronized (self) {
        NSLog(@"2");
    }
}

- (void)nsLock {
    NSLock * xwLock = [[NSLock alloc] init];
    void(^logBlock)(NSArray *array) = ^(NSArray * array) {
        [xwLock lock];
        for (id obj in array) {
            NSLog(@"%@", obj);
        }
        [xwLock unlock];
    };
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray * array = @[@1,@2,@3];
        logBlock(array);
    });
    //    NSLock * lock = [[NSLock alloc] init];
    //    [lock lock];
    //    NSLog(@"1");
    //    sleep(1);
    //    [lock unlock];
    //
    //    [lock lock];
    //    NSLog(@"2");
    //    [lock unlock];
}

- (void)pThreadLock {
    __block pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, NULL);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"++++++ 线程1 start");
        pthread_mutex_lock(&mutex);
        sleep(2);
        pthread_mutex_unlock(&mutex);
        NSLog(@"++++++ 线程1 end");
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"++++++ 线程2 start");
        pthread_mutex_lock(&mutex);
        sleep(3);
        pthread_mutex_unlock(&mutex);
        NSLog(@"++++++ 线程2 end");
    });
}

#pragma mark -  diguisuo

- (void)lock5 {
    NSLock * commonLock = [[NSLock alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        static void (^XWRecursiveBlock)(int);
        
        XWRecursiveBlock = ^(int value) {
            [commonLock lock];
            if (value > 0) {
                NSLog(@"加锁层数：%d", value);
                sleep(1);
                XWRecursiveBlock(--value);
            }
            NSLog(@"程序退出!");
            [commonLock unlock];
        };
        
        XWRecursiveBlock(3);
    });
}

- (void)lock4 {
    NSRecursiveLock * recursiveLock = [[NSRecursiveLock alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        static void (^XWRecursiveBlock)(int);
        
        XWRecursiveBlock = ^(int value) {
            [recursiveLock lock];
            if (value > 0) {
                NSLog(@"加锁层数：%d", value);
                sleep(1);
                XWRecursiveBlock(--value);
            }
            NSLog(@"程序退出!");
            [recursiveLock unlock];
        };
        
        XWRecursiveBlock(3);
    });
}

- (void)lock6 {
    __block pthread_mutex_t recursiveLock;
    pthread_mutexattr_t recursiveMutexattr;
    
    pthread_mutexattr_init(&recursiveMutexattr);
    pthread_mutexattr_settype(&recursiveMutexattr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&recursiveLock, &recursiveMutexattr);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        static void (^XWRecursiveBlock)(int);
        
        XWRecursiveBlock = ^(int value) {
            pthread_mutex_lock(&recursiveLock);
            if (value > 0) {
                NSLog(@"加锁层数：%d", value);
                sleep(1);
                XWRecursiveBlock(--value);
            }
            NSLog(@"程序退出!");
            pthread_mutex_unlock(&recursiveLock);
        };
        
        XWRecursiveBlock(3);
    });
}

#pragma mark -  xinhaoliang

- (void)lock7 {
    dispatch_semaphore_t seamphore = dispatch_semaphore_create(0);
    NSLog(@"start");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"async ... ");
        sleep(5);
        dispatch_semaphore_signal(seamphore);
    });
    dispatch_semaphore_wait(seamphore, DISPATCH_TIME_FOREVER);
    NSLog(@"end");
}

- (void)lock8 {
    __block pthread_mutex_t seamphore = PTHREAD_MUTEX_INITIALIZER;
    __block pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
    NSLog(@"start");
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        pthread_mutex_lock(&seamphore);
        NSLog(@"async ... ");
        sleep(5);
        pthread_cond_signal(&cond);
        pthread_mutex_unlock(&seamphore);
    });
    
    pthread_cond_wait(&cond, &seamphore);
    NSLog(@"end");
}


#pragma mark -  tiaojia suo

- (NSMutableArray *)removeLastImage:(NSMutableArray *)images {
    if (images.count > 0) {
        NSCondition * condition = [[NSCondition alloc] init];
        [condition lock];
        [images removeLastObject];
        [condition unlock];
        NSLog(@"remove Last Image %@", images);
        return images;
    }
    return NULL;
}

- (void)lock10 {
    NSMutableArray * array = [NSMutableArray array];
    NSCondition * condition = [[NSCondition alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [condition lock];
        if (array.count == 0) {
            NSLog(@"等待制作数组");
            [condition wait];
        }
        id obj = array.firstObject;
        NSLog(@"获取对象进行操作:%@", obj);
        [condition unlock];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [condition lock];
        id obj = @"abcd";
        [array addObject:obj];
        NSLog(@"创建了一个对象:%@",obj);
        [condition signal];
        [condition unlock];
    });
}

- (void)lock11 {
    NSConditionLock * conditionLock = [[NSConditionLock alloc] init];
    NSMutableArray* arrayM = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [conditionLock lock];
        for (int i = 0; i < 6; i++) {
            [arrayM addObject:@(i)];
            NSLog(@"异步下载第 %d 张图片", i);
            sleep(1);
            if (arrayM.count == 4) {
                [conditionLock unlockWithCondition:4];
            }
        }
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [conditionLock lockWhenCondition:4];
        NSLog(@"已经获取到4张图片-> 主线程渲染");
        [conditionLock unlock];
    });
}

- (void)lock12 {
    __block pthread_mutex_t mutex;
    __block pthread_cond_t condition;
    
    pthread_mutex_init(&mutex, NULL);
    pthread_cond_init(&condition, NULL);
    
    NSMutableArray * arrayM = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        pthread_mutex_lock(&mutex);
        
        for (int i = 0; i < 6; i++) {
            [arrayM addObject:@(i)];
            NSLog(@"异步下载图片第 %d 张图片", i);
            sleep(1);
            if (arrayM.count == 4) {
                pthread_cond_signal(&condition);
            }
        }
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        pthread_cond_wait(&condition, &mutex);
        NSLog(@"已经获取到4张图片-> 主线程渲染");
        pthread_mutex_unlock(&mutex);
    });
}

- (void)lock13 {
    dispatch_queue_t queue = dispatch_queue_create("com.jeremy.test", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"任务1 -- %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务2 -- %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务3 -- %@", [NSThread currentThread]);
    });
    dispatch_barrier_sync(queue, ^{
        NSLog(@"任务0 -- %@", [NSThread currentThread]);
        for (int i = 0; i < 100; i++) {
            if (i % 30 == 0) {
                NSLog(@"任务0 -- log:%d -- %@", i, [NSThread currentThread]);
            }
        }
    });
    NSLog(@"dispath_barrie_sync down !!!");
    dispatch_async(queue, ^{
        NSLog(@"任务4 -- %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务5 -- %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务6 -- %@", [NSThread currentThread]);
    });
}

- (void)lock14 {
    __block pthread_rwlock_t rwlock;
    pthread_rwlock_init(&rwlock, NULL);
    __block NSMutableArray * arrayM = [NSMutableArray array];
    
    void(^writeBlock)(NSString * str) = ^(NSString * str) {
        NSLog(@"开始写操作");
        pthread_rwlock_wrlock(&rwlock);
        [arrayM addObject:str];
        sleep(2);
        pthread_rwlock_unlock(&rwlock);
    };
    
    void(^readBlock)(void) = ^() {
        NSLog(@"开始读操作");
        pthread_rwlock_rdlock(&rwlock);
        NSLog(@"读取数据:%@", arrayM);
        sleep(2);
        pthread_rwlock_unlock(&rwlock);
    };
    
    for (int i = 0; i < 5; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            writeBlock([NSString stringWithFormat:@"%d", i]);
        });
    }
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            readBlock();
        });
    }
}

- (void)lock16 {
    pthread_once_t once = PTHREAD_ONCE_INIT;
    pthread_once(&once, lock16Func);
}

void lock16Func() {
    static id sharedInstance;
    sharedInstance = [[NSObject alloc] init];
}

- (void)addTestView {
    int buttonCount = 5;
    for (int i = 0; i < buttonCount; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = (CGRect){0, 0, 200, 50};
        button.center = CGPointMake(self.view.frame.size.width / 2, i * 60 + 160);
        button.tag = pow(10, i + 3);
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"run (%d)", (int)button.tag] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)tap:(UIButton *)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test:(int)sender.tag];
    });
}

- (void)clear:(id)sender {
    for (NSUInteger i = 0; i < LockTypeCount; i++) {
        timeCosts[i] = 0;
    }
    TimeCount = 0;
    printf("-------clear------- \n\n");
}

- (void)log:(id)sender {
    printf("OSSpinLock:                 %8.2f ms\n", timeCosts[LockTypeOSSpinLock] * 1000);
    printf("dispatch_seamphore:         %8.2f ms\n", timeCosts[LockTypeOSSpinLock] * 1000);
    printf("pthread_mutex:              %8.2f ms\n", timeCosts[LockTypeOSSpinLock] * 1000);
    printf("NSCondition:                %8.2f ms\n", timeCosts[LockTypeOSSpinLock] * 1000);
    printf("NSLock:                     %8.2f ms\n", timeCosts[LockTypeOSSpinLock] * 1000);
    printf("pthread_mutex(recursive):   %8.2f ms\n", timeCosts[LockTypeOSSpinLock] * 1000);
    printf("NSRecursiveLock:            %8.2f ms\n", timeCosts[LockTypeOSSpinLock] * 1000);
    printf("NSConditionLock:            %8.2f ms\n", timeCosts[LockTypeOSSpinLock] * 1000);
    printf("@synchronized:              %8.2f ms\n", timeCosts[LockTypeOSSpinLock] * 1000);
    printf("--------fin (sum:%d)--------\n\n", TimeCount);
}

- (void)test:(int)count {
    NSTimeInterval begin, end;
    TimeCount += count;
    if (@available(iOS 10.0, *)) {
        {
            os_unfair_lock_t lock;
            lock = &(OS_UNFAIR_LOCK_INIT);
            begin = CACurrentMediaTime();
            for (int i = 0; i < count; i++) {
                os_unfair_lock_lock(lock);
                os_unfair_lock_unlock(lock);
            }
            end = CACurrentMediaTime();
            timeCosts[LockTypeos_unfair_lock] += end - begin;
            printf("os_unfair_lock:         %8.2f ms\n", (end - begin) * 1000);
        }
    }
    
    {
        OSSpinLock lock = OS_SPINLOCK_INIT;
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            OSSpinLockLock(&lock);
            OSSpinLockUnlock(&lock);
        }
        end = CACurrentMediaTime();
        timeCosts[LockTypeOSSpinLock] += end - begin;
        printf("OSSpinLock:                 %8.2f ms\n", (end - begin) * 1000);
    }
    
    {
        dispatch_semaphore_t lock = dispatch_semaphore_create(1);
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_signal(lock);
        }
        end = CACurrentMediaTime();
        timeCosts[LockTypedispatch_seamphore] += end - begin;
        printf("dispatch_seamphore:         %8.2f ms\n", (end - begin) * 1000);
    }
    
    {
        pthread_mutex_t lock;
        pthread_mutex_init(&lock, NULL);
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            pthread_mutex_lock(&lock);
            pthread_mutex_unlock(&lock);
        }
        end = CACurrentMediaTime();
        timeCosts[LockTypepthread_mutex] += end - begin;
        printf("pthread_mutex:              %8.2f ms\n", (end - begin) * 1000);
    }
    
    {
        NSCondition * lock = [[NSCondition alloc] init];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CACurrentMediaTime();
        timeCosts[LockTypeNSCondition] += end - begin;
        printf("NSCondition:                %8.2f ms\n", (end - begin) * 1000);
    }
    
    {
        NSLock * lock = [[NSLock alloc] init];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CACurrentMediaTime();
        timeCosts[LockTypeNSLock] += end - begin;
        printf("NSLock:                     %8.2f ms\n", (end - begin) * 1000);
    }
    
    {
        pthread_mutex_t lock;
        pthread_mutexattr_t mutextAttr;
        pthread_mutexattr_init(&mutextAttr);
        pthread_mutexattr_settype(&mutextAttr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&lock, &mutextAttr);
        pthread_mutexattr_destroy(&mutextAttr);
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            pthread_mutex_lock(&lock);
            pthread_mutex_unlock(&lock);
        }
        end = CACurrentMediaTime();
        timeCosts[LockTypepthread_mutex_recursive] += end - begin;
        printf("pthread_mutex_recursive:    %8.2f ms\n", (end - begin) * 1000);
    }
    
    {
        NSRecursiveLock *lock = [NSRecursiveLock new];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CACurrentMediaTime();
        timeCosts[LockTypeNSRecursiveLock] += end - begin;
        printf("NSRecursiveLock:            %8.2f ms\n", (end - begin) * 1000);
    }
    
    {
        NSConditionLock * lock = [[NSConditionLock alloc] initWithCondition:1];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CACurrentMediaTime();
        timeCosts[LockTypeNSConditionLock] += end - begin;
        printf("NSConditionLock:            %8.2f ms\n", (end - begin) * 1000);
    }
    
    {
        NSObject *lock = [NSObject new];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            @synchronized (lock) {
                
            }
        }
        end = CACurrentMediaTime();
        timeCosts[LockTypeSynchronized] += end - begin;
        printf("@synchronized:              %8.2f ms\n", (end - begin) * 1000);
    }
    
    printf("\n\n");
}

@end
