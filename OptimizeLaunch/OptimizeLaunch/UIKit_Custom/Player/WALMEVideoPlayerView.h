//
//  WALMEVideoPlayerView.h
//  CodeFrame
//
//  Created by Jeremy on 2019/4/25.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^VideoPlayerEndPlayBlock)(void);

@interface WALMEVideoPlayerView : UIView

@property (nonatomic, copy) NSString *videoPath;

@property (nonatomic, assign) BOOL showTime;
@property (nonatomic, assign) BOOL autoPlay;
@property (nonatomic, assign) BOOL useVideoCache;
@property (nonatomic, assign, readonly) BOOL playing;
@property (nonatomic, assign, readonly) float totalDuration;

@property (nonatomic, copy) VideoPlayerEndPlayBlock endBlock;

- (void)play;
- (void)stop;
- (void)pause;

@end

NS_ASSUME_NONNULL_END
