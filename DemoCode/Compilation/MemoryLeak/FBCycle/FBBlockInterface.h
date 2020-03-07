//
//  FBBlockInterface.h
//  Compilation
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 We are mimcing Block structure based on Clang documentation:
 http://clang.llvm.org/docs/Block-ABI-Apple.html
 */

enum {
    BLOCK_IS_NOESCAPE       = (1 << 23),
    
    BLOCK_HAS_COPY_DISPOSE  = (1 << 25),
    BLOCK_HAS_CTOR          = (1 << 26), // helpers have C++ code
    BLOCK_IS_GLOBAL         = (1 << 28),
    BLOCK_HAS_STRET         = (1 << 29), // IFF BLOCK_HAS_SIGNATURE
    BLOCK_HAS_SIGNATURE     = (1 << 30),
};

//switch (flags & (3<<29)) {
//    case (0<<29):      10.6.ABI, no signature field available
//    case (1<<29):      10.6.ABI, no signature field available
//    case (2<<29): ABI.2010.3.16, regular calling convention, presence of signature field
//    case (3<<29): ABI.2010.3.16, stret calling convention, presence of signature field,
//}

struct BlockDescriptor {
    unsigned long int reserved;                 // NULL
    unsigned long int size;                     // sizeof(struct BlockLiteral)
    
    // optional helper functions
    void (*copy_helper)(void *dst, void *src);  // IFF (1<<25)
    void (*dispose_helper)(void* src);          // IFF (1<<25)
    const char *signature;                      // IFF (1<<30)
};

struct BlockLiteral {
    void *isa;          // initialized to &_NSConcreteStackBlock or &_NSConcreteGlobalBlock
    int flags;
    int reserved;
    void (*invoke)(void *, ...);
    struct BlockDescriptor * descriptor;
    // imported variables
};
