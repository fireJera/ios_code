//
//  WALMECoreTextData.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMECoreTextData.h"

@implementation WALMECoreTextData

- (void)setCtFrame:(CTFrameRef)ctFrame {
    if (_ctFrame != ctFrame) {
        if (_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
    }
    CFRetain(ctFrame);
    _ctFrame = ctFrame;
}

- (void)dealloc {
    if (_ctFrame != nil) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

@end
