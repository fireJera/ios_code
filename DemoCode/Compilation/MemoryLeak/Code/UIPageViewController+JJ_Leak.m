//
//  UIPageViewController+JJ_Leak.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "UIPageViewController+JJ_Leak.h"
#import "NSObject+JJ_Leak.h"

#if _INTERNAL_MLF_ENABLED

@implementation UIPageViewController (JJ_Leak)

- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }
    [self willReleaseChildren:self.viewControllers];
    return YES;
}

@end

#endif
