//
//  UIApplication+JJ_Leak.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>

#if _INTERNAL_MLF_ENABLED

NS_ASSUME_NONNULL_BEGIN

extern const void * const kLatestSenderKey;

@interface UIApplication (JJ_Leak)

@end

NS_ASSUME_NONNULL_END

#endif

@interface UIControl (JJ_Leak)

@end
