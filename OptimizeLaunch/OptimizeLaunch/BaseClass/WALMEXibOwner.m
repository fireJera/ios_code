//
//  WALMEXibOwner.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEXibOwner.h"

@implementation WALMEXibOwner

+ (id)viewFromNibNamed:(NSString*)nibName {
    WALMEXibOwner *owner = [[self alloc] init];
    [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
    return owner.view;
}
@end
