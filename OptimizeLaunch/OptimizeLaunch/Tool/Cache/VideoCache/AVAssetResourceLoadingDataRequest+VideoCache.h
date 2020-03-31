//
//  AVAssetResourceLoadingDataRequest+VideoCache.h
//  VideoCacheDemo
//
//  Created by dangercheng on 2018/8/9.
//  Copyright © 2018年 DandJ. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAssetResourceLoadingDataRequest (VideoCache)
@property (nonatomic, assign) NSInteger respondedSize;
@end
