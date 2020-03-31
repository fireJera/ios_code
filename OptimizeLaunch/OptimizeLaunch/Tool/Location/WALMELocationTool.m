//
//  WALMELocationTool.m
//  CodeFrame
//
//  Created by Jeremy on 2019/9/9.
//  Copyright © 2019 InterestChat. All rights reserved.
//

#import "WALMELocationTool.h"
#import <UIKit/UIKit.h>
static NSString * const kNoLocationAuthStr = @"请到设置-应用-约爱情-权限中开启定位权限";

@interface WALMELocationTool () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, assign, readwrite) CLAuthorizationStatus authorStatus;
@property (nonatomic, assign, readwrite) BOOL locationFinished;

@end

@implementation WALMELocationTool

+ (instancetype)sharedTool {
    static WALMELocationTool * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        [instance walme_checkLocationStatus];
    });
    return instance;
}

//+ (instancetype)allocWithZone:(struct _NSZone *)zone {
//    return [self sharedTool];
//}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    return self;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager stopUpdatingLocation];
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.activityType = CLActivityTypeOtherNavigation;
        _locationManager.pausesLocationUpdatesAutomatically = YES;
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
    }
    return _locationManager;
}

- (void)walme_startLocation {
    [self.locationManager stopUpdatingLocation];
    [_locationManager startUpdatingLocation];
}

- (void)walme_gotoLocationAuthorSetting {
    BOOL enabled = [CLLocationManager locationServicesEnabled];
    if (enabled) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

//MARK: - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // 保存 Device 的现语言 (英语 法语 ，，，)
    NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                                            objectForKey:@"AppleLanguages"];
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil]
                                              forKey:@"AppleLanguages"];
    _latesLocation = locations.lastObject;
    [self p_walme_geocodeLocation:_latesLocation language:userDefaultLanguages];
    [_locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"didFailWithError-------%@", error);
    if (self.delegate && [self.delegate respondsToSelector:@selector(locationFinished:withLocation:amapLocation:withError:)]) {
        [self.delegate locationFinished:NO withLocation:nil amapLocation:kCLLocationCoordinate2DInvalid withError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self walme_checkLocationStatus];
}

-(void)p_walme_geocodeLocation:(CLLocation *)location language:(NSMutableArray *)userDefaultLanguages{
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
//    CLLocationCoordinate2D amapcoord = AMapCoordinateConvert(location.coordinate, AMapCoordinateTypeGPS);
    CLLocationCoordinate2D marsCoord = [[self class] p_worldGS2MarsGS:location.coordinate];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            //这里是异步，所以可能会比较慢
            //name: 三鲁公路99号 subThoroughfare:99号 thoroughfare： 三鲁公路 subLocality:闵行 locality:上海
            NSString * country = placemarks.firstObject.country;
            NSString * province = placemarks.firstObject.administrativeArea;
            NSString * city = placemarks.firstObject.locality;                      //城市
            NSString * district = placemarks.firstObject.subLocality;
            NSString * countryCode = placemarks.firstObject.ISOcountryCode;
            
            NSMutableDictionary * locationDic = [NSMutableDictionary new];
            
            if (country) {
                [locationDic setValue:country forKey:@"country"];
            }
            if (countryCode) {
                [locationDic setValue:countryCode forKey:@"countryCode"];
            }
            if (province) {
                [locationDic setValue:province forKey:@"province"];
            } else {
                if (city) {
                    city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
                    [locationDic setValue:city forKey:@"province"];
                }
            }
            if (city) {
                city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
                [locationDic setValue:city forKey:@"city"];
            }
            if (district) {
                BOOL hasSuffix = NO;
                NSArray * array = @[@"新区", @"经济开发区", @"经开区"];
                for (NSString * str in array) {
                    if ([district hasSuffix:str]) {
                        hasSuffix = YES;
                        break;
                    }
                }
                if (!hasSuffix) {
                    district = [district stringByReplacingOccurrencesOfString:@"区" withString:@""];
                    district = [district stringByReplacingOccurrencesOfString:@"县" withString:@""];
                }
                [locationDic setValue:district forKey:@"district"];
            }
            _latestLocationDic = locationDic;
//            _placeMarkDic = [placemarks.firstObject keyValuesWithObject];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(locationFinished:withLocation:amapLocation:withError:)]) {
                [self.delegate locationFinished:YES withLocation:_latesLocation amapLocation:marsCoord withError:nil];
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(locationFinished:withLocation:amapLocation:withError:)]) {
                [self.delegate locationFinished:YES withLocation:_latesLocation amapLocation:marsCoord withError:error];
            }
        }
        // 还原Device 的语言
        [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
    }];
}

//- (void)applicationWillResignActive:(NSNotification *)notification {
//    
//}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [self walme_checkLocationStatus];
    if (_autoLocationWhenAuthModified && !(_canLocation && _enabled)) {
        //FIXME: - 可以考虑再加一层过滤enabled & canLocation
        [self walme_startLocation];
    }
}

- (void)walme_checkLocationStatus {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    _authorStatus = status;
    if ([CLLocationManager locationServicesEnabled]) {
        _enabled = YES;
        switch (status) {
            case kCLAuthorizationStatusDenied:
                _canLocation = NO;
                _notDetermined = NO;
                break;
            case kCLAuthorizationStatusRestricted:
                _canLocation = NO;
                _notDetermined = NO;
                break;
            case kCLAuthorizationStatusNotDetermined:
                _notDetermined = YES;
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            case kCLAuthorizationStatusAuthorizedAlways:
                _canLocation = YES;
                _notDetermined = NO;
                break;
            default:
                break;
        }
    }
}

- (BOOL)isSysEnabled {
    return [CLLocationManager locationServicesEnabled];
}


// 地球坐标系 ==> 火星坐标系（经度：0.01米）
+ (CLLocationCoordinate2D)p_worldGS2MarsGS:(CLLocationCoordinate2D)coordinate {
    if ([self isLocationOutOfChina:coordinate])
    {
        return coordinate;
    }
    
    double wgLat = coordinate.latitude;
    double wgLon = coordinate.longitude;
    double dLat = [self transformLatWithX:wgLon - 105.0 withY:wgLat - 35.0];
    double dLon = [self transformLonWithX:wgLon - 105.0 withY:wgLat - 35.0];
    double radLat = wgLat / 180.0 * M_PI;
    double magic = sin(radLat);
    
    const double a = 6378245.0;
    const double ee = 0.00669342162296594323;
    const double x_pi = M_PI * 3000.0 / 180.0;
    
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    
    return CLLocationCoordinate2DMake(wgLat + dLat, wgLon + dLon);
}

+ (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location {
    if (location.longitude < 72.004 ||
        location.longitude > 137.8347 ||
        location.latitude < 0.8293 ||
        location.latitude > 55.8271) {
        
        return YES;
    }
    
    return NO;
}

+ (double)transformLatWithX:(double)x withY:(double)y {
    double lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
    lat += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    lat += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return lat;
}

+ (double)transformLonWithX:(double)x withY:(double)y {
    double lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
    lon += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    lon += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    lon += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return lon;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
