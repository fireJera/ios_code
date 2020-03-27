//
//  KVOClass.h
//  KVCKVO
//
//  Created by Jeremy on 2020/3/23.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVOPerson : NSObject

@property (nonatomic, assign) int age;

@end

@interface KVOClass : NSObject

@property (nonatomic, copy) NSString * firstName;
@property (nonatomic, copy) NSString * lastName;
@property (nonatomic, copy) NSString * fullName;

@property (nonatomic, assign) int totalAge;
@property (nonatomic, copy) NSArray<KVOPerson *> * persons;

- (void)updateTotalAge;

@end

NS_ASSUME_NONNULL_END
