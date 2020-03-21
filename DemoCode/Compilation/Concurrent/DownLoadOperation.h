//
//  DownLoadOperation.h
//  Concurrent
//
//  Created by Jeremy on 2020/3/13.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString * const DownLoadOperationNotification;

@interface FinishOperation : NSObject

@property (nonatomic, copy, readonly) NSString * name;
@property (nonatomic, assign, readonly) NSInteger time;

- (instancetype)initWitTime:(NSInteger)time name:(NSString *)name;

@end

@interface DownLoadOperation : NSOperation

@property (nonatomic, assign, readonly) float progress;
@property (nonatomic, assign, readonly) NSInteger currentTime;

@property (nonatomic, copy) void(^progresBlock)(float, NSInteger);
@property (nonatomic, copy) void(^finishBlk)(void);

// if realCancel, exectuing task will cancel too.
@property (nonatomic, assign, readonly) BOOL realCancel;
@property (nonatomic, assign, readonly) BOOL realPause;

- (void)setDownloadReady;
- (instancetype)initWithTime:(NSInteger)time;
- (instancetype)initWithTime:(NSInteger)time realCancel:(BOOL)realCancel realPause:(BOOL)realPause;
// if realPause == YES return new operation, self done, else return nil, self continue run.
- (instancetype)pauseDownload;

@end

NS_ASSUME_NONNULL_END
