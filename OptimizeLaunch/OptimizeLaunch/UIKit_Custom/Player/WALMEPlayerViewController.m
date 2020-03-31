//
//  WALMEPlayerViewController.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WALMEControllerHeader.h"
#import "WALMEViewmodelHeader.h"
#import "WALMEPlayerViewmodel.h"
#import "WALMEPlayerProgressView.h"
#import "WALMEVideoPlayerView.h"
#import "WALMEPlayerInfoDataSource.h"
//#import "UIViewController+WALME_Custom.h"

@interface WALMEPlayerViewController () {
    float _duration;
}

@property (nonatomic, strong) WALMEVideoPlayerView * playerView;

// 可以考虑将此改为转场动画效果
@property (nonatomic, strong) UIButton * closeBtn;

@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UILabel * signatureLabel;
@property (nonatomic, strong) UILabel * nameLabel;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (nonatomic, strong) UIButton * followBtn;

//@property (nonatomic, strong) UILabel * noteLabel;
//@property (nonatomic, strong) NSArray<UIButton *> * operationBtns;
//@property (nonatomic, strong) UIButton * operationBtn;

@property (nonatomic, assign) CGPoint panGestureBeginPoint;
//@property (nonatomic, strong) id<WALMEPlayerInfoDataSource> dataSource;

@end

@implementation WALMEPlayerViewController

- (instancetype)initWithDataSource:(id<WALMEPlayerInfoDataSource>)dataSource {
    self = [super init];
    if (!self) return nil;
    _dataSource = dataSource;
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_playerView pause];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_playerView pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self p_walme_setBg];
//    [self p_walme_setBgView];
    [self p_setNav];
    [self p_walme_setDataSource];
    [self p_walme_setPlayer];
    [self p_walme_setView];
    [self p_walme_checkNet];
    
    if (!_dataSource.canPlay) {
        [self p_walme_setBlurView];
    }
//    else {
//        if (_dataSource.videoPath) {
    _playerView.videoPath = _dataSource.videoPath;
//        }
//    }
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pausePlayer:)];
    [self.view addGestureRecognizer:tap];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPlayer:)];
    [self.view addGestureRecognizer:pan];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _playerView.frame = _playerView.superview.bounds;
    CGFloat left = 14, height = 106;
    _bottomView.frame = (CGRect){0, self.view.height - height, self.view.width, height};
    
    CGFloat avatarWidth = 28;
    _avatarImageView.frame = (CGRect){14, _bottomView.height - avatarWidth - left, avatarWidth, avatarWidth};
    [_nameLabel sizeToFit];
    _nameLabel.left = _avatarImageView.right + 10;
    _nameLabel.centerY = _avatarImageView.centerY;
    _followBtn.size = CGSizeMake(60, 28);
    _followBtn.right = _bottomView.width - 14;
    _followBtn.centerY = _avatarImageView.centerY;
    
    [_signatureLabel sizeToFit];
    _signatureLabel.left = 14;
    _signatureLabel.top = 10;
    _blurBgView.frame = self.view.bounds;
    _blurView.frame = _blurBgView.bounds;
//    _noteLabel.frame = CGRectMake(20 , 200, self.view.width - 20 * 2, 60);
//    _operationBtn.frame = (CGRect){0, _noteLabel.bottom + 100, 120, 40};
//    _operationBtn.centerX = self.view.width / 2;
}

#pragma mark - view init

- (void)p_walme_setDataSource {
    if (_dataSource) {
        __weak typeof(self) weakSelf = self;
        [_dataSource setRefreshBlock:^(BOOL needRefresh) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!weakSelf) return ;
            if (needRefresh) {
                if (weakSelf.dataSource.canPlay) {
                    [strongSelf->_blurBgView removeFromSuperview];
//                    [strongSelf->_noteLabel removeFromSuperview];
//                    [strongSelf->_operationBtn removeFromSuperview];
                } else {
                    [weakSelf.view addSubview:weakSelf.blurBgView];
//                    strongSelf->_noteLabel.text = weakSelf.dataSource.blurNote;
//                    [strongSelf->_operationBtn setTitle:weakSelf.dataSource.blurBtnTitle forState:UIControlStateNormal];
                }
                [weakSelf.view setNeedsLayout];
            }
        }];
    }
}

