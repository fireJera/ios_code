//
//  ViewController.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "ViewController.h"
//#include <monitor.h>
//#import <monitor.h>

//#import "JJAssoicationManager.h"
#import "Test.h"
#import <objc/runtime.h>
#import <JJCodeCheck/JJCodeCheck.h>
//#import "JJCodeCheck.h"
#import "UIApplication+JJ_Leak.h"
#import "ViewController+Cat.h"
#import "FBRetainCycleDetector.h"
#import "AllowTest.h"
#import "TestViewController.h"
//struct TestStruct {
//    int name;
//    char *text;
//};

// https://developer.apple.com/library/archive/documentation/Performance/Conceptual/CodeFootprint/Articles/ImprovingLocality.html
void MyFunc(int a) __attribute__((section ("__TEXT,__text.10")));
// https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/MachOTopics/1-Articles/x86_64_code.html

@interface ViewController ()

//@property (nonatomic, assign) struct TestStruct nameStruct;
@property (nonatomic, strong) NSObject *object;
//@property (nonatomic, strong) AllowTest * aTest;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSObject*firstO = [NSObject new];
    __attribute__((objc_precise_lifetime)) NSObject *object = [NSObject new];
    __weak NSObject *secondO = [NSObject new];
    NSObject *thirdO = [NSObject new];
    
    __unused void(^block)(void) = ^{
        __unused NSObject * first = firstO;
        __unused NSObject * second = secondO;
        __unused NSObject * third = thirdO;
    };
    
    NSTimer * timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer repeat");
    }];
    
//    _object = [NSObject new];
//    _aTest = [AllowTest new];
//    _aTest.delegate = self;
//    self.catObj = [NSObject new];
//    FBObjectGraphConfiguration * con = [[FBObjectGraphConfiguration alloc] initWithFilterBlocks:nil shouldInspectTimers:YES];
//    FBRetainCycleDetector * detector = [[FBRetainCycleDetector alloc] initWithConfiguration:con];
//    [detector addCandidate:(id)block];
//    [detector addCandidate:timer];
//    [detector addCandidate:_object];
////    [detector addCandidate:_aTest];
//    [detector findRetainCycles];
//    JJCodeChecker.showMenuBtn = YES;
//blockLiteral->descriptor->size
//    TestA * a = [TestA new];
//    NSString * pointer = [NSString stringWithFormat:@"%p", a];
//
////    unsigned addr = 0;
////    NSScanner * scn = [NSScanner scannerWithString:pointer];
////    [scn scanHexInt:&addr];
////    void * aPtr = (__bridge void *)a;
////    id cObj = (__bridge id)(aPtr);
//
//    uintptr_t hex = strtoull(pointer.UTF8String, NULL, 0);
//    id gotcha = (__bridge id)(void *)hex;
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 200, 100, 100);
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
//
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10, 300, 300, 200)];
//    view.backgroundColor = [UIColor orangeColor];
//    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTouch:)]];
//    [self.view addSubview:view];
    
//    NSObject * obj;
//    sscanf([pointer cStringUsingEncoding:NSUTF8StringEncoding], "%p", &obj);
//    id obj = (__bridge id)((void *) addr);
    
//    unsigned int count;
//    Ivar *ivars = class_copyIvarList([self class], &count);
//    for (int i = 0; i < count; i++) {
//        Ivar var = ivars[i];
//        NSString *encoding =  [NSString stringWithCString:ivar_getTypeEncoding(var) encoding:NSUTF8StringEncoding];
//        NSString *name = [NSString stringWithCString:ivar_getName(var) encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", encoding);
//    }
    
//    unsigned int classCount;
//    Class * classes = objc_copyClassList(&classCount);
//    for (unsigned int i = 0; i < classCount; i++) {
//        NSLog(@"class name : %s,  class version : %d", class_getName(classes[i]), class_getVersion(classes[i]));
//    }
    
//    unsigned int frameCount;
//    const char ** frames = objc_copyImageNames(&frameCount);
//    for (unsigned int i = 0; i < frameCount; i++) {
//        const char * imageName = frames[i];
//        printf("%s \n", imageName);
//    }
//
//    printf("current developer image : \n");
//    const char * curImage = class_getImageName(NSClassFromString(@"AppDelegate"));
//    printf("%s", curImage);
    
//    moninit();
//    moncontrol(1);
//
//    /* To stop, and dump to a file */
//    moncontrol(0);
//    monoutput("/tmp/myprofiledata.out");
//    monreset();
}

- (void)btnPressed:(UIButton *)sender {
    [self btnTouch];
}

- (void)viewTouch:(UIGestureRecognizer*)ges {
//    UIGestureRecognizerTarget
}

- (void)btnTouch {
    TestViewController * test = [TestViewController new];
    [self presentViewController:test animated:YES completion:nil];
    NSLog(@"touch");
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//}

@end
