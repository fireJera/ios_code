//
//  DownloadQueue.h
//  Concurrent
//
//  Created by Jeremy on 2020/3/14.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DownLoadOperation, FinishOperation;

@interface DownloadQueue : NSObject

@property (nonatomic, strong) NSOperationQueue * downloadQueue;
@property (nonatomic, assign, readonly, getter=isAllStarted) BOOL allStarted;
@property (nonatomic, assign, readonly, getter=isPaused) BOOL allPaused;

@property (nonatomic, assign, readonly) NSInteger allDownloadCount;
@property (nonatomic, assign, readonly) NSInteger finishedCount;
@property (nonatomic, copy) NSArray<FinishOperation *> * finishedOperations;

- (void)addOperation:(DownLoadOperation *)operation;

- (void)startAll;
- (void)pauseAll;
- (void)resumeAll;
- (void)removeAll;

- (void)startOperation:(DownLoadOperation *)operation;
- (void)pauseOperation:(DownLoadOperation *)operation;
- (void)resumeOperation:(DownLoadOperation *)operation;
- (void)removeOperation:(id)operation;

- (void)p_testAddDownload;

- (id)operationForIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
