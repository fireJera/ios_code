//
//  WALMECacheManager.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMECacheManager.h"
#import "WALMEFilePathHelper.h"
#import "VideoCache.h"

//#if __has_include (<SDImageCache.h>)
//#import <SDImageCache.h>
//#else
//#import "SDImageCache.h"
//#endif

static WALMECacheManager * instance = nil;
static NSString * const kInfoConfig = @"infoConfig";

@implementation WALMECacheManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WALMECacheManager alloc] init];
    });
    return instance;
}

//+ (instancetype)allocWithZone:(struct _NSZone *)zone {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [super allocWithZone:zone];
//    });
//    return instance;
//}

+ (BOOL)saveInfoConfigCache:(id)data {
    NSString * path = [WALMEFilePathHelper cachesPath];
    NSString * jsonPath = [path stringByAppendingPathComponent:kInfoConfig];
    BOOL createDirectory = [[NSFileManager defaultManager] createDirectoryAtPath:jsonPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (!createDirectory) {
        return NO;
    }
    
    jsonPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", kInfoConfig]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    BOOL isSuccess = [jsonData writeToFile:jsonPath atomically:YES];
    NSLog(@"infoconfig wirte %d", isSuccess);
    return isSuccess;
}

+ (id)getInfoConfigCache {
    NSString * path = [WALMEFilePathHelper cachesPath];
    NSString * jsonPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", kInfoConfig]];
    NSData * data = [NSData dataWithContentsOfFile:jsonPath];
    NSError * error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:jsonPath]) {
        return [self p_walme_getInfoConfigCacheFromLocal];
    }
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (!error) {
        return jsonObject;
    } else {
        return [self p_walme_getInfoConfigCacheFromLocal];
    }
}

+ (id)p_walme_getInfoConfigCacheFromLocal {
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"infoConfigure" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    if (!data) {
        return nil;
    }
    NSError * error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    return jsonObject;
}

- (unsigned long long)calculateSize {
    _cacheSize = 0;
    _cacheSize = [self calculatePictureSize] + [self calculateUserHomeSize];
    return _cacheSize;
}

- (unsigned long long)calculatePictureSize {
//    return [[SDImageCache sharedImageCache] getSize];
    return 0;
}

- (unsigned long long)calculateUserHomeSize {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * path = [WALMEFilePathHelper cachesPath];
    
    unsigned long long cacheSize = 0;
    NSString *directoryPath = [path stringByAppendingPathComponent:@"user"];
    NSDirectoryEnumerator<NSString *> * myDirectoryEnumerator;
    myDirectoryEnumerator = [fileManager enumeratorAtPath:directoryPath];
    NSString * strPath;
    while (strPath = [myDirectoryEnumerator nextObject]) {
        for (NSString * namePath in strPath.pathComponents) {
            NSString * filePath = [directoryPath stringByAppendingPathComponent:namePath];
            //            NSData * data = [NSData dataWithContentsOfFile:filePath];
            //            NSLog(@"%d", (int)(data.length));
            cacheSize += [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
        }
    }
    return cacheSize;
}

- (void)clearCache:(void (^)(void))handler {
    [self clearMessageKitCache];
    [self clearUserHomeCache];
    [self clearPictureCache:handler];
    [[VideoCache shareCache] cleanCache];
}

- (void)clearPictureCache:(void (^)(void))handler {
//    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
//        handler();
//    }];
}

- (void)clearUserHomeCache {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * path = [WALMEFilePathHelper cachesPath];
    
    NSString *directoryPath = [path stringByAppendingPathComponent:@"user"];
    NSDirectoryEnumerator<NSString *> * myDirectoryEnumerator;
    myDirectoryEnumerator = [fileManager enumeratorAtPath:directoryPath];
    NSString * strPath;
    while (strPath = [myDirectoryEnumerator nextObject]) {
        for (NSString * namePath in strPath.pathComponents) {
            NSString * filePath = [directoryPath stringByAppendingPathComponent:namePath];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
}

- (void)clearMessageKitCache {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * path = [WALMEFilePathHelper cachesPath];
    
    NSString *directoryPath = [path stringByAppendingPathComponent:@"MessageKit"];
    NSDirectoryEnumerator<NSString *> * myDirectoryEnumerator;
    myDirectoryEnumerator = [fileManager enumeratorAtPath:directoryPath];
    NSString * strPath;
    while (strPath = [myDirectoryEnumerator nextObject]) {
        for (NSString * namePath in strPath.pathComponents) {
            NSString * filePath = [directoryPath stringByAppendingPathComponent:namePath];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
}

@end

