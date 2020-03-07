//
//  JJCodeChecker.m
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/8.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "JJCodeChecker.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "JJImageViewController.h"

const int kJJMenuBtnTag = 996;

static BOOL _showMenuBtn = NO;
static NSMutableSet<Class> *_clsSet;
static NSMutableSet<NSString *> *_imageSet;
static NSArray<NSArray *> * _imageArrayForCls;

static NSArray<NSString *> * _allLoadImageNames;
static NSArray<NSString *> * _allImageNames;

dispatch_queue_t _runAsyncQueue;

static void runAsyncTask(void(^block)(void)) {
    dispatch_async(_runAsyncQueue, ^{
        if (block) {
            block();
        }
    });
}

@implementation JJCodeChecker

+ (void)check {
    [self addSomeImageClassName:@"AppDelegate"];
    [self addSomeImageClassName:@"JJCodeChecker"];
    
    _runAsyncQueue = dispatch_queue_create("com.JJCodeCheck.runAsyncQueue", 0);
    __block NSMutableArray * allLoadImages = [NSMutableArray array];
    __block NSMutableArray * imageNames = [NSMutableArray array];
    __block NSMutableArray * allImages = [NSMutableArray array];
    runAsyncTask(^{
        [_clsSet enumerateObjectsUsingBlock:^(Class  _Nonnull obj, BOOL * _Nonnull stop) {
            NSMutableArray * classNames = [NSMutableArray array];
            unsigned int classCount;
            const char * clsImage = class_getImageName(obj);
            //            NSString * imageName = [NSString stringWithCString:clsImage encoding:NSUTF8StringEncoding];
            const char ** classes = objc_copyClassNamesForImage(clsImage, &classCount);
            for (unsigned int i = 0; i < classCount; i++) {
                NSString * clsName = [NSString stringWithCString:classes[i] encoding:NSUTF8StringEncoding];
                [classNames addObject:clsName];
            }
            NSString * imageName = [NSString stringWithCString:clsImage encoding:NSUTF8StringEncoding];
//            NSArray * paths = [imageName componentsSeparatedByString:@"/"];
//            imageName = [paths lastObject];
            if (imageName) {
                [imageNames addObject:imageName];
            }
            [allLoadImages addObject:classNames];
        }];
        _allLoadImageNames = [imageNames copy];
        
        unsigned int imageCount;
        const char ** images = objc_copyImageNames(&imageCount);
        for (unsigned int i = 0; i < imageCount; i++) {
            const char * image = images[i];
            NSString * imageName = [NSString stringWithCString:image encoding:NSUTF8StringEncoding];
//            NSArray * paths = [imageName componentsSeparatedByString:@"/"];
//            imageName = [paths lastObject];
            if (imageName) {
                [allImages addObject:imageName];
            }
        }
        _allImageNames = [allImages copy];
        //        unsigned int classCount;
        //        Class * classes = objc_copyClassList(&classCount);
        //        for (unsigned int i = 0; i < classCount; i++) {
        //            <#statements#>
        //        }
    });
}

+ (void)setShowMenuBtn:(BOOL)showMenuBtn {
    _showMenuBtn = showMenuBtn;
    UIViewController * root = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIButton * button = [root.view viewWithTag:kJJMenuBtnTag];
    if (!button) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = (CGRect){100, 100, 50, 50};
        button.alpha = 0.5;
        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"menu" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (showMenuBtn) {
        [root.view addSubview:button];
    } else {
        [button removeFromSuperview];
    }
}

+ (BOOL)showMenuBtn {
    return _showMenuBtn;
}

+ (void)addSomeImageClassName:(NSString *)clsName {
    if (!_clsSet) {
        _clsSet = [NSMutableSet set];
    }
    if (!_imageSet) {
        _imageSet = [NSMutableSet set];
    }
    Class aCls = NSClassFromString(clsName);
//    if (aCls) {
//        [_clsSet addObject:aCls];
//    }
    const char * clsImage = class_getImageName(aCls);
    NSString * imageName = [NSString stringWithCString:clsImage encoding:NSUTF8StringEncoding];
    if (![_imageSet containsObject:imageName]) {
        [_clsSet addObject:aCls];
        [_imageSet addObject:imageName];
    }
}

+ (void)menuClick:(UIButton *)sender {
    static UIView * menuView = nil;
    if (!menuView) {
        menuView = [[UIView alloc] initWithFrame:CGRectMake(150, 75, 50, 100)];
        UIButton * imageBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"image" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, 50, 50);
            btn.backgroundColor = [UIColor yellowColor];
            [btn addTarget:self action:@selector(showImageList:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [menuView addSubview:imageBtn];
        UIButton * viewBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"view" forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 50, 50, 50);
            btn.backgroundColor = [UIColor blueColor];
            [btn addTarget:self action:@selector(showViewController:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [menuView addSubview:viewBtn];
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender.superview addSubview:menuView];
    }
    else {
        [menuView removeFromSuperview];
    }
}

+ (void)showImageList:(UIButton *)sender {
    JJImageViewController * imageList = [[JJImageViewController alloc] initWithFocusImages:_allLoadImageNames otherImages:_allImageNames];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:imageList];
    UIViewController * root = UIApplication.sharedApplication.delegate.window.rootViewController;
    [root presentViewController:nav animated:YES completion:nil];
}

+ (void)showViewController:(UIButton *)sender {
    
}

+ (NSArray<NSString *> *)images {
    return _allLoadImageNames;
}

//+ (void)initialize {
//
//}

@end
