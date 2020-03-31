//
//  WALMEPlayerModel.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WALMEPlayerModel : NSObject

@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * video;
@property (nonatomic, strong) NSString * introduce;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * area;
@property (nonatomic, strong) NSString * job;
@property (nonatomic, strong) NSString * userid;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) BOOL videoAuth;
@property (nonatomic, assign) BOOL canPlay;
@property (nonatomic, assign) BOOL followed;

@property (nonatomic, strong) NSString * blurNote;
@property (nonatomic, strong) NSString * blurBtnTitle;
@property (nonatomic, strong) NSDictionary * blurOperation;

@property (nonatomic, copy) NSDictionary *notPlayAlert;
@property (nonatomic, copy) NSArray *feedList;
@property (nonatomic, assign) BOOL isShowAd;

@end

NS_ASSUME_NONNULL_END
