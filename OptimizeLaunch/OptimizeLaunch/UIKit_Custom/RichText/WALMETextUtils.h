//
//  WALMETextUtils.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class WALMETextLinkData;
@class WALMECoreTextData;

NS_ASSUME_NONNULL_BEGIN

@interface WALMETextUtils : NSObject

+ (WALMETextLinkData *)walme_touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(WALMECoreTextData *)data;

@end

NS_ASSUME_NONNULL_END
