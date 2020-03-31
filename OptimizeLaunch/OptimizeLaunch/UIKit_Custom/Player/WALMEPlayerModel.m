//
//  WALMEPlayerModel.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEPlayerModel.h"

@implementation WALMEPlayerModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"avatar"          : @[@"head_pic", @"user_info.head_pic"],
             @"videoAuth"       : @"is_video_auth",
             @"career"          : @"job",
             @"blurNote"        : @"notPlayInfo.title",
             @"blurBtnTitle"    : @"notPlayInfo.button.title",
             @"blurOperation"   : @"notPlayInfo.button.noPlayBtnRequest",
             @"canPlay"         : @"can_play",
             
             @"video"           : @"video_info.video",
             @"userid"          : @"user_info.userid",
             @"nickname"        : @"user_info.nickname",
             @"introduce"       : @"user_info.introduce",
             };
}

@end
