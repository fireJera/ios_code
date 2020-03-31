//
//  WALMEFilePathHelper.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEFilePathHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import "WALMEUser.h"

@implementation WALMEFilePathHelper

#pragma mark - system Directory
+ (NSString *)documentsPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)libraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)cachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)tempPath {
    NSString *tmp = [[self libraryPath] stringByAppendingPathComponent:@"/temp"];
    BOOL isTempDir = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:tmp isDirectory:&isTempDir] ||
        !isTempDir)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:tmp
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:NULL];
    }
    
    return tmp;
}

#pragma mark - user Directory
+ (NSString *)userDirPath {
    NSString *userDirPath = [[self documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"user_%@", WALMEINSTANCE_USER.uid]];
    [self creatDirPath:userDirPath];
    return userDirPath;
}

//+ (NSString *)rootIAPReceiptPath {
//    NSString *userDirPath = [[self documentsPath] stringByAppendingPathComponent:@"receipt"];
//    [self creatDirPath:userDirPath];
//    return userDirPath;
//}

+ (NSString *)iapReceiptPath {
    NSString *iapPath = [[self documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"receipt"]];
    [self creatDirPath:iapPath];
    return iapPath;
}

#pragma mark - tool
+ (void)creatDirPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL exit =[fm fileExistsAtPath:path isDirectory:&isDir];
    if (!exit || !isDir) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (unsigned long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    if (isExist){
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
        return fileSize;
    } else {
        NSLog(@"file is not exist");
        return 0;
    }
}

+ (unsigned long long)folderSizeAtPath:(NSString*)folderPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:folderPath];
    if (isExist){
        NSEnumerator *childFileEnumerator = [[fileManager subpathsAtPath:folderPath] objectEnumerator];
        unsigned long long folderSize = 0;
        NSString *fileName = @"";
        while ((fileName = [childFileEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
        return folderSize / (1024.0 * 1024.0);
    } else {
        //        NSLog(@"file is not exist");
        return 0;
    }
}


@end
