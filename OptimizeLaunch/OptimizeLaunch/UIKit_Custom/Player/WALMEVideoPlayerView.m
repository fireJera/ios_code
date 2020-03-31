//
//  WALMEVideoPlayerView.m
//  CodeFrame
//
//  Created by Jeremy on 2019/4/25.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "WALMEViewHeader.h"
#import "WALMEPlayerProgressView.h"
#import "VideoResourceLoader.h"
#import "VideoManager.h"

@interface WALMEVideoPlayerView () {
    AVPlayerLayer *_avplayer;
}

@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic, strong) id playerObserver;

@property (strong, nonatomic) UIImageView *playStatus;

@property (strong, nonatomic) UILabel *currentTime;
@property (strong, nonatomic) UILabel *totalTime;
@property (strong, nonatomic) WALMEPlayerProgressView *slider;
@property (nonatomic, strong) VideoResourceLoader * loader;

@end

@implementation WALMEVideoPlayerView

#pragma mark - view init

- (void)p_walme_setPlayer {
    _player = nil;
    _avplayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    _avplayer.frame = self.bounds;
    _avplayer.contentsScale = [[UIScreen mainScreen] scale];
    _avplayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    CMTime interval = CMTimeMake(1, 30);
    
    __weak typeof(self) weakSelf = self;
    _playerObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if (!weakSelf) {
            return ;
        }
        float currentTime = CMTimeGetSeconds(time);
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *timeText = [NSString stringWithFormat:@"%@", [weakSelf convert:currentTime]];
        weakSelf.currentTime.text = timeText;
        if (strongSelf->_totalDuration) {
            weakSelf.slider.progressValue = currentTime / strongSelf->_totalDuration;
        } else {
            weakSelf.slider.progressValue = 0;
        }
    }];
    [self.layer insertSublayer:_avplayer below:_playStatus.layer];
//    [self.layer addSublayer:_avplayer];
    if (_autoPlay) {
        if (@available(iOS 10.0, *)) {
            _player.automaticallyWaitsToMinimizeStalling = NO;
        }
        [self.player play];
        _playing = YES;
    }
}

- (void)p_walme_setView {
    _playStatus = ({
        UIImageView * imageView = [WALMEViewHelper imageViewWithFrame:CGRectZero imageName:@"mine_upload_bigplay"];
        [self addSubview:imageView];
        imageView.hidden = YES;
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self);
//        }];
        imageView;
    });
    
    _currentTime = ({
        CGRect frame = CGRectMake(20, self.height - 30, 40, 20);
        UILabel * label = [WALMEViewHelper walme_labelWithFrame:frame title:@"00:00" fontSize:13 textColor:[UIColor whiteColor]];
        [self addSubview:label];
        label;
    });
    
    _totalTime = ({
        CGRect frame = CGRectMake(self.width - 60, self.height - 30, 40, 20);
        UILabel * label = [WALMEViewHelper walme_labelWithFrame:frame title:[self convert:_totalDuration] fontSize:13 textColor:[UIColor whiteColor]];
        [self addSubview:label];
        label;
    });
    
    _slider = ({
        WALMEPlayerProgressView * view = [[WALMEPlayerProgressView alloc] initWithFrame:CGRectMake(_currentTime.right + 10, 0, _totalTime.left - 20 - _currentTime.right, 3)];
        view.centerY = _currentTime.centerY;
        [self addSubview:view];
        view;
    });
}

#pragma mark - Observer 未实现

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (AVPlayerItemStatusReadyToPlay == status) {
            _totalDuration = CMTimeGetSeconds(_player.currentItem.asset.duration);
            NSLog(@"🚥🚥🚥observeValueForKeyPath status🚥🚥🚥");
            if (_autoPlay) {
                [self.player play];
                _playing = YES;
            }
            if (_showTime) {
                _totalTime.text = [self convert:_totalDuration];
            }
        } else {
            
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSTimeInterval timeInterval = [self availableDuration];
        NSLog(@"已缓存时长 : %f",timeInterval);
    }
}

#pragma mark - func method

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem * item = [notification object];
    if (item == _player.currentItem) {
        [item seekToTime:kCMTimeZero];
        [self pause];
        if (_endBlock) {
            _endBlock();
        }
    }
}

#pragma mark - public

- (void)play {
    [_player play];
    _playing = YES;
    _playStatus.image = [UIImage imageNamed:@"walme_forall_11"];
    _playStatus.hidden = YES;
}

