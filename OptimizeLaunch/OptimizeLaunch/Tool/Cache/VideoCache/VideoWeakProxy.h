//
//  VideoWeakProxy.h
//  VideoCacheDemo
//
//  Created by dangercheng on 2018/8/7.
//  Copyright © 2018年 DandJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoWeakProxy : NSProxy

@property (nullable, readonly, nonatomic, weak) id target;

+ (instancetype)proxyWithtTarget:(id)target;

- (instancetype)initWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
