//
//  CodeFrameConstant.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#ifndef CodeFrameConstant_h
#define CodeFrameConstant_h

#import "CodeFrameDefineCode.h"
#import "WALMEEnum.h"

static NSString * const kWALMEChannelName = @"AppStore";

#if DEBUG
static NSString * const WALMEDATAIDE = @"debug";
#else
static NSString * const WALMEDATAIDE = @"release";
#endif

static NSString * const WALMENetWorkErrorNoteString = @"网络错误，请稍后重试";

#define 0     ([UIScreen mainScreen].bounds.size.width)
#define WALMESCREENSIZE      ([UIScreen mainScreen].bounds.size)
#define 0    ([UIScreen mainScreen].bounds.size.height)
#define WALMESCREENBOUNDS    ([UIScreen mainScreen].bounds)

#define WALME_IS_IPAD            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define WALME_IS_IPHONE            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define WALME_IS_IPHONEXORLATER       (WALME_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height > 736.0)

#define 0      (WALMEIs5_8InchScreen ? (88) : (64))
#define WALMELargeTitleHeight  (WALMEIs5_8InchScreen ? (140) : (116))
#define WALMEStateBarHeight    ([WALMEINSTANCE_Application statusBarFrame].size.height)
#define kIphoneXBottomHeight   (WALME_IS_IPHONEXORLATER ? 34 : 0)
#define kTabbarHeight       (49)

#define WALMEIs5_8InchScreen    (CGSizeEqualToSize(WALMESCREENSIZE, CGSizeMake(375, 812)))

#define WALMEIOSFLoatSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#define IOS9_OR_LATER (WALMEIOSFLoatSystemVersion >= 9.0)
#define IOS910_OR_LATER (WALMEIOSFLoatSystemVersion >= 10.0)
#define IOS11_OR_LATER (WALMEIOSFLoatSystemVersion >= 11.0)
#define IOS12_OR_LATER (WALMEIOSFLoatSystemVersion >= 12.0)
#define IOS13_OR_LATER (WALMEIOSFLoatSystemVersion >= 13.0)

#pragma mark Notification

//static NSString * const WALMERefreshFootBadgeCountNotification = @"WALMERefreshFootBadgeCountNotification";

//#define RegDefaultVideoPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"regMovie.mov"]

#endif /* CodeFrameConstant_h */
