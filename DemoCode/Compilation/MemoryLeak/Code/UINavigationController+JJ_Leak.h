//
//  UINavigationController+JJ_Leak.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>

#if _INTERNAL_MLF_ENABLED

NS_ASSUME_NONNULL_BEGIN

static const void * const kPoppedDetailVCKey = &kPoppedDetailVCKey;

@interface UINavigationController (JJ_Leak)

@end

NS_ASSUME_NONNULL_END

#endif
