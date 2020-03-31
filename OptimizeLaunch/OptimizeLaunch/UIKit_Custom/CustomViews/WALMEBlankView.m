//
//  WALMEBlankView.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEBlankView.h"
#import "WALMEViewHeader.h"

static const int kButtonHeight = 48;

//@interface WALMEBlankVisitorHeaderView ()
//
//@end
//
//@implementation WALMEBlankVisitorHeaderView
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    _leftBtn.frame = (CGRect){0, 20, 72, 72};
//    _centerBtn.frame = (CGRect){69, 0, 72, 72};
//    _rightBtn.frame = (CGRect){69 * 2, 20, 72, 72};
//}
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (!self) return nil;
//    [self p_walme_init];
//    return self;
//}
//
//- (void)p_walme_init {
//    _leftBtn = ({
//        UIButton * button = [WALMEViewHelper walme_buttonWithFrame:CGRectZero
//                                                           bgImage:nil
//                                                             image:@"walme_avatar"
//                                                             title:nil
//                                                         textColor:nil
//                                                            method:nil
//                                                            target:nil];
//        button.layer.cornerRadius = 36;
//        button.layer.masksToBounds = YES;
//        [self addSubview:button];
//        button;
//    });
//    
//    _centerBtn = ({
//        UIButton * button = [WALMEViewHelper walme_buttonWithFrame:CGRectZero
//                                                           bgImage:nil
//                                                             image:@"walme_avatar"
//                                                             title:nil
//                                                         textColor:nil
//                                                            method:nil
//                                                            target:nil];
//        button.layer.cornerRadius = 36;
//        button.layer.masksToBounds = YES;
//        [self addSubview:button];
//        button;
//    });
//    
//    _rightBtn = ({
//        UIButton * button = [WALMEViewHelper walme_buttonWithFrame:CGRectZero
//                                                           bgImage:nil
//                                                             image:@"walme_avatar"
//                                                             title:nil
//                                                         textColor:nil
//                                                            method:nil
//                                                            target:nil];
//        button.layer.cornerRadius = 36;
//        button.layer.masksToBounds = YES;
//        [self addSubview:button];
//        button;
//    });
//}
//
//@end

@interface WALMEBlankView ()

@property (nonatomic, strong) UIActivityIndicatorView * loadingView;

@end

@implementation WALMEBlankView

//- (void)p_walme_buttonClick:(UIButton *)sender {
//    if (_funcBlock) {
//        _funcBlock();
//    }
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    _blurView.frame = self.bounds;
}

- (void)setBlankType:(WALMEBlankViewType)blankType {
    _blankType = blankType;
    _blankImageView.image = [UIImage imageNamed:@"emptypic2"];
    _funcBtn.hidden = YES;
    _loadingView.hidden = YES;
    switch (blankType) {
        case WALMEBlankViewTypeNoVisitor: {
            //        _noteLabel.text = @"你暂时还没有访客";
        }
            break;
        case WALMEBlankViewTypeVisitorLock: {
            _blankImageView.image = [UIImage imageNamed:@"emptypic4"];
            //        _noteLabel.text = @"你暂时还没有收到搭讪，要主动哦";
//            self.visitorHeader.hidden = NO;
            _blankImageView.hidden = YES;
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        }
            break;
        case WALMEBlankViewTypeMessage: {
            _blankImageView.image = [UIImage imageNamed:@"message_emptypic"];
            _noteLabel.text = @"当前暂无消息， 先去逛逛吧~";
            _funcBtn.hidden = YES;
        }
            break;
        case WALMEBlankViewTypeBadNet: {
            _noteLabel.text = @"网络出错了，刷新一下试试吧";
            _funcBtn.hidden = NO;
            //        [_funcBtn setImage:[UIImage imageNamed:@"walme_match_12"] forState:UIControlStateNormal];
            [_funcBtn setTitle:@"刷新一下" forState:UIControlStateNormal];
//            _blankImageView.image = [UIImage imageNamed:@"walme_forall_3"];
        }
            break;
        case WALMEBlankViewTypeLoading: {
//            _blankImageView.image = [UIImage imageNamed:@"walme_forall_1"];
            _noteLabel.text = @"正在加载...";
            _noteLabel.textColor = [UIColor walme_colorWithRGB:0x4c4c4c];
            self.loadingView.alpha = 1;
            _loadingView.hidden = NO;
        }
            break;
        case WALMEBlankViewTypeBlank: {
            _noteLabel.text = @"现在还是空的哦";
        }
            break;
        case WALMEBlankViewTypeChatLock: {
            _noteLabel.text = @"";
            _blankImageView.image = [UIImage imageNamed:@"emptypic4"];
            _funcBtn.hidden = NO;
            [_funcBtn setTitle:@"解锁后查看" forState:UIControlStateNormal];
        }
        default:
            break;
    }
}

