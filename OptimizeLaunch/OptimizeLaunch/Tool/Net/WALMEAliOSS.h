//
//  WALMEAliOSS.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^ _Nullable WALMEAliOSSImageResultBlock)(NSError * _Nullable error, id _Nullable result);
typedef void(^ _Nullable WALMEMessageOSSResultBlock)(NSError * _Nullable error, long messageUId, id _Nullable result);
//typedef void(^ _Nullable WALMEAliOSSMultiImageResultBlock)(NSArray * uploadedArray, NSArray * failedArray);

@interface WALMEAliOSS : NSObject

@property (nonatomic, copy, readonly) NSString * chatPath;

- (instancetype)initWithNSDictionary:(NSDictionary *)dictionary;

//从服务器获取权限
- (void)stsRequest:(WALMEAliOSSImageResultBlock)resultBlock;

//上传单张图片
- (void)uploadImage:(UIImage *)image
            quality:(float)quality
//           progress:(WALMENetProgressBlock)progressBlock
             result:(WALMEAliOSSImageResultBlock)resultBlock;

/**
 上传相册单张图片 因为要异步获取图片
 
 @param image image
 @param index order
 @param tailIndex index of frame image from video
 @param quality compress quality
 @param isCover video cover?
 @param time send time interval
 @param progressBlock 进度回调
 @param resultBlock 结果回调
 */
- (void)uploadAssetImage:(UIImage *)image
                   index:(int)index
               tailIndex:(int)tailIndex
                 quality:(float)quality
                 isCover:(BOOL)isCover
                    time:(NSTimeInterval)time
//                progress:(_Nullable WALMENetProgressBlock)progressBlock
                  result:(_Nullable WALMEAliOSSImageResultBlock)resultBlock;
//包含封面和gif
- (UIImage *)uploadVideo:(NSString *)videoPath
//                progress:(_Nullable WALMENetProgressBlock)progressBlock
                  result:(WALMEAliOSSImageResultBlock)resultBlock;

//包含封面和gif和customDic
- (UIImage *)uploadVideo:(NSString *)videoPath
                     dic:(nullable NSDictionary *)customDic
//                progress:(_Nullable WALMENetProgressBlock)progressBlock
                  result:(WALMEAliOSSImageResultBlock)resultBlock;

//只有视频
- (void)uploadVideoOnly:(NSString *)videoPath
                    dic:(nullable NSDictionary *)customDic
//               progress:(_Nullable WALMENetProgressBlock)progressBlock
                 result:(WALMEAliOSSImageResultBlock)resultBlock;

/*
 前三个都需要再进行一次sts request
 这个方法需确认已经进行过sts request了
 */
- (void)uploadVideoWithoutSts:(NSString *)videoPath
                   coverImage:(UIImage * _Nullable * _Nullable)image
                          dic:(nullable NSDictionary *)customDic
//                     progress:(_Nullable WALMENetProgressBlock)progressBlock
                       result:(WALMEAliOSSImageResultBlock)resultBlock;

/**
 裁剪
 
 @param image 原图
 @param quality 质量
 @param clipImage 裁剪图
 @param progressBlock 进度回调
 @param msgBlock 结果回调
 */
- (void)uploadImage:(UIImage *)image
            quality:(float)quality
                dic:(NSDictionary *)customDic
          clipImage:(UIImage *)clipImage
//           progress:(WALMENetProgressBlock)progressBlock
            message:(void(^)(NSError * error, id _Nullable result, BOOL isOrigin))msgBlock;

@end

typedef void(^WALMEUploadMessageSuccessBlock)(id _Nullable result);

typedef void(^WALMEUploadMessageFaileBlock)(id _Nullable result, NSError * error);


@interface WALMEAliOSS (Message)

//上传图片
- (void)uploadMessageImage:(UIImage *)image
                parameters:(NSDictionary *)parameters
//                  progress:(WALMENetProgressBlock)progressBlock
                    result:(WALMEMessageOSSResultBlock)resultBlock;

- (void)uploadMessageWav:(NSData *)data
                duration:(float)duration
              parameters:(NSDictionary *)parameters
//                progress:(WALMENetProgressBlock)progressBlock
                  result:(WALMEMessageOSSResultBlock)resultBlock;

/**
 上传相册单张图片 因为要异步获取图片
 
 @param image image
 @param time send time interval
 @param progressBlock 进度回调
 @param resultBlock 结果回调
 */

- (void)uploadMessageVideoCover:(UIImage *)image
                           time:(NSTimeInterval)time
                     parameters:(NSDictionary *)parameters
//                       progress:(_Nullable WALMENetProgressBlock)progressBlock
                         result:(WALMEAliOSSImageResultBlock)resultBlock;

//包含封面
- (void)uploadMessageVideo:(NSString *)videoPath
                 videoSize:(CGSize)videoSize
                parameters:(NSDictionary *)parameters
//                  progress:(WALMENetProgressBlock)progressBlock
                    result:(WALMEMessageOSSResultBlock)resultBlock;

@end


NS_ASSUME_NONNULL_END
