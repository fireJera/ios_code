//
//  WALMEAppData.h
//  CodeFrame
//
//  Created by Jeremy on 2019/3/26.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

#import "WALMEUserDefaults.h"

NS_ASSUME_NONNULL_BEGIN

#define WALMEINSTANCE_APP                     ([WALMEAppData sharedAppData])

@interface WALMEAppData : WALMEUserDefaults

+ (instancetype)sharedAppData;                            // 所有用户公用数据

//审核用的字段 - 登录页设置
@property (nonatomic, assign) BOOL showLogin;
@property (nonatomic, assign) BOOL showAppleLogin;
@property (nonatomic, assign) BOOL checkWechatInstall;
@property (nonatomic, assign) BOOL preRelease;
@property (nonatomic, assign) int firstLaunch;

@end

NS_ASSUME_NONNULL_END