- (void)p_walme_setPlayer {
    _playerView = [[WALMEVideoPlayerView alloc] init];
    __weak typeof(self) weakSelf = self;
    _playerView.endBlock = ^{
        if (weakSelf.playendBlock) {
            weakSelf.playendBlock();
        }
        [weakSelf playerDidReachEnd];
    };
    [self.view addSubview:_playerView];
}

- (void)p_setNav {
    [self walme_setNavView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mine_back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(walme_close)];
}

- (void)p_walme_setView {
    [self.view addSubview:_closeBtn];
    if (!_dataSource.isSelf) {
        [self.bottomView addSubview:self.signatureLabel];
        [self.bottomView addSubview:self.avatarImageView];
        [self.bottomView addSubview:self.nameLabel];
        [self.bottomView addSubview:self.followBtn];
    }
}

- (void)p_walme_setBlurView {
    _blurBgView = ({
        UIView * view = [[UIView alloc] init];
        [self.view addSubview:view];
        view;
    });

    _blurView = ({
        UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectView.alpha = 0.98;
        [_blurBgView addSubview:effectView];
        effectView;
    });
    
//    _noteLabel = ({
//        UILabel * label = [WALMEViewHelper walme_labelWithFrame:CGRectZero
//                                                          title:_dataSource.blurNote
//                                                           font:[UIFont walme_PingFangMedium16]
//                                                      textColor:[UIColor whiteColor]];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.numberOfLines = 0;
//        [label sizeToFit];
//        [self.view addSubview:label];
//        label;
//    });
//
//    _operationBtn = ({
//        UIButton * button = [WALMEViewHelper walme_buttonWithFrame:CGRectZero
//                                                           bgImage:nil
//                                                             image:nil
//                                                             title:_dataSource.blurBtnTitle
//                                                         textColor:[UIColor whiteColor]
//                                                            method:@selector(p_walme_operation:)
//                                                            target:self];
//        button.titleLabel.font = [UIFont walme_PingFangMedium16];
//        button.layer.cornerRadius = 4;
//        button.backgroundColor = [UIColor walme_colorWithRGB:0xff6161];
//        [self.view addSubview:button];
//        button;
//    });
//    [self.view bringSubviewToFront:_closeBtn];
    [self playerSetBlurView];
}

- (void)p_walme_checkNet {
    if (![WALMENetWorkManager netReachable]) {
        //        [self showTextHUD:@"网络出小差" toView:self.view];
    }
}

#pragma mark - Touch event

- (void)panPlayer:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            if (_playerView.playing) {
                [self pausePlayer:nil];
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            CGPoint point = [pan translationInView:self.view];
            CGRect frame = _playerView.frame;
            frame.origin.y += point.y;
            _playerView.frame = frame;
//            CGFloat alpha = 1 - fabs(frame.origin.y) / 0 * 1.6;
            CGFloat scale = 1 - fabs(frame.origin.y / 0 / 2);
            
            _playerView.transform = CGAffineTransformMakeScale(scale, scale);
//            _coverImageView.alpha = alpha;
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if (fabs(_playerView.top) > 150) {
                [UIView animateWithDuration:0.3 animations:^{
                    _playerView.alpha = 0;
                    _playerView.top = _playerView.top > 0 ? 0 : -0;
                } completion:^(BOOL finished) {
                    [_playerView pause];
                    [self p_walme_close];
                }];
            } else {
                [self p_walme_rebackView];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled : {
            [self p_walme_rebackView];
        }
            break;
        default:
            break;
    }
    [pan setTranslation:CGPointZero inView:self.view];
}

- (void)p_walme_rebackView {
    [UIView animateWithDuration:0.3 animations:^{
//        _coverImageView.alpha = 1;
        _playerView.transform = CGAffineTransformMakeScale(1, 1);
        _playerView.origin = CGPointZero;
    }];
    
    [self pausePlayer:nil];
}

- (void)p_walme_operation:(UIButton *)sender {
    [_dataSource clickBlurOperation];
}

