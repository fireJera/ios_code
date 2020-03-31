//
//  WALMEVoicePlayerControl.m
//  CodeFrame
//
//  Created by Jeremy on 2019/6/3.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEVoicePlayerControl.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface WALMEVoicePlayerControl () <AVAudioPlayerDelegate>

@property (readwrite) BOOL playing;
@property (nonatomic, strong) AVAudioPlayer * voicePlayer;
@property (nonatomic, strong) AVPlayer * netVoicePlayer;
@property (nonatomic, strong) NSError * error;

@end

@implementation WALMEVoicePlayerControl

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    _playing = NO;
    _autoChange = YES;
    _netVoiceURL = nil;
    _localVoiceURL = nil;
    _voiceData = nil;
    
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    return self;
}

- (void)setNetVoiceURL:(NSString *)netVoiceURL {
    if (netVoiceURL) {
        _netVoiceURL = netVoiceURL;
        _localVoiceURL = nil;
        _voiceData = nil;
    }
    [self p_walme_createPlayer];
}

- (void)setLocalVoiceURL:(NSString *)localVoiceURL {
    if (localVoiceURL) {
        _localVoiceURL = localVoiceURL;
        _netVoiceURL = nil;
        _voiceData = nil;
    }
    [self p_walme_createPlayer];
}

- (void)setVoiceData:(NSData *)voiceData {
    if (voiceData) {
        _voiceData = voiceData;
        _localVoiceURL = nil;
        _netVoiceURL = nil;
    }
    [self p_walme_createPlayer];
}

- (void)setNumberOfLoops:(NSInteger)numberOfLoops {
    _numberOfLoops = numberOfLoops;
    if (_voicePlayer) {
        _voicePlayer.numberOfLoops = numberOfLoops;
    }
}
- (void)setAutoChange:(BOOL)autoChange {
    _autoChange = autoChange;
    if (_autoChange) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:)
                                                     name:@"UIDeviceProximityStateDidChangeNotification"
                                                   object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
}

- (void)p_walme_createPlayer {
    NSError * error;
    if (_voiceData) {
        _voicePlayer = [[AVAudioPlayer alloc] initWithData:_voiceData error:&error];
        [self p_walme_remove];
    }
    else if (_localVoiceURL) {
        _voicePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_localVoiceURL] error:&error];
        [self p_walme_remove];
    }
    else if (_netVoiceURL) {
        _voicePlayer = nil;
        [self p_walme_remove];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_netVoicePlayer.currentItem];
        [_netVoicePlayer.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    }
    _error = error;
    if (_voicePlayer) {
        _voicePlayer.delegate = self;
        _voicePlayer.numberOfLoops = _numberOfLoops;
        [_voicePlayer prepareToPlay];
    }
}

- (void)startPlay {
    if (_playing) return;
    
    if (_error) {
        if (_endBlock) {
            _endBlock(_error);
        }
        return;
    }
    _playing = YES;
    if (_voicePlayer) {
        [_voicePlayer play];
    }
    else if (_netVoicePlayer) {
        [_netVoicePlayer play];
    }
}

- (void)pausePlay {
    _playing = NO;
    if (_voicePlayer) {
        [_voicePlayer pause];
    }
    else if (_netVoicePlayer) {
        [_netVoicePlayer pause];
    }
}

- (void)stopPlay {
    _playing = NO;
    if (_voicePlayer) {
        [_voicePlayer stop];
    }
    else if (_netVoicePlayer) {
        [_netVoicePlayer play];
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    _playing = NO;
    if (_endBlock) {
        _endBlock(nil);
    }
}

#pragma mark - notification

- (void)playerFinished:(NSNotification *)notice {
    _playing = NO;
    if (_endBlock) {
        _endBlock(nil);
    }
}

- (void)sensorStateChange:(NSNotification *)notification {
    if ([UIDevice currentDevice].proximityState == YES) {
//        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
//        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

#pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        switch (_netVoicePlayer.status) {
            case AVPlayerStatusUnknown:
                _playing = NO;
                break;
            case AVPlayerStatusReadyToPlay:
                break;
            case AVPlayerStatusFailed: {
                NSString * domain = @"com.banteaySrei.WALMEVoicePlayerControl.netPlayerError";
                NSString * desc = @"加载失败，网络或者服务器出现问题";
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : desc};
                _error = [NSError errorWithDomain:domain code:-1111 userInfo:userInfo];
                [self playerFinished:nil];
            }
                break;
        }
    }
}

- (void)p_walme_remove {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_netVoicePlayer.currentItem];
    [_netVoicePlayer removeObserver:self forKeyPath:@"status"];
    _netVoicePlayer = nil;
}

- (void)dealloc {
    [self p_walme_remove];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
}

@end
