//
//  WALMEUploadOptions.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WALMEUploadOptions : NSObject

@property (nonatomic, copy) NSString * uploadType;          // 上传类型 photo/video/all
@property (nonatomic, copy) NSString * videoQuality;        // 视频质量 low/middle/high
@property (nonatomic, assign) int quality;                  // 图片质量
@property (nonatomic, assign) NSInteger minTime;            // 最短时间
@property (nonatomic, assign) NSInteger maxTime;            // 最长时间
@property (nonatomic, assign) BOOL userEdit;                // 裁剪

@property (nonatomic, assign) BOOL faceDetect;              // 是否检测人脸
@property (nonatomic, assign) NSUInteger maxFace;           // 最多几张人脸
@property (nonatomic, copy) NSDictionary * faceDetectParam;

@end

NS_ASSUME_NONNULL_END
