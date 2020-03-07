//
//  ViewController.m
//  MQTTTest
//
//  Created by Jeremy on 2019/3/16.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import <MQTTClient/MQTTClient.h>

typedef NS_ENUM(NSUInteger, MQTTSubscribeType) {
    MQTTSubscribeTypeCar,
    MQTTSubscribeTypeMotorControl,
    MQTTSubscribeTypeBMSInfo1,
    MQTTSubscribeTypeBMSInfo2,
    MQTTSubscribeTypeCharging,
};

@interface ViewController () <MQTTSessionDelegate>

@property (nonatomic, strong) MQTTSession * mqttSession;
@property (nonatomic, strong) MQTTSessionManager * sessionManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - session manager

- (void)bindWithUserName:(NSString *)username password:(NSString *)password cliendId:(NSString *)cliendId isSSL:(BOOL)isSSL {
//    [self.sessionManager connectTo:AddressOfMQTTServer
//                              port:self.isSSL? PortOfMQTTServerWithSSL : PortOfMQTTServer
//                               tls:self.isSSL
//                         keepalive:60
//                             clean:YES
//                              auth:YES
//                              user:self.username
//                              pass:self.password
//                              will:NO
//                         willTopic:nil
//                           willMsg:nil
//                           willQos:MQTTQosLevelAtLeastOnce
//                    willRetainFlag:NO
//                      withClientId:self.cliendId
//                    securityPolicy:[self customSecurityPolicy]
//                      certificates:nil
//                     protocolLevel:4
//                    connectHandler:nil];
//
//
//    self.isDiscontent = NO;
//    self.sessionManager.subscriptions = self.subedDict;
}

#pragma mark ---- 状态
- (void)sessionManager:(MQTTSessionManager *)sessionManager didChangeState:(MQTTSessionManagerState)newState {
    switch (newState) {
        case MQTTSessionManagerStateConnected:
            NSLog(@"eventCode -- 连接成功");
            break;
        case MQTTSessionManagerStateConnecting:
            NSLog(@"eventCode -- 连接中");
            break;
        case MQTTSessionManagerStateClosed:
            NSLog(@"eventCode -- 连接被关闭");
            break;
        case MQTTSessionManagerStateError:
            NSLog(@"eventCode -- 连接错误");
            break;
        case MQTTSessionManagerStateClosing:
            NSLog(@"eventCode -- 关闭中");
            
            break;
        case MQTTSessionManagerStateStarting:
            NSLog(@"eventCode -- 连接开始");
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 订阅
//- (void)subscribeTopic:(NSString *)topic handler:(SubscribeTopicHandler)handler{
//    NSLog(@"当前需要订阅-------- topic = %@",topic);
//    if (![self.subedDict.allKeys containsObject:topic]) {
//        [self.subedDict setObject:[NSNumber numberWithLong:MQTTQosLevelAtLeastOnce] forKey:topic];
//        NSLog(@"订阅字典 ----------- = %@",self.subedDict);
//        self.sessionManager.subscriptions =  self.subedDict;
//    }
//    else {
//        NSLog(@"已经存在，不用订阅");
//    }
//}
//
//#pragma mark - 取消订阅
//- (void)unsubscribeTopic:(NSString *)topic {
//
//    NSLog(@"当前需要取消订阅-------- topic = %@",topic);
//
//    if ([self.subedDict.allKeys containsObject:topic]) {
//        [self.subedDict removeObjectForKey:topic];
//        NSLog(@"更新之后的订阅字典 ----------- = %@",self.subedDict);
//        self.sessionManager.subscriptions =  self.subedDict;
//    }
//    else {
//        NSLog(@"不存在，无需取消");
//    }
//
//}
//
//- (MQTTSSLSecurityPolicy *)customSecurityPolicy
//{
//    MQTTSSLSecurityPolicy *securityPolicy = [MQTTSSLSecurityPolicy policyWithPinningMode:MQTTSSLPinningModeNone];
//
//    securityPolicy.allowInvalidCertificates = YES;
//    securityPolicy.validatesCertificateChain = YES;
//    securityPolicy.validatesDomainName = NO;
//    return securityPolicy;
//}


- (void)sendDataToTopic:(NSString *)topic dict:(NSDictionary *)dict {
    NSData * data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    [self.sessionManager sendData:data topic:topic qos:MQTTQosLevelAtMostOnce retain:NO];
}

- (void)handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(MQTTClientModel_handleMessage:onTopic:retained:)]) {
//        [self.delegate MQTTClientModel_handleMessage:data onTopic:topic retained:retained];
//    }
}

- (void)disconnect {
//    self.isDiscontent = YES;
//    //    self.isContented = NO;
//    [self.sessionManager disconnectWithDisconnectHandler:^(NSError *error) {
//        NSLog(@"断开连接  error = %@",[error description]);
//    }];
//    [self.sessionManager setDelegate:nil];
//    self.sessionManager = nil;
//
}

