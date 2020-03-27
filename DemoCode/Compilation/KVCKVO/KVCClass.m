//
//  KVCClass.m
//  KVCKVO
//
//  Created by Jeremy on 2020/3/23.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "KVCClass.h"

@interface KVCClass () {
//    NSString * _kvcName;
//    NSString * _isKvcName;
//    NSString * KvcName;
    NSString * isKvcName;
}

//@property (nonatomic, copy) NSString * kvcName;

@end


@implementation KVCClass

//@synthesize kvcName = _kvcName;

//- (void)setKvcName:(NSString *)kvcName {
//    NSLog(@"setKvcName %@", kvcName);
//    _kvcName = kvcName;
//}

//- (void)_setKvcName:(NSString *)kvcName {
//    NSLog(@"_setKvcName %@", kvcName);
////    _kvcName = kvcName;
//}

//- (NSString *)kvcName {
//    NSLog(@"getKvcName %@", _kvcName);
//    return _kvcName;
//}
//
//- (void)setValue:(id)value forKey:(NSString *)key {
//
//}
//
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//
//}
//
//- (id)valueForKey:(NSString *)key {
//    if ([key isEqualToString:@"kvcName"]) {
//        return _kvcName;
//    }
//}

//+ (BOOL)accessInstanceVariablesDirectly {
//    return NO;
//}

//- (BOOL)validateValue:(inout id  _Nullable __autoreleasing *)ioValue forKey:(NSString *)inKey error:(out NSError *__autoreleasing  _Nullable *)outError {
//    if ([inKey isEqualToString:@"kvcName"]) {
//        if ([*ioValue isKindOfClass:[NSString class]]) {
//            return YES;
//        }
//        *outError = [NSError errorWithDomain:@"kvcerror" code:1 userInfo:@{NSLocalizedDescriptionKey : @"error class"}];;
//        return NO;
//    }
//    return YES;
//}

@end
