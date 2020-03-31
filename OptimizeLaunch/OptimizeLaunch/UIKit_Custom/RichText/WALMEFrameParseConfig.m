//
//  WALMEFrameParseConfig.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEFrameParseConfig.h"

@implementation WALMEFrameParseConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _width = 200.f;
        _fontSize = 13.0f;
        _lineSpace = 8.0f;
        _textColor = [UIColor colorWithRed:108 / 255.0 green:108 / 255.0 blue:108 / 255.0 alpha:1];
    }
    return self;
}



@end
