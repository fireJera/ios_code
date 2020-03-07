//
//  JERInvokeBlock.h
//  Compilation
//
//  Created by Jeremy on 2019/3/1.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define metamacro_contact_(A, B) A##B

#define metamacro_contact(A, B)\
        metamacro_contact_(A, B)

#define metamacro_at(N, ...) \
        metamacro_contact(metamacro_at, N)(__VA_ARGS__)

NS_ASSUME_NONNULL_BEGIN

@interface JERInvokeBlock : NSObject

+ (id)invokeBlock:(id)block withArguments:(NSArray *)arguments;

@end

NS_ASSUME_NONNULL_END

