//
//  RunLoopDelegate.m
//  RunLoop
//
//  Created by Jeremy on 2020/3/5.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "RunLoopDelegate.h"
#import "RunLoopSource.h"

@implementation RunLoopDelegate

+ (instancetype)sharedDelegate {
    static RunLoopDelegate * _delegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _delegate = [[RunLoopDelegate alloc] init];
        _delegate.sourcesToPing = [NSMutableArray array];
    });
    return _delegate;
}

- (void)registerSource:(RunLoopContext*)sourceInfo {
    [_sourcesToPing addObject:sourceInfo];
}

- (void)removeSources:(RunLoopContext *)sourceInfo {
    id objToRemove = nil;
    for (RunLoopContext * context in _sourcesToPing) {
        if ([context.source isEqual:sourceInfo.source]) {
            objToRemove = context;
            break;
        }
    }
    if (objToRemove) {
        [_sourcesToPing removeObject:objToRemove];
        NSLog(@"remove source");
    }
}

@end
