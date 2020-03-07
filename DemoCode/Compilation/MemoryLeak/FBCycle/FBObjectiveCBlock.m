//
//  FBObjectiveCBlock.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "FBObjectiveCBlock.h"

#import <objc/runtime.h>

#import "FBBlockStrongLayout.h"
#import "FBBlockStrongRelationDetector.h"
#import "FBObjectGraphConfiguration.h"
#import "FBObjectiveCObject.h"
#import "FBRetainCycleUtils.h"

// __attribute__((packed)) 告诉编译器在取消结构体在编译过程中的优化对齐 按照实际占用字节数对齐

struct __attribute__((packed)) BlockLiteral {
    void *isa;
    int flags;
    int reserved;
    void *invoke;
    void *descriptor;
};

@implementation FBObjectiveCBlock

- (NSSet *)allRetainObjects {
    NSMutableArray * results = [[[super allRetainObjects] allObjects] mutableCopy];
    
    // Grab a strong reference to the object, otherwise it can crash while doing
    // nasty stuff on deallocation
    __attribute__((objc_precise_lifetime)) id anObject = self.object;
    
    void *blockObjectReference = (__bridge void *)anObject;
    NSArray *allRetainedReference = FBGetBlockStrongReferences(blockObjectReference);
    
    for (id object in allRetainedReference) {
        FBObjectiveCGraphElement *element = FBWrapObjectGraphElement(self, object, self.configuration);
        if (element) {
            [results addObject:element];
        }
    }
    
    return [NSSet setWithArray:results];
}


/**
 * We want to add more information to blocks because they show up
 * in reports as MallocBlock and StackBlock which is not very informative.
 *
 * A block object is composed of:
 * - code: what should be executed, it's stored in the .TEXT section ;
 * - data: the variables that have been captured ;
 * - metadata: notably the function signature.
 *
 * We extract the address of the code, which can then be converted to a
 * human readable name given the debug symbol file.
 *
 * The symbol name contains the name of the function which allocated
 * the block, making is easier to track the piece of code participating
 * in the cycle. The symbolication must be done outside of this code
 * since it will require access to the debug symbols, not present at
 * runtime.
 *
 * Format: <<CLASSNAME:0xADDR>>
 */

- (NSString *)classNameOrNull {
    NSString * className = NSStringFromClass([self objectClass]);
    if (!className) {
        className = @"(null)";
    }
    
    // Find the reference of the block object.
    // 表明变量在整个作用域中都是有用的 防止过早释放
    __attribute__((objc_precise_lifetime)) id anObject = self.object;
    if ([anObject isKindOfClass:[FBBlockStrongRelationDetector class]]) {
        FBBlockStrongRelationDetector *blockObject = anObject;
        anObject = [blockObject forwarding];
    }
    void *blockObjectReference = (__bridge void *)anObject;
    if (!blockObjectReference) {
        return className;
    }
    
    // Extract the invocated block of code from the structure
    const struct BlockLiteral *block = (struct BlockLiteral *)blockObjectReference;
    const void *blockCodePtr = block->invoke;
    return [NSString stringWithFormat:@"<<%@:0x%llx>>", className, (unsigned long long)blockCodePtr];
}

@end
