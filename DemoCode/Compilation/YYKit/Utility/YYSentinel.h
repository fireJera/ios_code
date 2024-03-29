//
//  YYSentinel.h
//  YYKit
//
//  Created by super on 2018/12/27.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYSentinel : NSObject

@property (readonly) int32_t * value;

- (int32_t)increase;

@end

NS_ASSUME_NONNULL_END
