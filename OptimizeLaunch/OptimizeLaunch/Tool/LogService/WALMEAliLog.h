//
//  WALMEAliLog.h
//  CodeFrame
//
//  Created by Jeremy on 2019/7/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WALMEAliLog : NSObject

@property (nonatomic, copy, class, nullable) NSString * userid;
@property (nonatomic, copy, class) NSString * uaInfo;

//- (instancetype)initWithEndPoint:(NSString *)endPoint
//                           keyID:(NSString *)keyID
//                       keySecret:(NSString *)keySecretNS_DESIGNATED_INITIALIZER;
//                     projectName:(NSString *)projectName NS_DESIGNATED_INITIALIZER;

//- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)sharedLog;

- (void)putKesAndValues:(NSDictionary<NSString *, NSString *> *)dictionary
                toTopic:(NSString *)topic
               toSource:(NSString *)soure;

//- (void)postLog;

+ (void)walme_didSelectIndexPath:(NSIndexPath *)indexPath
                      scrollView:(UIScrollView *)scrollView
                      actionName:(NSString *)actionName;

+ (void)putModule:(NSString *)module action:(NSString *)action;

@end

NS_ASSUME_NONNULL_END
