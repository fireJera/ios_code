//
//  YYTransaction.h
//  YYKit
//
//  Created by super on 2018/12/27.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYTransaction : NSObject

+ (YYTransaction *)transactionWithTarget:(id)target selector:(SEL)selector;

- (void)commit;
- (void)unbind;

@end

NS_ASSUME_NONNULL_END
