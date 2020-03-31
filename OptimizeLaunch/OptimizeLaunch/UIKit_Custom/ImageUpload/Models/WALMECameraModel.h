//
//  WALMECameraModel.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WALMECameraModel : NSObject

@property (nonatomic, assign) int useCamera;                //1前置2后置
@property (nonatomic, assign) BOOL isSwitchCamera;          //是否可以切换摄像头
@property (nonatomic, assign) int useFilter;                //是否启动滤镜
@property (nonatomic, assign) BOOL userCache;               //是否可以使用拍摄缓存

@end

NS_ASSUME_NONNULL_END
