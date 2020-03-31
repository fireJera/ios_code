//
//  WALMEVideoCompressHelper.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEVideoCompressHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation WALMEVideoCompressHelper

+ (void)convertVideo:(NSString *)originPath finished:(WALMECompressBlock)finishedBlock {
    [WALMEVideoCompressHelper convertVideo:originPath videoQuality:nil finished:finishedBlock];
}

+ (void)convertVideo:(NSString *)originPath videoQuality:(NSString *)videoQuality finished:(WALMECompressBlock)finishedBlock {
    NSString * quality = AVAssetExportPresetMediumQuality;
    if ([videoQuality isEqualToString:@"low"]) {
        quality = AVAssetExportPresetLowQuality;
    } else if ([videoQuality isEqualToString:@"middle"]) {
        quality = AVAssetExportPresetMediumQuality;
    } else if ([videoQuality isEqualToString:@"high"]) {
        quality = AVAssetExportPresetHighestQuality;
    }
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:originPath] options:nil];
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:quality];
    exportSession.shouldOptimizeForNetworkUse = YES;
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString * name = [NSString stringWithFormat:@"%f.mov", time];
    NSString * tempPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:name];
    
    exportSession.outputURL = [NSURL fileURLWithPath:tempPath];
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exportSession.status;
        switch (exportStatus)
        {
            case AVAssetExportSessionStatusFailed:
            {
                finishedBlock(NO, originPath);
                break;
            }
            case AVAssetExportSessionStatusCompleted:
            {
                finishedBlock(YES, tempPath);
            }
                [[NSFileManager defaultManager] removeItemAtPath:originPath error:nil];
        }
    }];
}

+ (void)convertAsset:(PHAsset *)phAsset finished:(WALMECompressBlock)finishedBlock {
    [WALMEVideoCompressHelper convertAsset:phAsset videoQuality:AVAssetExportPresetMediumQuality finished:finishedBlock];
}

+ (void)convertAsset:(PHAsset *)phAsset videoQuality:(NSString *)videoQuality finished:(WALMECompressBlock)finishedBlock {
    if (phAsset.mediaType == PHAssetMediaTypeVideo) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString * name = [NSString stringWithFormat:@"%f.mov", time];
        NSString * tempPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:name];
        
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            if (asset) {
                if ([asset isKindOfClass:[AVComposition class]]) {
                    if (finishedBlock) {
                        finishedBlock(NO, nil);
                    }
                    return ;
                }
                NSURL *fileRUL = [asset valueForKey:@"URL"];
                AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:fileRUL options:nil];
                
                NSURL *url = urlAsset.URL;
                NSData *data = [NSData dataWithContentsOfURL:url];
                
                BOOL isSuccess = [data writeToFile:tempPath atomically:YES];
                if (isSuccess) {
                    [WALMEVideoCompressHelper convertVideo:tempPath videoQuality:videoQuality finished:finishedBlock];
                } else {
                    if (finishedBlock) {
                        finishedBlock(NO, nil);
                    }
                }
            }
            else {
                if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                    __block BOOL ero = NO;
                    PHImageRequestID cloudRequestId = 0;
                    PHVideoRequestOptions *cloudOptions = [[PHVideoRequestOptions alloc] init];
                    cloudOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeMediumQualityFormat;
                    cloudOptions.networkAccessAllowed = YES;
                    cloudOptions.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                        if (error) {
                            [[PHImageManager defaultManager] cancelImageRequest:cloudRequestId];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (!ero) {
                                    ero = YES;
                                    if (finishedBlock) {
                                        finishedBlock(NO, nil);
                                    }
                                }
                            });
                        }
                    };
                    
                    [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:cloudOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                        if (asset) {
                            NSURL *fileRUL = [asset valueForKey:@"URL"];
                            AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:fileRUL options:nil];
                            
                            NSURL *url = urlAsset.URL;
                            NSData *data = [NSData dataWithContentsOfURL:url];
                            
                            BOOL isSuccess = [data writeToFile:tempPath atomically:YES];
                            if (isSuccess) {
                                [WALMEVideoCompressHelper convertVideo:tempPath videoQuality:videoQuality finished:finishedBlock];
                            } else {
                                if (finishedBlock) {
                                    finishedBlock(YES, tempPath);
                                }
                            }
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (!ero) {
                                    ero = YES;
                                    if (finishedBlock) {
                                        finishedBlock(NO, nil);
                                    }
                                }
                            });
                        }
                    }];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (finishedBlock) {
                            finishedBlock(NO, nil);
                        }
                    });
                }
            }
        }];
    }
}

+ (void)fetchImage:(PHAsset *)asset image:(WALMEImageFetchBlock)image {
    if (asset) {
        [WALMEVideoCompressHelper fetchImages:@[asset] images:^(NSArray<UIImage *> *images) {
            if (images.count > 0) {
                if (image) {
                    image(images.firstObject);
                }
            }
        }];
    }
}

+ (void)fetchImages:(NSArray<PHAsset *> *)assets images:(WALMEImagesFetchBlock)images {
    __block NSMutableArray<UIImage *> * array = [NSMutableArray arrayWithCapacity:assets.count];
    
    __block int count = 0;
    __block BOOL isPhotoInICloud = NO;
    
    [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.sourceType == PHAssetSourceTypeCloudShared) {
            isPhotoInICloud = YES;
            *stop = YES;
        }
    }];
    
    //    hud = [self customProgressHUDTitle:@"你选择的照片不在本地，正在从icloud获取照片"];
    [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.networkAccessAllowed = YES;
        options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
            isPhotoInICloud = YES;
        };
        [array addObject:[UIImage new]];
        // 是否要原图
        //        CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        [[PHImageManager defaultManager] requestImageForAsset:obj targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            //            NSLog(@"%@", result);
            BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            
            if (downloadFinined) {
                count++;
                if (result) {
                    [array replaceObjectAtIndex:idx withObject:result];
                }
            }
            if (count == assets.count) {
                if (images) {
                    images(array);
                }
            }
        }];
    }];
}


@end
