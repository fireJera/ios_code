//
//  WALMEAlbumView.m
//  CodeFrame
//
//  Created by Jeremy on 2019/4/20.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEAlbumView.h"

@implementation WALMEAlbumView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (void)p_commonInit {
    
}

@end
