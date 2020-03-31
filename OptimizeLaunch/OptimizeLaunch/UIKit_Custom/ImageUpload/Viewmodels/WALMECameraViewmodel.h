//
//  WALMECameraViewmodel.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALMECameraDataSource.h"

//@class WALMECameraModel;
//@class WALMEUploadOptions;
//@class WALMEUploadTips;

NS_ASSUME_NONNULL_BEGIN

@interface WALMECameraViewmodel : NSObject <WALMECameraDataSource>

- (instancetype)initWithNSDictionary:(NSDictionary *)dictionary;

@end
NS_ASSUME_NONNULL_END
