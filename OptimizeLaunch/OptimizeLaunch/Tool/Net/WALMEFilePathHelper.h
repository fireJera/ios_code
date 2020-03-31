//
//  WALMEFilePathHelper.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>


#define WALMEGetPlistPath(plistName_)   ([[NSBundle mainBundle] pathForResource:plistName_ ofType:@"plist"])

NS_ASSUME_NONNULL_BEGIN

@interface WALMEFilePathHelper : NSObject

/**
 * app目录、路径
 */
#pragma mark - 系统目录
+ (NSString *)documentsPath;
+ (NSString *)libraryPath;
+ (NSString *)cachesPath;
+ (NSString *)tempPath;

#pragma mark - 用户目录 - 所有缓存尽可能用用户目录
+ (NSString *)userDirPath;
//+ (NSString *)rootIAPReceiptPath;
+ (NSString *)iapReceiptPath;

#pragma mark - tool
+ (unsigned long long)fileSizeAtPath:(NSString *)filePath;
+ (unsigned long long)folderSizeAtPath:(NSString*)folderPath;

@end

NS_ASSUME_NONNULL_END
