//
//  WALMEImageClipViewmodel.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface WALMEImageClipViewmodel : NSObject

@property (nonatomic, assign, readonly) BOOL faceDetect;
@property (nonatomic, assign, readonly) NSUInteger maxFace;

- (instancetype)initWithNSDictionary:(NSDictionary *)dictionary;

- (void)walme_detectFace:(UIImage *)image;
//                  result:(WALMENetResultBlock)resultBlock;

- (void)walme_uploadImage:(UIImage *)image
                clipImage:(UIImage *)clipImage
                      dic:(NSDictionary *)customDic
//                 progress:(WALMENetProgressBlock)progressBlock
                   result:(void(^)(NSError * error, id result, BOOL isOrigin))msgBlock;
@end

NS_ASSUME_NONNULL_END
