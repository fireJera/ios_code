//
//  Sentinel.h
//  Lock
//
//  Created by Jeremy on 2019/5/3.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Sentinel : NSObject

@property (readonly) int32_t value;
- (int32_t)increase;

@end

NS_ASSUME_NONNULL_END
