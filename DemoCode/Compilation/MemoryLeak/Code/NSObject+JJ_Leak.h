//
//  NSObject+JJ_Leak.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JJCheck(TARGET) [self willReleaseObject:(TARGET) relationship:@#TARGET];

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JJ_Leak)

- (BOOL)willDealloc;
- (void)willReleaseObject:(id)object relationship:(NSString *)relationship;

- (void)willReleaseChild:(id)child;
- (void)willReleaseChildren:(NSArray *)children;

- (NSArray *)viewStack;

+ (void)addClassNamesToWhitelist:(NSArray *)classNames;

+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzleSEL;

@end

NS_ASSUME_NONNULL_END
