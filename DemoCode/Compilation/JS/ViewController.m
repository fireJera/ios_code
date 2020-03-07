//
//  ViewController.m
//  JS
//
//  Created by Jeremy on 2019/8/1.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    JSContext * context = [[JSContext alloc] init];
    context[@"hello"] = ^(NSString *msg) {
        NSLog(@"hello %@", msg);
    };
    [context evaluateScript:@"hello('world')"];
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString * localLanguageCode = array[0];
    //获取当前语言：和下面的 前缀是一样的 en
    NSString * languageCode= [[[NSBundle mainBundle] preferredLocalizations] firstObject];
    //获取当前地区：这个是系统设置中的地区 en_CN en_US 后面的才是真正的当前的地区 前面的意义未知
    //PS:关于NSLocaleIdentifier，zh_CN，zh代表设备语言里面第一个【受支持】语言，CN代表国家地区
    NSString * localeLanguagCode = [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleLanguageCode];
    NSString * localeId = [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleIdentifier];
//    same as [[NSLocale currentLocale] localeIdentifier];
    // 这个和 array 看起来一样的 返回的是系统设置中的语言的数组 zh-Han-(CN|US|...)
    NSArray * languages = [NSLocale preferredLanguages];
    NSString * a = languages.firstObject;
    
    NSLog(@"%@", localLanguageCode);
}

@end
