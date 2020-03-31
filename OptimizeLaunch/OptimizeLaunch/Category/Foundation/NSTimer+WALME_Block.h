//
//  NSTimer+WALME_Custom.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (WALME_Block)

+ (NSTimer *)walme_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(void))block;

@end

typedef void(^WALMEExecuteDisplayLinkBlock) (CADisplayLink *displayLink);

@interface CADisplayLink (WALME_Block)

@property (nonatomic,copy)WALMEExecuteDisplayLinkBlock executeBlock;

+ (CADisplayLink *)displayLinkWithExecuteBlock:(WALMEExecuteDisplayLinkBlock)block;

@end

NS_ASSUME_NONNULL_END
