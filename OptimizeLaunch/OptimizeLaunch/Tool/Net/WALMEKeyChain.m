//
//  WALMEKeyChain.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEKeyChain.h"
#import <Security/Security.h>
#import <AdSupport/AdSupport.h>
#import <UIKit/UIKit.h>

NSString * const WALMEUUIDKey = @"WALMEUUIDKey";
NSString * const WALMEIDFAKey = @"WALMEIDFAKey";

@implementation WALMEKeyChain

+ (NSString *)idfaStr {
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *previousIDFA = [self load:WALMEIDFAKey];
    if ([idfa isEqualToString:previousIDFA]) {
        return idfa;
    }
    if (idfa.length && ![idfa containsString:@"0000000"]) {
        [self saveIDFA];
        idfa = [self load:WALMEIDFAKey];
        return idfa;
    }
    NSString * idfaStr = [self load:WALMEIDFAKey];
    return idfaStr ? idfaStr : idfa;
}

+ (void)saveIDFA {
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [self saveValue:idfa ForKey:WALMEIDFAKey];
}

+ (NSString *)UUId {
    NSString * uuidStr = [self load:WALMEUUIDKey];
    if (!uuidStr) {
        [self saveUUid];
        uuidStr = [self load:WALMEUUIDKey];
    }
    return uuidStr;
}

+ (void)saveUUid {
    NSString * uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [self saveValue:uuid ForKey:WALMEUUIDKey];
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service{
    NSMutableDictionary *keyChainQueryDictaionary = [[NSMutableDictionary alloc]init];
    [keyChainQueryDictaionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [keyChainQueryDictaionary setObject:service forKey:(id)kSecAttrService];
    [keyChainQueryDictaionary setObject:service forKey:(id)kSecAttrAccount];
    return keyChainQueryDictaionary;
}

+ (BOOL)saveValue:(id)value ForKey:(NSString *)key {
    NSMutableDictionary * keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:(__bridge id)kSecValueData];
    OSStatus status= SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    if (status == noErr) {
        return YES;
    }
    return NO;
}

+ (BOOL)updateData:(id)data forService:(NSString *)key{
    NSMutableDictionary *searchDictionary = [self getKeychainQuery:key];
    
    if (!searchDictionary) {
        return NO;
    }
    
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    [updateDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    OSStatus status = SecItemUpdate((CFDictionaryRef)searchDictionary,
                                    (CFDictionaryRef)updateDictionary);
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

+ (id)load:(NSString *)key {
    id ret = nil;
    NSMutableDictionary * keychainQuery = [self getKeychainQuery:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException * exception) {
        } @finally {
        }
    }
    if (keyData) {
        CFRelease(keyData);
    }
    return ret;
}

+ (BOOL)remove:(NSString *)key {
    NSMutableDictionary * keychainQuery = [self getKeychainQuery:key];
    OSStatus status = SecItemDelete((CFDictionaryRef)keychainQuery);
    if (status == noErr) {
        return YES;
    }
    return NO;
}

@end
