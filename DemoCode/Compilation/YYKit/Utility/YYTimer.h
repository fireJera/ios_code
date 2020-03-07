//
//  YYTimer.h
//  YYKit
//
//  Created by super on 2018/12/27.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYTimer : NSObject

//+ (YYTimer *)scheduleTimerWithTimeInterval:(NSTimeInterval)timeInterval
//                                   repeats:(BOOL)repeats
//                                     block:(void(^)(YYTimer *))block;

+ (YYTimer *)scheduleTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                    target:(id)target
                                  selector:(SEL)selector
                                   repeats:(BOOL)repeats;
//
//- (instancetype)initWithFireTime:(NSTimeInterval)start
//                        interval:(NSTimeInterval)interval
//                           block:(void(^)(YYTimer *))block;
//                         repeats:(BOOL)repeats;

- (instancetype)initWithFireTime:(NSTimeInterval)start
                        interval:(NSTimeInterval)interval
                          target:(id)target
                        selector:(SEL)selector
                         repeats:(BOOL)repeats;

@property (readonly) BOOL repeats;
@property (readonly) NSTimeInterval interval;
@property (readonly, getter=isValid) BOOL valid;

- (void)invalidate;

- (void)fire;

@end

NS_ASSUME_NONNULL_END
