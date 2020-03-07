//
//  ViewController.m
//  Macro
//
//  Created by Jeremy on 2019/1/27.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "ViewController.h"

#define metamacro_head(...)\
        metamacro_head_(__VA_ARGS__, 0)

#define metamacro_head_(FIRST, ...) FIRST

#define metamacro_at20(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, ...) metamacro_head(__VA_ARGS__)

#define metamacro_contact_(A, B) A##B

#define metamacro_contact(A,B) \
        metamacro_contact_(A, B)

#define metamacro_at(N, ...)\
        metamacro_contact(metamacro_at, N)(__VA_ARGS__)

#define metamacro_argount(...) \
        metamacro_at(20, __VA_ARGS__, 20, 19, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)

//#pragma message "jeremy"

//#define SOME_WARNING _Pragma("message(\"报告大王!\")")

#define STRINGIFY(S) #S
#define DEFER_STRINGIFY(S) STRINGIFY(S)
#define PRAGMA_MESSAGE(MSG) _Pragma(STRINGIFY(message(MSG)))
#define FORMATTED_MESSAGE(MSG) "[TODO-" DEFER_STRINGIFY(__COUNTER__) "] " MSG " \n" \
DEFER_STRINGIFY(__FILE__) " line " DEFER_STRINGIFY(__LINE__)
#define KEYWORDIFY try {} @catch (...) {}
#define TODO(MSG) KEYWORDIFY PRAGMA_MESSAGE(FORMATTED_MESSAGE(MSG))

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @TODO("figure it out")
    for (int i = 0; i < 10; i++) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
        [self.view addSubview:view];
    }

    for (UIView * view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
//    NSMutableArray * array = [@[@"1", @"2", @"4", @"5", @"6", @"3"] mutableCopy];
//    for (int i = 0; i < array.count; i++) {
//        [array addObject:@"2"];
//    }
    
    NSMutableArray * marray = [@[@"1", @"2", @"4", @"5", @"6", @"3"] mutableCopy];
    for (NSString * str in marray) {
        [marray removeObject:str];
        break;
    }
    
//    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [array removeObjectAtIndex:idx];
//    }];
    
//    SOME_WARNING
//    int count = metamacro_argount(1, 2, 3);
//    metamacro_at(20, 1, 2, 3, 20, 19, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
//    metamacro_contact(metamacro_at, 20, 1,2,3,20, 1)(__VA_ARGS__)
//    metamacro_at20(1,2,3)
//    metamacro_head_(3, 2, 1) 3
}

@end
