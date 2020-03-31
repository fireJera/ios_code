//
//  WALMEVoicePlayerControl.h
//  CodeFrame
//
//  Created by Jeremy on 2019/6/3.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WALMEVoicePlayerEndBlock)(NSError * _Nullable error);

@interface WALMEVoicePlayerControl : NSObject

@property(nonatomic, copy) NSString * netVoiceURL;
@property(nonatomic, copy) NSString * localVoiceURL;
@property(nonatomic, strong) NSData * voiceData;

@property (nonatomic, copy) WALMEVoicePlayerEndBlock endBlock;

@property (readonly) BOOL playing;

// default YES
@property (nonatomic, assign) BOOL autoChange;
@property (nonatomic, assign) NSInteger numberOfLoops;

//- (instancetype)initWithnu

- (void)startPlay;
- (void)pausePlay;
- (void)stopPlay;

@end

NS_ASSUME_NONNULL_END
