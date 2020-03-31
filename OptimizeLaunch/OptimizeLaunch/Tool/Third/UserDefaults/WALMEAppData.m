//
//  WALMEAppData.m
//  CodeFrame
//
//  Created by Jeremy on 2019/3/26.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

#import "WALMEAppData.h"

@implementation WALMEAppData

#pragma mark - singleton

+ (instancetype)sharedAppData {
    static WALMEAppData * _appData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appData = [[WALMEAppData alloc] init];
    });
    return _appData;
}

#pragma mark - override

- (NSDictionary *)setupDefaults{
    return  @{
              @"sourceVersion"    : @0,
              @"firstLaunch"        : @0,
              };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
//             @"startImage"          : @"start_image",
             @"showLogin"           : @"show_login",
             @"checkWechatInstall"  : @"check_has_wx_app",
             @"preRelease"          : @"additional",
             };
}



@end
