//
//  ViewController.m
//  Memory
//
//  Created by super on 2018/12/26.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import "Test.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Test * test = [[Test alloc] init];
    
//    for (int i = 0; i < 10e6; ++i) {
//        // 事实证明内存的确会暴增
//        // 而使用了autoreleasepool可以在一定程度上解决此问题
//        // 在下面这个例子中就不能够很好的解决这个问题
//        @autoreleasepool {
//            NSString *str = [NSString stringWithFormat:@"hi + %d", i];
//        }
//    }
//    for (int i = 0; i < 999999; i++) {
//        @autoreleasepool {
//            UIImage * image = [UIImage imageNamed:@"memory.jpg"];
//            UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
//            imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//        }
//    }
}

/**
 此方法可以在指定次数后释放一次自动释放池
 不过要使用MRC
 */
//- (void)doSomething {
//    int count = 0;
//    NSMutableArray *collection = @[].mutableCopy;
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    for (int i = 0; i < 10e6; ++i) {
//        NSString *str = [NSString stringWithFormat:@"hi + %d", i];
//        [collection addObject:str];
//        if (++count == 100) {
//            /** 每一百次倾倒一次池子 */
//            [pool drain];
//            count = 0;
//        }
//    }
//    /** 用来倾倒当i的个数不是100的倍数时，比如读取数据库数据时,数据总数为不确定值 */
//    [pool drain];
//    NSLog(@"finished!");
//}

@end
