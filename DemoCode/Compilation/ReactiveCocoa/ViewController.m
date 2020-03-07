//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by Jeremy on 2019/1/16.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "TestViewController.h"

@interface ViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) UIButton * logInbutton;
@property (nonatomic, strong) UITextField * nameText;
@property (nonatomic, strong) UITextField * passText;

@property (nonatomic, strong) RACCommand * command;
@property (nonatomic, strong) id<RACSubscriber> subscriber;
@property (nonatomic, copy) NSString * name;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_testAlert];
    
//    [self setNameWithFormat:@"%@%@%@", @"name", @"with", @"format"];
//    [self setNameWith:@"%@%@", @"name", @"with"];
//    [self testCommand];
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(100, 100, 100, 100);
//    button.backgroundColor = [UIColor yellowColor];
//    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
////    [button rac_signalForControlEvents:UIControlEventTouchUpInside];
//
//    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        [subscriber sendNext:@1];
//        [subscriber sendCompleted];
//        return [RACDisposable disposableWithBlock:^{
//            NSLog(@"信号被摧毁");
//        }];
//    }];
//
//    RACDisposable * disps = [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"接受到数据");
//    }];
//
//    NSArray * numbers = @[@1,@2,@3,@4,@5];
//    [numbers.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@", x);
//    }];
//
//    NSArray * flags = [[numbers.rac_sequence map:^id _Nullable(id  _Nullable value) {
//        return @1;
//    }] array];
//
//    UITextField * textfield = [[UITextField alloc] initWithFrame:CGRectMake(100, 310, 160, 50)];
//    [self.view addSubview:textfield];
//    [textfield.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"%@ changed", x);
//    }];
//    [[textfield rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
//        NSLog(@"%@", x);
//    }];
//
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
//        NSLog(@"键盘弹出");
//    }];
//
//    //command
//
//    RACCommand * command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//        NSLog(@"执行命令");
//        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//            [subscriber sendNext:@"请求数据"];
//            [subscriber sendCompleted];
//            return nil;
//        }];
//    }];
//    _command = command;
//    [command.executionSignals subscribeNext:^(id  _Nullable x) {
//        [x subscribeNext:^(id  _Nullable x) {
//            NSLog(@"%@", x);
//        }];
//    }];
//    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
//        if ([x boolValue]) {
//            NSLog(@"正在执行");
//        } else {
//            NSLog(@"执行完成");
//        }
//    }];
}

- (instancetype)setNameWithFormat:(NSString *)format, ... {
    NSCParameterAssert(format != nil);
    va_list args;
    va_start(args, format);
    NSString * str = [[NSString alloc] initWithFormat:format arguments:args];
    NSLogv(format, args);
    va_end(args);
    self.name = str;
    return self;
}

- (void)setNameWith:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString * str = [[NSString alloc] initWithFormat:format arguments:args];
    NSLogv(format, args);
    va_end(args);
    self.name = str;
}

- (void)click {
    [self.command execute:@1];
    
    TestViewController * test = [[TestViewController alloc] init];
    test.delegateSignal = [RACSubject subject];
    [test.delegateSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"click notify");
    }];
    [self presentViewController:test animated:YES completion:nil];
}

- (void)testSignal {
    // 创建信号
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 接受信号
        _subscriber = subscriber;
        NSLog(@"");
        [subscriber sendNext:@1];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"取消");
        }];
    }];
    
    // 订阅信号
    RACDisposable * disposable = [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    // 取消 信号
    [disposable dispose];
}

- (void)testSubject {
    RACSubject * subject = [RACSubject subject];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"testSubject 1  %@", x);
    }];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"testSubject 2  %@", x);
    }];
    [subject sendNext:@123];
}

- (void)testReplaySubject {
    RACReplaySubject * subject = [RACReplaySubject subject];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"testSubject 1  %@", x);
    }];
    [subject sendNext:@123];
    [subject sendNext:@456];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"testSubject 2  %@", x);
    }];
}

- (void)testCommand {
    RACCommand * command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//        return [RACSignal empty];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"command"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    _command = command;
    
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"拿到信号的方式二%@",x);
    }];
    
    RACSignal * signal = [command execute:@"excute"];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"拿到信号的方式一%@",x);
    }];
    [command execute:@"execute"];
    
    [command.executing subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue] == YES) {
            NSLog(@"命令正在执行");
        } else {
            NSLog(@"命令完成/没有执行");
        }
    }];
}

- (void)p_testAlert {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"test" message:@"test message" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"sure", nil];
    
    [alert.rac_buttonClickedSignal subscribeNext:^(NSNumber * _Nullable x) {
        NSLog(@"%d", x.intValue);
    }];
//    [alert.rac_willDismissSignal subscribeNext:^(NSNumber * _Nullable x) {
//        NSLog(@"rac_willDismissSignal %d", x.intValue);
//    }];
    [alert show];
}

//- (void)alertViewCancel:(UIAlertView *)alertView {
//    NSLog(@"-----alertViewCancel-----");
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSLog(@"-----clickedButtonAtIndex %d-----", buttonIndex);
//}
//
//- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
//    NSLog(@"-----willDismissWithButtonIndex %d-----", buttonIndex);
//}
//
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    NSLog(@"-----didDismissWithButtonIndex %d-----", buttonIndex);
//}

@end
