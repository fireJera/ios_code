//
//  RunLoopDelegate.h
//  RunLoop
//
//  Created by Jeremy on 2020/3/5.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RunLoopContext;

NS_ASSUME_NONNULL_BEGIN

@interface RunLoopDelegate : NSObject

@property (nonatomic, strong) NSMutableArray<RunLoopContext *> * sourcesToPing;

+ (instancetype)sharedDelegate;

- (void)registerSource:(RunLoopContext*)sourceInfo;
- (void)removeSources:(RunLoopContext *)sourceInfo;

@end

NS_ASSUME_NONNULL_END
