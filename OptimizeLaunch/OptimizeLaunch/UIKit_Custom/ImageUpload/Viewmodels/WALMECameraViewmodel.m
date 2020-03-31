//
//  WALMECameraViewmodel.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMECameraViewmodel.h"
#import "WALMECameraModel.h"
#import "WALMEViewmodelHeader.h"
#import "WALMEAliOSS.h"
#import "WALMEUploadOptions.h"
#import "WALMEUploadTips.h"
#import "WALMEVideoCompressHelper.h"

@interface WALMECameraViewmodel ()

@property (nonatomic, strong) WALMEAliOSS * aliOSS;
@property (nonatomic, strong) WALMECameraModel * model;
@property (nonatomic, strong) WALMEUploadOptions * option;
@property (nonatomic, strong) WALMEUploadTips * tips;

@property (nonatomic, copy) NSDictionary * aliDic;

@end

@implementation WALMECameraViewmodel

#pragma mark - init
- (instancetype)initWithNSDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        NSDictionary * camera = dictionary[@"camera"];
//        _model = [WALMECameraModel yy_modelWithJSON:camera];
        
        NSDictionary * options = dictionary[@"options"];
//        _option = [WALMEUploadOptions yy_modelWithJSON:options];
        
        NSDictionary * tips = dictionary[@"tips"];
//        _tips = [WALMEUploadTips yy_modelWithJSON:tips];
        _aliDic = dictionary;
    }
    return self;
}

#pragma mark - net upload
- (void)walme_uploadImage:(UIImage *)image progress:(WALMENetProgressBlock)progressBlock result:(WALMEAliOSSImageResultBlock)resultBlock {
//    [self.aliOSS uploadImage:image quality:self.quality progress:progressBlock result:resultBlock];
}

- (void)walme_uploadVideo:(NSString *)videoPath progress:(WALMENetProgressBlock)progressBlock result:(WALMEAliOSSImageResultBlock)resultBlock {
    [WALMEVideoCompressHelper convertVideo:videoPath videoQuality:self.videoQuality finished:^(BOOL result, NSString *videoPath) {
        UIImage * image;
//        image = [self.aliOSS uploadVideo:videoPath progress:progressBlock result:resultBlock];
    }];
}

#pragma mark - getter

- (NSString *)uploadType {
    return _option.uploadType;
}

- (int)useCamera {
    return _model.useCamera;
}

- (int)useFilter {
    return _model.useFilter;
}

- (NSInteger)maxTime {
    return _option.maxTime;
}

- (NSInteger)minTime {
    return _option.minTime;
}

- (BOOL)useCache {
    return _model.userCache;
}

- (BOOL)isSwitchCamera {
    return _model.isSwitchCamera;
}

- (float)quality {
    return (float)(_option.quality / 100);
}

- (NSString *)videoQuality {
    return _option.videoQuality;
}

- (BOOL)userEdit {
    return _option.userEdit;
}

- (NSString *)takeNote {
    return _tips.takePhoto;
}

- (WALMEAliOSS *)aliOSS {
    if (!_aliOSS) {
        _aliOSS = [[WALMEAliOSS alloc] initWithNSDictionary:_aliDic];
    }
    return _aliOSS;
}
@end
