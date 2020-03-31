//
//  WALMEGCDTimer.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WALMEGCDTimer : NSObject

@property(nonatomic, assign) _Nullable dispatch_source_t timer;

/**
 
 interval        时间间隔
 repeats         是否循环调用
 action          回调block
 callBlockNow    开启后，是否立即进行一次回调
 
 */
+ (instancetype)scheduledDispatchTimerTimeInterval:(double)interval
                                           repeats:(BOOL)repeats
                                      callBlockNow:(BOOL)callBlockNow
                                            action:(dispatch_block_t)action;

/**
 取消/结束一个timer
 */
- (void)cancelDispatchTimer;

@end

NS_ASSUME_NONNULL_END
