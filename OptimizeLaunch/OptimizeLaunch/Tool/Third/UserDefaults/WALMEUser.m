//
//  WALMEUser.m
//  LetDate
//
//  Created by Jeremy on 2019/1/19.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

#import "WALMEUser.h"
//#import "WALMEApiCache.h

@implementation WALMEUser

@dynamic uid;
@dynamic token;
@dynamic nickname;
@dynamic avatar;
@dynamic wechatRefreshToken;
@dynamic showMatchNote;
@dynamic lastIAPOrderId;
//@dynamic fillInfoStep;

@dynamic marriageId;
@dynamic houseId;
@dynamic childId;
@dynamic provinceId;
@dynamic cityId;
@dynamic jobId;
@dynamic educationId;
@dynamic incomeId;
@dynamic travelIds;
@dynamic loveId;
@dynamic birthday;
@dynamic height;
@dynamic weight;
@dynamic heightRange;
@dynamic ageRange;
@dynamic figureId;
@dynamic bodyId;
@dynamic aimIncomeId;
@dynamic aimEducationId;
@dynamic declaration;

@dynamic matchTime;
@dynamic matchTimesLeft;
@dynamic matchPageIndex;

static WALMEUser *_user = nil;
static WALMEUser * _standardUser = nil;

#pragma mark - singleton
+ (instancetype )currentUser {
    @synchronized (self) {
        if (_user == nil) {
            NSAssert([self standardUser] != nil, @"current use == nil can't use");
            _user = [[WALMEUser alloc] init];
        }
    }
    return _user;
}

+ (instancetype)standardUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _standardUser = [[WALMEUser alloc] init];
    });
    return _standardUser;
}

#pragma mark - override
- (NSDictionary *)setupDefaults{
    return  @{
              @"uid"                : @"",
              @"token"              : @"",
              @"shouldShowReward"   : @(YES),
//              @"fillInfoStep"   : @0,
              };
}

- (NSString *)suitName {
    if (_standardUser) {
//        return [NSString stringWithFormat:@"%@_%@_%@", _standardUser.uid, NSStringFromClass([self class]), WALMEDATAIDE];
        return @"123124";
    } else {
        return @"123124";
//        return [NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), WALMEDATAIDE];
    }
}

- (void)walme_signOut {
    self.uid = nil;
    self.token = nil;
//    self.wechatRefreshToken = nil;
//    [WALMEApiCache defaultCache].UserHomeInfoJson = nil;
    _user = nil;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"uid"                 : @"userInfo.userid",
             @"sex"                 : @"userInfo.sex",
             @"avatar"              : @"userInfo.head_pic",
             @"is_showAd"           : @"incentiveVideo.is_show",
             @"last_num"            : @"incentiveVideo.last_num",
             @"list"                : @"incentiveVideo.list",
             };
}

- (void)setShowPage:(NSString *)showPage {
    _showPage = showPage;
    if (!showPage || !showPage.length) {
        return;
    }
    _indexForTab = 1;
    _indexVCForFirstTab = 0;
    if ([showPage isEqualToString:@"discovery"]) {
        _indexForTab = 0;
    }else if ([showPage isEqualToString:@"video"]) {
        _indexForTab = 1;
    }else if ([showPage isEqualToString:@"attentation"]) {
        _indexForTab = 0;
        _indexVCForFirstTab = 2;
    }else if ([showPage isEqualToString:@"match_player"]) {
        _indexForTab = 0;
        _indexVCForFirstTab = 1;
    }
}

@end
