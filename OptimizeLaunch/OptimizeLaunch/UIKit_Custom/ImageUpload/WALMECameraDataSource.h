//
//  WALMECameraDataSource.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/5/2.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#ifndef WALMECameraDataSource_h
#define WALMECameraDataSource_h

#import "CodeFrameDefineCode.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^ _Nullable WALMEAliOSSImageResultBlock)(NSError * _Nullable error, id result);
@protocol WALMECameraDataSource <NSObject>

@property (readonly) NSString * uploadType;
@property (readonly) float quality;
@property (readonly) NSString * videoQuality;
@property (readonly) NSInteger minTime;
@property (readonly) NSInteger maxTime;

@property (readonly) int useCamera;
@property (readonly) int useFilter;
@property (readonly) BOOL isSwitchCamera;
@property (readonly) BOOL useCache;
@property (readonly) BOOL userEdit;

@property (readonly) NSString * takeNote;
@property (readonly) NSDictionary * aliDic;

- (void)walme_uploadImage:(UIImage *)image progress:(WALMENetProgressBlock)progressBlock result:(WALMEAliOSSImageResultBlock)resultBlock;

- (void)walme_uploadVideo:(NSString *)videoPath progress:(WALMENetProgressBlock)progressBlock result:(WALMEAliOSSImageResultBlock)resultBlock;

NS_ASSUME_NONNULL_END

@end

#endif /* WALMECameraDataSource_h */
