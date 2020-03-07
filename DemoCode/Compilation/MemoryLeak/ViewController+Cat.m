//
//  ViewController+Cat.m
//  MemoryLeak
//
//  Created by Jeremy on 2020/3/4.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "ViewController+Cat.h"
#import <objc/runtime.h>

@implementation ViewController (Cat)

- (void)setCatObj:(NSObject *)catObj {
    objc_setAssociatedObject(catObj, @selector(catObj), catObj, OBJC_ASSOCIATION_RETAIN);
}

- (NSObject *)catObj {
    return objc_getAssociatedObject(self, @selector(catObj));
}

@end
