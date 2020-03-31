//
//  WALMEPlayerViewmodel.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALMEPlayerInfoDataSource.h"

NS_ASSUME_NONNULL_BEGIN

//@protocol WALMEPlayerViewmodelDelegate;

@interface WALMEPlayerViewmodel : NSObject <WALMEPlayerInfoDataSource>

@property (nonatomic, strong) UIView * adView;

//- (instancetype)initWithDelegate:(id<WALMEPlayerViewmodelDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithNSDictionary:(NSDictionary *)dic image:(nullable UIImage *)snapImage NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithVideoPath:(nullable NSString *)videoPath image:(nullable UIImage *)snapImage NS_DESIGNATED_INITIALIZER;

@end

//@protocol WALMEPlayerViewmodelDelegate <NSObject>
//
//@property (nonatomic, copy, readonly) NSString *nickname;
//@property (nonatomic, copy, readonly) NSString *avatar;
//@property (nonatomic, copy, readonly) NSString *jobAndLocation;
//@property (nonatomic, copy, readonly) NSString *selfDesc;
//@property (nonatomic, copy, readonly) NSString *video;
//
//@end

NS_ASSUME_NONNULL_END
