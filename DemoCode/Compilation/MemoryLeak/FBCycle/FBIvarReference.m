//
//  FBIvarReference.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "FBIvarReference.h"

@implementation FBIvarReference

- (instancetype)initWithIvar:(Ivar)ivar {
    if (self = [super init]) {
        _name = @(ivar_getName(ivar));
        _type = [self _convertEncodingToType:ivar_getTypeEncoding(ivar)];
        _offset = ivar_getOffset(ivar);
        _index = _offset / sizeof(void *);
        _ivar = ivar;
    }
    return self;
}

- (FBType)_convertEncodingToType:(const char *)typeEncoding {
    if (typeEncoding[0] == '{') {
        return FBStructType;
    }
    else if (typeEncoding[0] == '@') {
        // It's an object or block. Blocks tend to have
        // @? typeEncoding. Docs state that it's undefined type, so
        // we should still verify that ivar with that type is a block
        if (strncmp(typeEncoding, "@?", 2) == 0) {
            return FBBlockType;
        }
        return FBObjectType;
    }
    return FBUnknowType;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[%@, index: %lu]]", _name, (unsigned long)_index];
}

#pragma mark - FBObjectReference

- (NSUInteger)indexInIvarLayout {
    return _index;
}

- (id)objectReferenceFromObject:(id)object {
    return object_getIvar(object, _ivar);
}

- (NSArray<NSString *> *)namePath {
    return @[@(ivar_getName(_ivar))];
}

@end
