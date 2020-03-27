//
//  ViewController.m
//  KVCKVO
//
//  Created by Jeremy on 2020/3/23.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import "KVCClass.h"
#import "KVOClass.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    KVCClass * kvc = [KVCClass new];
    
    [kvc setValue:@"kvc" forKey:@"kvcName"];
    
    KVOClass * kvo = [KVOClass new];
    
    /*
     NSKeyValueObservingOptionOld 回调的change里包含旧值
     NSKeyValueObservingOptionNew 回调的change里包含新值
     NSKeyValueObservingOptionInitial addObserver后立即回调一次
     NSKeyValueObservingOptionPrior willChangeForKey, didChangeForKey 总共回调两个
     */
    [kvo addObserver:self forKeyPath:@"lastName" options:NSKeyValueObservingOptionOld context:nil];
    
//    NSObject * obj = [NSObject new];
//    NSError * error;
//    BOOL validate = [kvc validateValue:&obj forKey:@"kvcName" error:&error];
//    if (validate) {
//        [kvc setValue:obj forKey:@"kvcName"];
//    }
//    else {
//        NSLog(@"%@", error.localizedDescription);
//    }
//    [kvc setValue:@"_kvc" forKey:@"_kvcName"];
    
//    [kvc setValue:@"kvc" forKey:@"kvc"];
//
//    [kvc setValue:@"kvc" forKey:@"kvc"];
//
//    kvc.kvcName = @"kvc";
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    if (context == <#context#>) {
//        <#code to be executed upon observing keypath#>
//    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
}

@end
