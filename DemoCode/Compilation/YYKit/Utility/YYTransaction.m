//
//  YYTransaction.m
//  YYKit
//
//  Created by super on 2018/12/27.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "YYTransaction.h"

@interface YYTransaction ()
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL selector;
@end

static NSMutableSet * transactions = nil;

static void YYRunLoopObserverCallback (CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    if (transactions.count == 0) return;
    NSSet * currentSet = transactions;
    transactions = [NSMutableSet set];
    [currentSet enumerateObjectsUsingBlock:^(YYTransaction * transaction, BOOL * stop) {
#pragma clang diagnostic push
#pragma clang diagnositc ignored "-Warc-performSelector-leaks"
        [transaction.target performSelector:transaction.selector];
#pragma clang diagnostic pop
    }];
}

static void YYCallbackObserverSetup () {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transactions = [NSMutableSet set];
        CFRunLoopRef runloop = CFRunLoopGetMain();
        CFRunLoopObserverRef observer;
        
        observer = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                           kCFRunLoopBeforeWaiting | kCFRunLoopBeforeSources,
                                           true,
                                           0xFFFFFF,
                                           YYRunLoopObserverCallback, NULL);
        CFRunLoopAddObserver(runloop, observer, kCFRunLoopCommonModes);
        CFRelease(observer);
    });
}


@implementation YYTransaction

+ (YYTransaction *)transactionWithTarget:(id)target selector:(SEL)selector {
    if (!selector || !target) return nil;
    YYTransaction * transaction = [YYTransaction new];
    transaction.target = target;
    transaction.selector = selector;
    return transaction;
}

- (void)commit {
    if (!_target || !_selector) return;
    YYCallbackObserverSetup();
    [transactions addObject:self];
}

- (void)unbind {
    [transactions removeObject:self];
}

- (NSUInteger)hash {
    long v1 = (long)((void *) _selector);
    long v2 = (long)_target;
    return v1 ^ v2;
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isMemberOfClass:self.class]) return NO;
    YYTransaction * other = object;
    return _target == other.target && _selector == other.selector;
}

@end
