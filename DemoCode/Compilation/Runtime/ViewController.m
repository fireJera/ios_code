//
//  ViewController.m
//  Runtime
//
//  Created by super on 2018/12/26.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import "Test.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    const uint8_t *layout = class_getIvarLayout([Test class]);
    const uint8_t *weaklayout = class_getWeakIvarLayout([Test class]);
    unsigned int count;
    Ivar * ivars = class_copyIvarList([Test class], &count);
    
    int i = 0;
    uint8_t value_s;
    if (layout != NULL) {
        value_s = layout[i];
        while (value_s != 0x0) {
            printf("\\x%02x\n", value_s);
            value_s = layout[++i];
        }
    }
    
    if (weaklayout != NULL) {
        printf("\n");
        i = 0;
        value_s = weaklayout[i];
        while (value_s != 0x0) {
            printf("\\x%02x\n", value_s);
            value_s = weaklayout[++i];
        }
    }
    
    for (int i = 0; i < count; i++) {
        Ivar var = ivars[i];
        ptrdiff_t varPtr = ivar_getOffset(var);
        const char * name = ivar_getName(var);
        NSLog(@"name : %s,   offset : %td   index:%lu", name, varPtr, varPtr / sizeof(void *));
        NSUInteger size, align;
        NSGetSizeAndAlignment(ivar_getTypeEncoding(var), &size, &align);
        if (align == 0) {
            align = _Alignof(void *);
        }
        
        NSUInteger overAlignment = varPtr % align;
        NSUInteger whatsMissing = (overAlignment == 0) ? 0 : align - overAlignment;
        varPtr += whatsMissing;
//        NSLog(@"ca offset : %td", varPtr);
    }
    
//    Ivar var = ivars[0];
//    ptrdiff_t minVarPtr = ivar_getOffset(var);
//    NSMutableIndexSet *interestingIndexes = [NSMutableIndexSet new];
//    NSUInteger currentIndex = minVarPtr / sizeof(void *);
//
//    while (*layout != '\x00') {
//        int upperNibble = (*layout & 0xf0) >> 4;
//        int lowerNillbe = *layout & 0xf;
//
//        currentIndex += upperNibble;
//        [interestingIndexes addIndexesInRange:NSMakeRange(currentIndex, lowerNillbe)];
//        currentIndex += lowerNillbe;
//        NSLog(@"layout : %hhu,  upperNibble: %d,  lowerNibble : %d", *layout, upperNibble, lowerNillbe);
//        NSLog(@"%@", interestingIndexes);
//        ++layout;
//    }
    
    // 4 | 4  2  8  4  4  2  4  4  4  4  4  4
    // 0 | 4  8  10 12 16 20 24 28 32 36 40 44
    
    // 8 | 8  2  8  4  8  2  4  4  8  8  8  8
    // 0 | 8  18 32 40 48 56 60 64 72 80
    
//    Test * test = [Test new];
//    Class tcls = [test class];
//    Class Tcls = [Test class];
//
//    NSLog(@"%@", tcls);
//    NSLog(@"%@", Tcls);
//    BOOL res1 = [[NSObject class] isKindOfClass:[NSObject class]];
//    BOOL res2 = [[NSObject class] isMemberOfClass:[NSObject class]];
//    BOOL res3 = [[Test class] isKindOfClass:[Test class]];
//    BOOL res4 = [[Test class] isMemberOfClass:[Test class]];
    
//    NSLog(@"%d %d %d %d", res1,res2,res3,res4);
    
//    SEL selector = NSSelectorFromString(@"msgSend");
//    ((void(*)(Test *, SEL))(void *)objc_msgSend)(test, selector);
////    [test performSelector:selector];
//
//    selector = NSSelectorFromString(@"someMethod");
//    ((void(*)(id , SEL))(void *)objc_msgSend)([Test class], selector);
////    [Test performSelector:selector];
//
//    selector = NSSelectorFromString(@"forwarInstanceMethod");
//    ((void(*)(Test *, SEL))(void *)objc_msgSend)(test, selector);
//
//    selector = NSSelectorFromString(@"forwarClassMethod");
//    ((void(*)(id, SEL))(void *)objc_msgSend)([Test class], selector);
//
//    selector = NSSelectorFromString(@"forwarInstanceInvacation");
//    ((void(*)(Test *, SEL))(void *)objc_msgSend)(test, selector);
//
//    selector = NSSelectorFromString(@"forwarClassInvacation");
//    ((void(*)(id, SEL))(void *)objc_msgSend)([Test class], selector);
    