- (void)walme_addBlurView {
    if (!_blurView) {
        _blurView = ({
            UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
            effectView.frame = self.bounds;
            effectView.alpha = 0.9;
            effectView;
        });
    }
    [self addSubview:_blurView];
    [self sendSubviewToBack:_blurView];
//    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
}

- (void)walme_removeBlurView {
    [_blurView removeFromSuperview];
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _loadingView.backgroundColor = [UIColor walme_colorWithRGB:0xf7f7f7];
        _loadingView.color = [UIColor walme_colorWithRGB:0x4c4c4c];
        [self addSubview:_loadingView];
//        [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.noteLabel.mas_right).with.offset(10);
//            make.centerY.equalTo(self.noteLabel.mas_centerY);
//        }];
        [_loadingView startAnimating];
    }
    return _loadingView;
}

//- (WALMEBlankVisitorHeaderView *)visitorHeader {
//    if (!_visitorHeader) {
//        _visitorHeader = [[WALMEBlankVisitorHeaderView alloc] init];
//        _visitorHeader.hidden = YES;
//        [self addSubview:_visitorHeader];
//
//        [_visitorHeader mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).with.offset(60);
//            make.centerX.equalTo(self);
//            make.size.mas_equalTo(CGSizeMake(210, 92));
//        }];
//    }
//    return _visitorHeader;
//}

#pragma mark -  init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self p_walme_initView];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (!self) return nil;
    [self p_walme_initView];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)p_walme_initView {
//    self.backgroundColor = [UIColor walme_colorWithRGB:0xf3f6fb];
    _blankImageView = [WALMEViewHelper imageViewWithFrame:CGRectZero imageName:nil];
    [self addSubview:_blankImageView];
    _noteLabel = ({
        UILabel * label = [WALMEViewHelper walme_labelWithFrame:CGRectZero title:@"" fontSize:15 textColor:[UIColor whiteColor]];
        label.font = [UIFont systemFontOfSize:16];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        label;
    });
    
    _funcBtn = ({
//        UIButton * button = [WALMEViewHelper walme_buttonWithFrame:CGRectZero bgImage:nil image:nil title:@"刷新" textColor:[UIColor whiteColor] method:@selector(p_walme_buttonClick:) target:self];
        UIButton * button = [WALMEViewHelper walme_buttonWithFrame:CGRectZero bgImage:nil image:nil title:@"刷新" textColor:[UIColor whiteColor] method:nil target:nil];
        button.layer.cornerRadius = 4;
        button.backgroundColor = [UIColor walme_colorWithRGB:0x8358d0 alpha:0.9];
        button.titleLabel.font = [UIFont walme_PingFangMedium18];
        [self addSubview:button];
        button;
    });
    self.blankType = WALMEBlankViewTypeBlank;
    [self p_walme_addContraints];
}

- (void)p_walme_addContraints {
    int kTopInterval = 160;
//    [_blankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.top.equalTo(self).with.offset(kTopInterval);
//    }];
//    int kHorizonInterval = 40;
//    [_noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.greaterThanOrEqualTo(self).with.offset(20);
//        make.centerX.equalTo(self);
//        make.top.equalTo(self.blankImageView.mas_bottom).with.offset(kHorizonInterval);
//    }];
//    
//    int kButtonWidth = 120;
////    [_funcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//////        make.left.equalTo(self).with.offset(49);
////        make.centerX.equalTo(self);
////        make.bottom.equalTo(self).with.offset(-80);
////        make.height.mas_equalTo(kButtonHeight);
////        make.width.mas_equalTo(kButtonWidth);
////    }];
//    [_funcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).with.offset(49);
//        make.right.equalTo(self).with.offset(-49);
//        make.bottom.equalTo(self).with.offset(-80);
//        make.height.mas_equalTo(kButtonHeight);
//        make.width.mas_greaterThanOrEqualTo(kButtonWidth);
//    }];
}

@end
