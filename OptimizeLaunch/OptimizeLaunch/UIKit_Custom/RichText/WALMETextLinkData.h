//
//  WALMETextLinkData.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WALMETextLinkData : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSDictionary * request;
@property (nonatomic, assign) NSRange range;

@end

NS_ASSUME_NONNULL_END
