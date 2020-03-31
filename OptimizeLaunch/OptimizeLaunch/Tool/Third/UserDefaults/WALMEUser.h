//
//  WALMEUser.h
//  LetDate
//
//  Created by Jeremy on 2019/1/19.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

#import "WALMEUserDefaults.h"

//NS_ASSUME_NONNULL_BEGIN
#define WALMEINSTANCE_USER                     ([WALMEUser standardUser])
#define WALMEINSTANCE_CURRENTUSER              ([WALMEUser currentUser])      // 确保当前用户不为空的时候调用

typedef NS_ENUM(NSUInteger, WALMEInviteShareType) {
    WALMEInviteShareType_male = 1,
    WALMEInviteShareType_female,
    WALMEInviteShareType_other
};


@interface WALMEUser : WALMEUserDefaults

+ (instancetype)standardUser;           // 所有用户公用数据
+ (instancetype)currentUser;            // 用户独享数据

#pragma mark - standardUser
/* 个人基本资料  */
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * token;
@property (nonatomic, assign) int sex;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, copy) NSString * wechatRefreshToken;
//@property (nonatomic, assign) BOOL dailySign;
@property (nonatomic, copy) NSString * lastIAPOrderId;

#pragma mark - currentUser

//@property (nonatomic, assign) int fillInfoStep;

@property (nonatomic, assign) NSInteger marriageId;
@property (nonatomic, assign) NSInteger houseId;
@property (nonatomic, assign) NSInteger childId;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, assign) NSInteger jobId;
@property (nonatomic, assign) NSInteger educationId;
@property (nonatomic, assign) NSInteger incomeId;
@property (nonatomic, copy) NSString * travelIds;
@property (nonatomic, assign) NSInteger loveId;
@property (nonatomic, copy) NSString * birthday;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, copy) NSString * heightRange;
@property (nonatomic, copy) NSString * ageRange;
@property (nonatomic, assign) NSInteger figureId;
@property (nonatomic, assign) NSInteger bodyId;
@property (nonatomic, assign) NSInteger aimIncomeId;
@property (nonatomic, assign) NSInteger aimEducationId;
@property (nonatomic, copy) NSString * declaration;

// 0 unset 1 off 2 on 
@property (nonatomic, assign) int showMatchNote;

- (void)walme_signOut;

@property (nonatomic, assign) BOOL additional;
//广告

@property (nonatomic, assign) BOOL shouldShowReward;
@property (nonatomic, copy) NSString * showPage;
@property (nonatomic, assign) NSInteger indexForTab;
@property (nonatomic, assign) NSInteger indexVCForFirstTab;

@property (nonatomic, copy) NSString *toUserId;
@property (nonatomic, copy) NSArray *list;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *adTime;
@property (nonatomic, assign) BOOL is_showAd;
@property (nonatomic, assign) NSInteger last_num;

@property (nonatomic, assign) BOOL isShowAlertShare;
@property (nonatomic, assign) BOOL showShareDisappear;
@property (nonatomic, copy) NSDictionary *shareData;
@property (nonatomic, assign) WALMEInviteShareType shareType;
@property (nonatomic, assign) BOOL showForceFollow;
@property (nonatomic, assign) BOOL fromSign;

@property (nonatomic, assign) NSUInteger matchPageIndex;
//@property (nonatomic, assign) NSUInteger show_replyIndex; // 1 show, 0 hidden

// current user
// 首页匹配倒计时 如果这次匹配的时间是11：10 那么存储的时间为11：20
@property (nonatomic, assign) NSTimeInterval matchTime;
@property (nonatomic, assign) NSTimeInterval matchTimesLeft;

@end

//NS_ASSUME_NONNULL_END