- (void)stop {
    [self pause];
}

- (void)pause {
    [_player pause];
    _playing = NO;
    _playStatus.image = [UIImage imageNamed:@"mine_upload_bigplay"];
    _playStatus.hidden = NO;
}

#pragma mark - private

- (NSString *)convert:(float)time{
    int minute = time / 60;
    int second = time - minute * 60;
    NSString *minuteString;
    NSString *secondString;
    
    if (minute < 10) {
        minuteString = [NSString stringWithFormat:@"0%d", minute];
    } else{
        minuteString = [NSString stringWithFormat:@"%d", minute];
    }
    if (second < 10){
        secondString = [NSString stringWithFormat:@"0%d", second];
    } else{
        secondString = [NSString stringWithFormat:@"%d", second];
    }
    return [NSString stringWithFormat:@"%@:%@", minuteString, secondString];
}

- (double)getCurrentPlayingTime {
    return self.player.currentTime.value/self.player.currentTime.timescale;
}

- (NSTimeInterval)availableDuration{
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;
    
    return result;
}

- (void)p_walme_releaseSub {
    [_player pause];
    [[VideoManager shareManager] endLoadMediaWithUrl:_loader.url];
    [_loader endLoading];
    [self.player removeTimeObserver:_playerObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @try {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
        [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    });
    
    [_avplayer removeFromSuperlayer];
    _avplayer = nil;
    _player = nil;
}

#pragma mark - setter

- (void)setShowTime:(BOOL)showTime {
    _showTime = showTime;
    _slider.hidden = !showTime;
    _currentTime.hidden = !showTime;
    _totalTime.hidden = !showTime;
    _playStatus.hidden = !showTime;
}

- (void)setVideoPath:(NSString *)videoPath {
    _videoPath = videoPath;
    [self p_walme_setPlayer];
}

#pragma mark - getter

- (AVPlayer *)player {
    if (!_player) {
        AVPlayerItem *playerItem = [self getPlayItem];
        _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        //    [[VideoManager shareManager] resetPreloadingWithMediaUrls:saveUrl];
    }
    return _player;
}

- (AVPlayerItem *)getPlayItem {
    NSURL *saveUrl;
    if (_videoPath.length > 0) {
        saveUrl = [NSURL URLWithString: _videoPath];
    } else {
        return nil;
    }
    [_player.currentItem removeObserver:self forKeyPath:@"status"];
    AVPlayerItem *playerItem;
    BOOL cached = [[VideoCache shareCache] isCacheCompletedWithUrl:saveUrl];
    
    if (_useVideoCache && cached) {
        playerItem = [_loader playItemWithUrl:saveUrl];
    }
    else {
        [[VideoManager shareManager] loadMediaWithUrl:saveUrl options:kNilOptions progress:nil completion:nil];
        [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        playerItem = [[AVPlayerItem alloc] initWithURL:saveUrl];
        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        _totalDuration = CMTimeGetSeconds(playerItem.asset.duration);
    }
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    return playerItem;
}

- (void)layoutSubviews {
    _avplayer.frame = self.bounds;
    CGSize statusSize = _playStatus.image.size;
    _playStatus.frame = (CGRect){(self.width - statusSize.width) / 2, (self.height - statusSize.height) / 2, statusSize};
    _currentTime.frame = (CGRect){20, self.height - 30, 40, 20};
    _totalTime.frame = (CGRect){self.width - 60, self.height - 30, 40, 20};
    _slider.frame = (CGRect){_currentTime.right + 10, 0, _totalTime.left - 20 - _currentTime.right, 3};
    _slider.centerY = _currentTime.centerY;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self p_commonInit];
    }
    return self;
}

- (void)p_commonInit {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[_player currentItem]];
    self.backgroundColor = [UIColor blackColor];
    
    [self p_walme_setView];
    _loader = [[VideoResourceLoader alloc] init];
//    __weak typeof(self) weakSelf = self;
//    _loader.loadFinishBlock = ^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        if (weakSelf) {
//            if (!weakSelf.loader.hasMoreLoadRequest) {
//                strongSelf->_avplayer = nil;
//                [weakSelf p_walme_setPlayer];
//            }
//        }
//    };
    _showTime = YES;
    _autoPlay = YES;
    _useVideoCache = YES;
}

- (void)dealloc {
    [self p_walme_releaseSub];
    NSLog(@"🤩🤩🤩WALMEvideoplayerView dealloc🤩🤩🤩");
}

@end
