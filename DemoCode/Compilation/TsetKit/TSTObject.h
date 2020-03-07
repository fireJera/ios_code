//
//  TSTObject.h
//  TsetKit
//
//  Created by Jeremy on 2019/5/10.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define TSTObjectIdentifier @"TSTObjectIdentifier"

@interface TSTObject : NSObject

@property (nonatomic, weak) NSDictionary * weakDic;

+ (void)testLog;

@end

NS_ASSUME_NONNULL_END
