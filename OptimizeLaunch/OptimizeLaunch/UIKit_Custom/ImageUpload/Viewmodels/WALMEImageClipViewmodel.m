//
//  WALMEImageClipViewmodel.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEImageClipViewmodel.h"
#import "WALMEAliOSS.h"
#import "WALMEUploadOptions.h"
#import "WALMEViewmodelHeader.h"
#import "UIImage+WALME_Custom.h"

@interface WALMEImageClipViewmodel ()

@property (nonatomic, copy) NSDictionary * aliDic;
@property (nonatomic, strong) WALMEUploadOptions * option;
@property (nonatomic, assign) float quality;

@end

@implementation WALMEImageClipViewmodel

#pragma mark - init

- (instancetype)initWithNSDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        NSDictionary * options = dictionary[@"options"];
//        _option = [WALMEUploadOptions yy_modelWithJSON:options];
        _aliDic = dictionary;
    }
    return self;
}

- (BOOL)faceDetect {
    return _option.faceDetect;
}

- (NSUInteger)maxFace {
    return _option.maxFace;
}

- (NSString *)url {
    return _option.faceDetectParam[@"url"];
}

- (NSDictionary *)faceDetectParam {
    return _option.faceDetectParam;
}

- (float)quality {
    return ((float)(_option.quality) / 100);
}

- (void)walme_detectFace:(UIImage *)image {
//                  result:(WALMENetResultBlock)resultBlock {
    NSMutableDictionary *json = [NSMutableDictionary dictionaryWithCapacity:10];
    
    if (!image) {
//        resultBlock(NO, @"图片不能为空");
        return;
    }
    json[@"image"] = [image imageBase64String];
    NSString * urlString = self.url;
    
    [WALMENetWorkManager walme_sendRequest:json reqData:self.faceDetectParam method:urlString successBlock:^(BOOL isSuccess, id result) {
//        if (resultBlock) {
//            resultBlock(YES, result);
//        }
    } failureBlock:^(NSError *error) {
//        if (resultBlock) {
//            resultBlock(NO, WALMENetWorkErrorNoteString);
//        }
    }];
}

- (void)walme_uploadImage:(UIImage *)image
                clipImage:(UIImage *)clipImage
                      dic:(NSDictionary *)customDic
//                 progress:(WALMENetProgressBlock)progressBlock
                   result:(nonnull void (^)(NSError * _Nonnull, id _Nonnull, BOOL))msgBlock {
    WALMEAliOSS * aliOSS = [[WALMEAliOSS alloc] initWithNSDictionary:_aliDic];
//    [aliOSS uploadImage:image quality:self.quality dic:customDic clipImage:clipImage progress:progressBlock message:msgBlock];
}

@end