//    [self blockInvocation];
}

typedef NS_OPTIONS(int, BlockFlags) {
    blockHasCopyDisposeHelpers  = (1<<25),
    blockFlagsHasSignature      = (1<<30)
};

typedef struct blockStruct  {
    void *isa;
    int Flags;
//    BlockFlags Flags;
    int Reserved;
    void *FuncPtr;
    struct {
        unsigned long reserved;
        unsigned long size;
        // require blockHasCopyDisposeHelpers
        void (*copy)(void *dst, const void *src);
        void (*dispose)(const void *);
        // require blockFlagsHasSignature
        const char *signature;
        const char * layout;
    } *descriptor;
} *blockStrucrRef;

- (void)blockInvocation {
    void(^block)(int) = ^(int count) {
        NSLog(@"block : %d", count);
    };
    
    blockStrucrRef layout = (__bridge void *)block;
    NSString * description = [NSString stringWithFormat:@"The block %@ does not contain a type signature", block];
    void * desc = layout->descriptor;
    desc += 2 * sizeof(unsigned long int);
    const char * sign = (*(const char **)desc);
    NSMethodSignature * signature = [NSMethodSignature signatureWithObjCTypes:sign];
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:block];
    int a = 2;
    [invocation setArgument:&a atIndex:1];
    [invocation invoke];
}

//static NSMethodSignature *aspect_blockMethodSignature(id block, NSError **error) {
//    AspectBlockRef layout = (__bridge void *)block;
//    if (!(layout->flags & AspectBlockFlagsHasSignature)) {
//        NSString *description = [NSString stringWithFormat:@"The block %@ doesn't contain a type signature.", block];
//        AspectError(AspectErrorMissingBlockSignature, description);
//        return nil;
//    }
//    void *desc = layout->descriptor;
//    desc += 2 * sizeof(unsigned long int);
//    if (layout->flags & AspectBlockFlagsHasCopyDisposeHelpers) {
//        desc += 2 * sizeof(void *);
//    }
//    if (!desc) {
//        NSString *description = [NSString stringWithFormat:@"The block %@ doesn't has a type signature.", block];
//        AspectError(AspectErrorMissingBlockSignature, description);
//        return nil;
//    }
//    const char *signature = (*(const char **)desc);
//    return [NSMethodSignature signatureWithObjCTypes:signature];
//}

- (void)methodInvocation {
    SEL selector = @selector(viewcontrollerTest:block:);
    NSMethodSignature * signature;// = [NSMethodSignature signatureWithObjCTypes:"v@:"];
    //    if (!signature) {
    //        signature = [NSMethodSignature instanceMethodSignatureForSelector:@selector(viewcontrollerTest:)];
    //    }
    if (!signature) {
        signature = [self methodSignatureForSelector:selector];
        //        SEL selector = NSSelectorFromString(@"viewcontrollerTest:");
        //        signature = [self methodSignatureForSelector:selector];
    }
    if (signature) {
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.selector = selector;
        int count = 3;
        [invocation setArgument:&count atIndex:2];
        
        NSString *(^block)(NSString *) = ^(NSString * string) {
            return string;
        };
        [invocation setArgument:&block atIndex:3];
        
        invocation.target = self;
        [invocation invoke];
        //        [invocation invokeWithTarget:self];
        //        NSString * realReturn = @"real return";
        //        [invocation setReturnValue:&realReturn];
        id result = nil;
        [invocation getReturnValue:&result];
    }
}

- (id)viewcontrollerTest:(int)count block:(NSString *(^)(NSString *))block {
    NSLog(@"viewcontrollerTest : %d", count);
    return @"[retrun value]";
}

@end
