//
//  CopyableC.m
//  KVCKVO
//
//  Created by Jeremy on 2020/3/25.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "CopyableC.h"

@implementation CopyableC

//- (id)copy {
//    return self;
//}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
