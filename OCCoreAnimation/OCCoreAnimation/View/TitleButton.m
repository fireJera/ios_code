//
//  TitleButton.m
//  OCCoreAnimation
//
//  Created by Jeremy on 4/5/17.
//  Copyright © 2017 Jeremy. All rights reserved.
//

#import "TitleButton.h"

@implementation TitleButton

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.backgroundColor = [UIColor grayColor];
    }
    
    return self;
}

@end
