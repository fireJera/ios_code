//
//  WALMEAliLog.m
//  CodeFrame
//
//  Created by Jeremy on 2019/7/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEAliLog.h"
#import "UIView+WALME_Frame.h"
#import "WALMENetWorkManager.h"
#import "WALMEGCDTimer.h"

@interface WALMEAliLog ()

//@property (nonatomic, strong) LogClient * client;
//@property (nonatomic, strong) RawLogGroup * logGroup;
@property (nonatomic, strong) WALMEGCDTimer * gcdTimer;
@property (nonatomic, copy) NSString * storeName;

@end

@implementation WALMEAliLog

static NSString * kUserid = nil;
static NSString * kUaInfo = nil;

//- (instancetype)initWithEndPoint:(NSString *)endPoint
//                           keyID:(NSString *)keyID
//                       keySecret:(NSString *)keySecret {
////                     projectName:(NSString *)projectName {
//    if (self = [super init]) {
//        _client = [[LogClient alloc] initWithApp:endPoint accessKeyID:keyID accessKeySecret:keySecret projectName:kAPPName serializeType:AliSLSJSONSerializer];
//    }
//    return self;
//}

+ (instancetype)sharedLog {
    static WALMEAliLog * _instance = nil;
    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _instance = [super allocWithZone:NULL];
//        __weak typeof(_instance) weakIns = _instance;
//        _instance.gcdTimer = [WALMEGCDTimer scheduledDispatchTimerTimeInterval:6 repeats:YES callBlockNow:NO action:^{
//            if (weakIns.logGroup) {
//                [weakIns postLog];
//            }
//        }];
//    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedLog];
}

+ (void)setUaInfo:(NSString *)uaInfo {
    kUaInfo = uaInfo;
}

+ (void)setUserid:(NSString *)userid {
    kUserid = userid;
}

- (void)putKesAndValues:(NSDictionary<NSString *, NSString *> *)dictionary toTopic:(NSString *)topic toSource:(NSString *)soure {
    if (!dictionary || dictionary.allKeys.count == 0) return;
//    if (!_logGroup) {
//        _logGroup = [[RawLogGroup alloc] initWithTopic:topic andSource:soure];
//    }
//    NSArray * keys = dictionary.allKeys;
//    RawLog * log = [[RawLog alloc] init];
//
//    for (NSString *key in keys) {
//        NSString * value = dictionary[key];
//        [log PutContent:value withKey:key];
//    }
////    [log PutContent:kAPPName withKey:@"appName"];
//    if (kUaInfo) {
//        [log PutContent:kUaInfo withKey:@"uainfo"];
//    }
//    if (kUserid) {
//        [log PutContent:kUserid withKey:@"userid"];
//    }
//    [_logGroup PutLog:log];
//    LogGroup * group = [[LogGroup alloc] init];//initWitTopic:topic andSource:soure];
//    group.topic = topic;
//    group.source = soure;
//    NSArray * keys = dictionary.allKeys;
//    Log * log = [[Log alloc] init];
//
//    for (NSString *key in keys) {
//        NSString * value = dictionary[key];
//        [log p]
//    }
}

- (void)postLog {
    __weak typeof(self) weakSelf = self;
//    if (_client) {
//        [_client PostLog:_logGroup logStoreName:_storeName call:^(NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            if (!error) {
//                weakSelf.logGroup = nil;
//            } else {
//                [weakSelf postLogAftreSts];
//            }
//        }];
//    }
//    else {
//        [self postLogAftreSts];
//    }
}

- (void)postLogAftreSts {
//    [self p_walme_stsRequest:^{
//        if (_client) {
//            __weak typeof(self) weakSelf = self;
//            [_client PostLog:_logGroup logStoreName:_storeName call:^(NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                if (!error) {
//                    weakSelf.logGroup = nil;
//                }
//            }];
//        }
//    }];
}

+ (void)walme_didSelectIndexPath:(NSIndexPath *)indexPath
                      scrollView:(UIScrollView *)scrollView
                      actionName:(nonnull NSString *)actionName {
    NSMutableDictionary<NSString *, NSString *> * dic = [NSMutableDictionary dictionary];
    UIViewController * controller = scrollView.viewController;
    NSString * module = NSStringFromClass(controller.class);
    [dic setValue:module forKey:@"module"];
    if (actionName) {
        [dic setValue:actionName forKey:@"aciton"];
    }
    [[self sharedLog] putKesAndValues:dic toTopic:@"" toSource:@""];
}

+ (void)putModule:(NSString *)module action:(NSString *)action {
    NSMutableDictionary<NSString *, NSString *> * dic = [NSMutableDictionary dictionary];
    if (module) {
        [dic setValue:module forKey:@"module"];
    }
    if (action) {
        [dic setValue:action forKey:@"aciton"];
    }
    [[self sharedLog] putKesAndValues:dic toTopic:@"" toSource:@""];
}


- (void)p_walme_stsRequest:(void(^)(void))resultBlock {
//    NSString * logURL = @"aliyun/log-sts";
//    [WALMENetWorkManager walme_post:logURL withParameters:nil success:^(id result) {
//        NSString * endPoint = result[@"data"][@"endpoint"];
//        NSString * keyID = result[@"data"][@"accessKeyId"];
//        NSString * keySecret = result[@"data"][@"accessKeySecret"];
//        NSString * token = result[@"data"][@"securityToken"];
//        NSString * projectName = result[@"data"][@"projectName"];
//        _storeName = result[@"data"][@"logStore"];
//        _client = [[LogClient alloc] initWithApp:endPoint accessKeyID:keyID accessKeySecret:keySecret projectName:projectName serializeType:AliSLSJSONSerializer];
//        if (!_client.GetKeySecret) {
//            return ;
//        }
//        [_client SetToken:token];
//        if (resultBlock) {
//            resultBlock();
//        }
//    } failed:^(BOOL netReachable, NSString *msg, id result) {
//        _client = nil;
////        NSString *domain = @"com.CodeFrame.WALMEChatAliOSS.ErrorDomain";
////        NSString *desc = msg;
////        if (!desc) {
////            desc = WALMENetWorkErrorNoteString;
////        }
////        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : desc };
////        NSError *netError = [NSError errorWithDomain:domain
////                                                code:-500
////                                            userInfo:userInfo];
////        if (resultBlock) {
////            resultBlock();
////        }
//    }];
}

@end