- (void)reConnect {
//    if (self.sessionManager && self.sessionManager.port) {
//        self.sessionManager.delegate = self;
//        self.isDiscontent = NO;
//        [self.sessionManager connectToLast:^(NSError *error) {
//            NSLog(@"重新连接  error = %@",[error description]);
//        }];
//        self.sessionManager.subscriptions = self.subedDict;
//    }
//    else {
//        [self bindWithUserName:self.username password:self.password cliendId:self.cliendId isSSL:self.isSSL];
//    }
}

#pragma mark - session

- (void)useSession {
    static NSString * const kMQTTHOST = @"";
    static const UInt32 kMQTTPORT = 8888;
    static NSString * const kUserName = @"";
    static NSString * const kPass = @"";
    
    //主题格式          @“$IOT/haha/datapoint/motor_control”
    //主题格式          @“$IOT/haha/#”
    //    现在你只需要把主题的URL  改成这样  @"$IOT/haha/#"
    //    MQTT主题(Topic)支持’+’, ‘#’的通配符，’+’通配一个层级，’#’通配多个层级(必须在末尾)
    static NSString * const kMQTTTopicCar = @"";
    static NSString * const kMQTTTopicMotorControl = @"";
    static NSString * const kMQTTTopicBMSInfo1 = @"";
    static NSString * const kMQTTTopicBMSInfo2 = @"";
    static NSString * const kMQTTTopicCharging = @"";
    
    MQTTCFSocketTransport * transport = [[MQTTCFSocketTransport alloc] init]; // 初始化对象
    transport.host = kMQTTHOST;
    transport.port = kMQTTPORT;
    
    self.mqttSession = [[MQTTSession alloc] init];
    self.mqttSession.transport = transport;
    self.mqttSession.delegate = self;
    [self.mqttSession setUserName:kUserName];
    [self.mqttSession setPassword:kPass];
    
    [self.mqttSession connectAndWaitTimeout:1];
    MQTTSubscribeType type  = MQTTSubscribeTypeCar;
    if (type == MQTTSubscribeTypeCar ||
        type == MQTTSubscribeTypeMotorControl ||
        type == MQTTSubscribeTypeBMSInfo1 ||
        type == MQTTSubscribeTypeBMSInfo2 ||
        type == MQTTSubscribeTypeCharging) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self class] subscribeTopic:self.mqttSession toTopic:kMQTTTopicCar];
                [[self class] subscribeTopic:self.mqttSession toTopic:kMQTTTopicMotorControl];
                [[self class] subscribeTopic:self.mqttSession toTopic:kMQTTTopicBMSInfo1];
                [[self class] subscribeTopic:self.mqttSession toTopic:kMQTTTopicBMSInfo2];
                [[self class] subscribeTopic:self.mqttSession toTopic:kMQTTTopicCharging];
            });
        });
    }
    
    //    [self.mqttSession addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld context:nil];
    NSTimer * timer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(monitorStatus) userInfo:nil repeats:YES];
    
    //    self.mqttSession.clientId = @"";
    //    [self.mqttSession closeAndWait:1];
    //    [self.mqttSession unsubscribeTopic:kMQTTTopicCharging];
    //    [self.mqttSession disconnect];
}

+ (void)subscribeTopic:(MQTTSession *)session toTopic:(NSString *)topicUrl {
    [session subscribeToTopic:topicUrl atLevel:MQTTQosLevelAtMostOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
        if (error) {
            NSLog(@"连接失败");
        }
        else {
            NSLog(@"连接成功");
        }
    }];
}

#pragma mark - MQTTSessionDelegate

- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    [_mqttDataDic setDictionary:dic];
//    if (_mqttDataDic.count != 0) {
    if ([topic rangeOfString:@"status"].location != NSNotFound) {
//        [self screenCarDic:_chooseCodeCarStr];
    }
    else if ([topic rangeOfString:@"motor_control"].location != NSNotFound) {
//        [self mqttMotorControl:_chooseCodeCarStr];
    }
    else if ([topic rangeOfString:@"bms_info_1"].location != NSNotFound) {
//        [self buffInfo_1:_chooseCodeCarStr];
    }
    else if ([topic rangeOfString:@"bms_info_2"].location != NSNotFound) {
//        [self buffInfo_2:_chooseCodeCarStr];
    }
    else if ([topic rangeOfString:@"charging_info"].location != NSNotFound) {
//        [self getMQTTChargingData:_chooseCodeCarStr];
    }
//    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.mqttSession.status == 4) {
        [self.mqttSession connect];
    }
}

- (void)monitorStatus {
    if (self.mqttSession.status == 4) {
        [self.mqttSession connect];
    }
}

@end
