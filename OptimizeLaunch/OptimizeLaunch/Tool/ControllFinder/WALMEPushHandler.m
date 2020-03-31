//
//  WALMEPushHandler.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEPushHandler.h"
#import "WALMEViewmodelHeader.h"
#import "WALMEViewHeader.h"
#import <objc/message.h>
//#import "AppDelegate.h"
//#import "WALMEConversationListViewmodel.h"

@implementation WALMEPushHandler

static NSDictionary * _launchFromPush = nil;

+ (void)walme_dealDictionary:(NSDictionary *)funcdata {
    _launchFromPush = funcdata;
}

+ (void)walme_dealPush {
    if (_launchFromPush) {
        NSString *dataType;
//        = SAFESTRING(_launchFromPush[@"dataType"]);
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:", dataType]);
        if (![self respondsToSelector:selector]) {
            return;
        }
        NSDictionary * dic = _launchFromPush[@"pageData"];
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL, id) = (void *)imp;
        func(self, selector, dic);
        _launchFromPush = nil;
    }
}

+ (void)chat:(id)argument {
    ((void(*)(id, SEL))(void *)objc_msgSend)(NSClassFromString(@"WALMEOpenPageHelper"), NSSelectorFromString(@"openChatList"));
}

+ (void)notification:(id)argument {
    ((void(*)(id, SEL))(void *)objc_msgSend)(NSClassFromString(@"WALMEOpenPageHelper"), NSSelectorFromString(@"openChatList"));
    ((void(*)(id, SEL))(void *)objc_msgSend)(NSClassFromString(@"WALMEOpenPageHelper"), NSSelectorFromString(@"openSystemMessageList"));
}

+ (void)visit:(id)argument {
    ((void(*)(id, SEL))(void *)objc_msgSend)(NSClassFromString(@"WALMEOpenPageHelper"), NSSelectorFromString(@"openAboutMe"));
    ((void(*)(id, SEL))(void *)objc_msgSend)(NSClassFromString(@"WALMEOpenPageHelper"), NSSelectorFromString(@"openVisitor"));
}

+ (void)follow:(id)argument {
    ((void(*)(id, SEL))(void *)objc_msgSend)(NSClassFromString(@"WALMEOpenPageHelper"), NSSelectorFromString(@"openAboutMe"));
    ((void(*)(id, SEL))(void *)objc_msgSend)(NSClassFromString(@"WALMEOpenPageHelper"), NSSelectorFromString(@"openMyFavor"));
}

+ (void)fastChat:(id)argument {
//    ((void(*)(id, SEL))(void *)objc_msgSend)(NSClassFromString(@"WALMEOpenPageHelper"), NSSelectorFromString(@"openChatList"));
    NSString * userid;
    if ([argument isKindOfClass:[NSDictionary class]]) {
        userid = ((NSDictionary *)argument)[@"senderUserid"];
    }
    ((void(*)(id, SEL, NSString *))(void *)objc_msgSend)(NSClassFromString(@"WALMEOpenPageHelper"), NSSelectorFromString(@"openMatchChatWithTargetId"), userid);
}

@end
