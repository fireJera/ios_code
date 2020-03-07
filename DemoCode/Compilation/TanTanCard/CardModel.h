//
//  CardModel.h
//  TanTanCard
//
//  Created by Jeremy on 2020/2/20.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardModel : NSObject

@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger sex;

@end

NS_ASSUME_NONNULL_END
