//
//  WALMEVideoCompressHelper.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PHAsset;

NS_ASSUME_NONNULL_BEGIN

typedef void(^WALMECompressBlock)(BOOL result, NSString * _Nullable videoPath);
typedef void(^WALMEImagesFetchBlock)(NSArray<UIImage *> * _Nullable images);
typedef void(^WALMEImageFetchBlock)(UIImage * _Nullable images);

@interface WALMEVideoCompressHelper : NSObject

+ (void)convertVideo:(NSString *)originPath finished:(WALMECompressBlock)finishedBlock;
+ (void)convertVideo:(NSString *)originPath videoQuality:(nullable NSString *)videoQuality finished:(WALMECompressBlock)finishedBlock;
+ (void)convertAsset:(PHAsset *)phAsset finished:(WALMECompressBlock)finishedBlock;
+ (void)convertAsset:(PHAsset *)phAsset videoQuality:(NSString *)videoQuality finished:(WALMECompressBlock)finishedBlock;

+ (void)fetchImage:(PHAsset *)asset image:(WALMEImageFetchBlock)image;
+ (void)fetchImages:(NSArray<PHAsset *> *)assets images:(WALMEImagesFetchBlock)images;

@end
NS_ASSUME_NONNULL_END
