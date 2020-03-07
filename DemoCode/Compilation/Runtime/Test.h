//
//  Test.h
//  Runtime
//
//  Created by super on 2018/12/26.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Test : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) int age;
@property (nonatomic, copy) NSString * pass;
@property (nonatomic, weak) NSDictionary * dic;
@property (nonatomic, assign) int b;
@property (nonatomic, assign) char *c;
@property (nonatomic, assign) short sh;

@end

NS_ASSUME_NONNULL_END
