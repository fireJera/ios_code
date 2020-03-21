//
//  TaskOperation.h
//  Concurrent
//
//  Created by Jeremy on 2020/3/12.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const TaskOperationStartNotification;
FOUNDATION_EXPORT NSString * const TaskOperationReceiveResponseNotification;
FOUNDATION_EXPORT NSString * const TaskOperationStopNotification;
FOUNDATION_EXPORT NSString * const TaskOperationFinishNotification;

@interface TaskOperation : NSOperation

@property (nonatomic, copy) NSString * taskName;

@property (nonatomic, copy) NSString * endWork;

- (instancetype)initWithTaskName:(NSString *)taskName;

@end

NS_ASSUME_NONNULL_END
