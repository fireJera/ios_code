//
//  WALMELocationTool.h
//  CodeFrame
//
//  Created by Jeremy on 2019/9/9.
//  Copyright © 2019 InterestChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WALMELocationDelegate <NSObject>

@optional
- (void)locationFinished:(BOOL)isSuccess
            withLocation:(CLLocation *)location
            amapLocation:(CLLocationCoordinate2D)amapCordinate
               withError:(NSError *)error;

@end

@interface WALMELocationTool : NSObject

@property (nonatomic, strong, readonly) CLLocation * latesLocation;                         //最后一次定位位置
@property (nonatomic, copy, readonly) NSDictionary * latestLocationDic;                     //最后一次定位反编译地址
@property (nonatomic, copy, readonly) NSDictionary * placeMarkDic;                          //最后一次定位反编译地址 CLPlacemark转换的
@property (nonatomic, strong, readonly) CLPlacemark * placemark;                            //同上
@property (nonatomic, assign, readonly) CLAuthorizationStatus authorStatus;                 //定位权限状态
@property (nonatomic, assign, readonly, getter = isCanLocation) BOOL canLocation;           //是否有定位权限
@property (nonatomic, assign, readonly, getter = isNotDetermined) BOOL notDetermined;       //是否请求过定位权限
@property (nonatomic, assign, readonly, getter=isEnabled) BOOL enabled;                     //是否开启定位
@property (nonatomic, assign, readonly) BOOL isSysEnabled;                                  //是否开启定位

@property (nonatomic, weak) id<WALMELocationDelegate> delegate;

//修改权限后回到应用是否自动定位 默认开启YES
@property (nonatomic, assign, getter=isAutoLocationWhenAuthModified) BOOL autoLocationWhenAuthModified;

+ (instancetype)sharedTool;

//开始定位
- (void)walme_startLocation;
- (void)walme_gotoLocationAuthorSetting;

@end

NS_ASSUME_NONNULL_END