- (void)p_walme_follow:(UIButton *)sender {
    NSString * const myInfo = @"follow/follow";
    NSDictionary * parameters = @{
                                  @"to_userid" : _dataSource.userid,
                                  };
    [WALMENetWorkManager walme_post:myInfo withParameters:parameters success:^(id  _Nullable result) {
        NSUInteger follow = [result[@"data"][@"followStatus"] integerValue];
        BOOL followed = follow % 2 == 0;
        [_dataSource changeFollow:followed];
        [_followBtn setTitle:followed ? @"已关注" : @"关注" forState:UIControlStateNormal];
        _followBtn.backgroundColor = followed ? [UIColor walme_colorWithRGB:0xFFCBDA] : [UIColor walme_colorWithRGB:0xff6161];
    } failed:^(BOOL netReachable, NSString * _Nullable msg, id  _Nullable result) {
//        if (resultBlock) {
//            NSString * domain = @"com.banteaySrei.WALMENetWorkManager.netError";
//            NSString * desc = msg ? msg : WALMENetWorkErrorNoteString;
//            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : desc};
//            WALMENetRequestErrorType type = netReachable ? WALMENetRequestErrorTypeRequestFail : WALMENetRequestErrorTypeNetDisable;
//            NSError * error = [NSError errorWithDomain:domain code:type userInfo:userInfo];
//            resultBlock(error, YES);
//        }
    }];
}

#pragma mark - func method

- (void)playerDidReachEnd {
    
}

- (void)playerSetBlurView {
    
}

- (void)playVideo {
    [self.playerView play];
}

- (void)pasueVideo {
    [self.playerView pause];
}

- (void)pausePlayer:(UITapGestureRecognizer *)tap {
    _playerView.playing ? [_playerView pause] : [_playerView play];
}

- (NSString *)convert:(float)time{
    int minute = time / 60;
    int second = time - minute * 60;
    NSString *minuteString;
    NSString *secondString;
    
    if (minute < 10){
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

- (void)p_walme_close {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_playerView pause];
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:NO];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

- (void)walme_close {
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    [self setNavBarBgAlpha:1];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - lazy

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = ({
            UIButton * button = [WALMEViewHelper walme_buttonWithFrame:CGRectZero
                                                            bgImage:nil
                                                              image:@"mine_back_white"
                                                              title:nil
                                                          textColor:nil
                                                             method:@selector(p_walme_close)
                                                             target:self];
            button.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
            button;
        });
    }
    return _closeBtn;
}

- (UIButton *)followBtn {
    if (!_followBtn) {
        _followBtn = ({
            UIButton * button = [WALMEViewHelper walme_buttonWithFrame:CGRectZero
                                                               bgImage:nil
                                                                 image:nil
                                                                 title:@"关注"
                                                             textColor:nil
                                                                method:@selector(p_walme_follow:)
                                                                target:self];
            button.layer.cornerRadius = 14;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.backgroundColor = [UIColor walme_colorWithRGB:0xff80a4];
            button;
        });
    }
    return _followBtn;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel * label = [WALMEViewHelper walme_labelWithFrame:CGRectZero
                                                              title:_dataSource.nickname
                                                               font:[UIFont walme_PingFangMedium18]
                                                          textColor:[UIColor whiteColor]];
            [label sizeToFit];
            label;
        });
    }
    return _nameLabel;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = ({
            UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar"]];
//            [imageView sd_setImageWithURL:_dataSource.avatarUrl];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.cornerRadius = 14;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
    }
    return _avatarImageView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

- (UILabel *)signatureLabel {
    if (!_signatureLabel) {
        _signatureLabel = ({
            UILabel * label = [WALMEViewHelper walme_labelWithFrame:CGRectZero
                                                              title:_dataSource.selfDesc
                                                               font:[UIFont systemFontOfSize:14]
                                                          textColor:[UIColor whiteColor]];
            [label sizeToFit];
            label.preferredMaxLayoutWidth = 0 - 28;
            label.textAlignment = NSTextAlignmentLeft;
//            [self.bottomView addSubview:label];
            label;
        });
    }
    return _signatureLabel;
}

- (void)dealloc {
    NSLog(@"🤩🤩🤩WALMEPlayerViewController dealloc🤩🤩🤩");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
