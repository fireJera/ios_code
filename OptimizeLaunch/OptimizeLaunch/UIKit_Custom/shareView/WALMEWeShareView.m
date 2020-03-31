//
//  WALMEWeShareView.m
//  LetDate
//
//  Created by Jeremy on 2019/3/12.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

#import "WALMEWeShareView.h"
#import "WALMENetWorkManager.h"
#import "WALMEUser.h"
#import "WALMEViewHelper.h"
#import "UIFont+WALME_Custom.h"

@interface WALMEWeShareView ()
@property (nonatomic, strong) UIView *visualView;
@end

@implementation WALMEWeShareView {
    NSDictionary *_data;
    NSUInteger _maleCount;
    NSUInteger _femaleCount;
    NSUInteger _otherCount;
}

- (instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dictionary {
    if (self = [super initWithFrame:frame]) {
        _data = dictionary;
        [self setBackgroundColor:[UIColor clearColor]];
        [self addVisualViewWithFrame:frame];
    }
    return self;
}

- (void)updateShareCount:(NSInteger)tag {
    NSInteger btnTag = tag + 1010;
    if (_firstBtn.tag == btnTag) {
        _maleCount += 1;
        [_firstCount setText:[NSString stringWithFormat:@"x%lu", (unsigned long)_maleCount]];
    }else if (_secondBtn.tag == btnTag) {
        _femaleCount += 1;
        [_secondCount setText:[NSString stringWithFormat:@"x%lu", (unsigned long)_femaleCount]];
    }else if (_thirdBtn.tag == btnTag) {
        _otherCount += 1;
        [_thirdCount setText:[NSString stringWithFormat:@"x%lu", (unsigned long)_otherCount]];
    }
    NSString * appName = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
    [_titleLabel setText:[NSString stringWithFormat:@"集齐这些朋友（%d/3）\n才能进入%@", (int)(_maleCount+_femaleCount+_otherCount), appName]];
    [self.disappearBtn setHidden:NO];
}

- (void)addVisualViewWithFrame:(CGRect)frame {
    _visualView = [[UIView alloc] init];
    _visualView.frame = self.bounds;
    _visualView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.91];
    [self addSubview:_visualView];
    
    _titleLabel = [WALMEViewHelper walme_labelWithFrame:CGRectZero
                                                  title:@"集齐这些朋友（0/3）\n才能进入欢游"
                                                   font:[UIFont walme_PingFangSemboldWithSize:29]
                                              textColor:[UIColor blackColor]];
    
    [_titleLabel setNumberOfLines:2];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_visualView addSubview:_titleLabel];
    // 高分男
    _firstBtn = ({
        UIButton *inviteMaleIV = [UIButton buttonWithType:UIButtonTypeCustom];
        [inviteMaleIV setBackgroundImage:[UIImage imageNamed:@"walme_share_1"] forState:UIControlStateNormal];
        inviteMaleIV.adjustsImageWhenHighlighted = NO;
        inviteMaleIV.tag = 1011;
        [_visualView addSubview:inviteMaleIV];
        inviteMaleIV;
    });
    
    NSString *nickName = [NSString stringWithFormat:@"%@ 眼中的", WALMEINSTANCE_USER.nickname];
    _firstTitle = [WALMEViewHelper walme_labelWithFrame:CGRectZero title:nickName
                                                   font:[UIFont walme_PingFangSemboldWithSize:20]
                                              textColor:[UIColor blackColor]];
    [_firstBtn addSubview:_firstTitle];
    
    _firstAim =  [WALMEViewHelper walme_labelWithFrame:CGRectZero
                                                 title:_data[@"boyDesc"]
                                                  font:[UIFont walme_PingFangSemboldWithSize:24]
                                             textColor:[UIColor blackColor]];
    [_firstBtn addSubview:_firstAim];
    
    _firstIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"walme_share_4"]];
    [_firstBtn addSubview:_firstIcon];
    _firstCount = [WALMEViewHelper walme_labelWithFrame:CGRectZero
                                                  title:@"x0"
                                                   font:[UIFont walme_PingFangSemboldWithSize:20]
                                              textColor:[UIColor blackColor]];
    [_firstBtn addSubview:_firstCount];
    
    _firstAdd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"walme_share_7"]];
    [_firstBtn addSubview:_firstAdd];
    
    // 美女
    _secondBtn = ({
        UIButton *inviteFemaleIV = [UIButton buttonWithType:UIButtonTypeCustom];
        [inviteFemaleIV setBackgroundImage:[UIImage imageNamed:@"walme_share_2"] forState:UIControlStateNormal];
        inviteFemaleIV.adjustsImageWhenHighlighted = NO;
        inviteFemaleIV.tag = 1012;
        [_visualView addSubview:inviteFemaleIV];
        inviteFemaleIV;
    });
    
    _secondTitle = [WALMEViewHelper walme_labelWithFrame:CGRectZero
                                                   title:nickName
                                                    font:[UIFont walme_PingFangSemboldWithSize:20]
                                               textColor:[UIColor blackColor]];
    [_secondBtn addSubview:_secondTitle];
    _secondAim = [WALMEViewHelper walme_labelWithFrame:CGRectZero
                                                 title:_data[@"girlDesc"]
                                                  font:[UIFont walme_PingFangSemboldWithSize:24]
                                             textColor:[UIColor blackColor]];
    
    [_secondBtn addSubview:_secondAim];
    _secondIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"walme_share_5"]];
    [_secondBtn addSubview:_secondIcon];
    _secondCount = [WALMEViewHelper walme_labelWithFrame:CGRectZero
                                                   title:@"x0"
                                                    font:[UIFont walme_PingFangSemboldWithSize:20]
                                               textColor:[UIColor blackColor]];
    
    [_secondBtn addSubview:_secondCount];
    
    _secondAdd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"walme_share_7"]];
    [_secondBtn addSubview:_secondAdd];
    
    // 其他朋友
    _thirdBtn = ({
        UIButton *inviteOtherIV = [UIButton buttonWithType:UIButtonTypeCustom];
        inviteOtherIV.adjustsImageWhenHighlighted = NO;
        inviteOtherIV.tag = 1013;
        [inviteOtherIV setBackgroundImage:[UIImage imageNamed:@"walme_share_3"] forState:UIControlStateNormal];
        [_visualView addSubview:inviteOtherIV];
        inviteOtherIV;
    });
    _thirdTitle = [WALMEViewHelper walme_labelWithFrame:CGRectZero
                                                  title:nickName
                                                   font:[UIFont walme_PingFangSemboldWithSize:20]
                                              textColor:[UIColor blackColor]];
    [_thirdBtn addSubview:_thirdTitle];
    _thirdAim = [WALMEViewHelper walme_labelWithFrame:CGRectZero
                                                title:_data[@"otherDesc"]
                                                 font:[UIFont walme_PingFangSemboldWithSize:24]
                                            textColor:[UIColor blackColor]];
    [_thirdBtn addSubview:_thirdAim];
    _thirdIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"walme_share_6"]];
    [_thirdBtn addSubview:_thirdIcon];
    _thirdCount = [WALMEViewHelper walme_labelWithFrame:CGRectZero
                                                  title:@"x0"
                                                   font:[UIFont walme_PingFangSemboldWithSize:20]
                                              textColor:[UIColor blackColor]];
    [_thirdBtn addSubview:_thirdCount];
    
    _thirdAdd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"walme_share_7"]];
    [_thirdBtn addSubview:_thirdAdd];
    
    _disappearBtn = ({
        UIButton *disappearBtn = [WALMEViewHelper walme_buttonWithFrame:CGRectZero
                                                                bgImage:@"walme_share_8"
                                                                  image:nil
                                                                  title:nil
                                                              textColor:nil
                                                                 method:NULL
                                                                 target:nil];
        [_visualView addSubview:disappearBtn];
        disappearBtn.hidden = YES;;
        disappearBtn;
    });
    [self walme_add_constraints];
}

- (void)walme_add_constraints {
    CGFloat top = 45;
//    if (WALME_IS_IPHONEXORLATER) {
//        top = 88;
//    }
    
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_visualView).with.offset(top);
//        make.centerX.equalTo(_visualView);
//    }];
    
    CGFloat titleTop = 18, titleLeft = 75, addRight = 35, addLeft = -15, iconBottom = -9;
    CGFloat space = 60, titleRight = -15;
    if (0 == 320) {
        space = 15;
    }
//    [_firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_titleLabel.mas_bottom).with.offset(space);
//        make.centerX.equalTo(_visualView);
//        make.size.mas_equalTo(CGSizeMake(315, 123));
//    }];
//
//    [_firstTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(titleLeft);
//        make.top.mas_equalTo(titleTop);
//        make.right.mas_lessThanOrEqualTo(_firstBtn.mas_right).with.offset(titleRight);
//    }];
//    
//    [_firstAim mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_firstTitle);
//        make.top.equalTo(_firstTitle.mas_bottom).with.offset(0);
//        make.right.lessThanOrEqualTo(_thirdIcon).with.offset(titleRight);
//    }];
//    
//    [_firstAdd mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_firstBtn).with.offset(-addRight);
//        make.centerY.equalTo(_firstIcon);
//    }];
//    [_firstCount mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_firstAdd.mas_left).with.offset(addLeft);
//        make.centerY.equalTo(_firstIcon);
//    }];
//    [_firstIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_firstBtn).with.offset(iconBottom);
//        make.right.equalTo(_firstCount.mas_left).with.offset(0);
//    }];
//    
//    //second
//    [_secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_firstBtn.mas_bottom).with.offset(22);
//        make.centerX.equalTo(_visualView);
//        make.size.mas_equalTo(CGSizeMake(315, 123));
//    }];
//    
//    [_secondTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(titleLeft);
//        make.top.mas_equalTo(titleTop);
//        make.right.mas_lessThanOrEqualTo(_secondBtn).with.offset(titleRight);
//    }];
//    [_secondAim mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_secondTitle);
//        make.top.equalTo(_secondTitle.mas_bottom).with.offset(0);
//        make.right.lessThanOrEqualTo(_thirdIcon).with.offset(titleRight);
//    }];
//    [_secondAdd mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_secondBtn).with.offset(-addRight);
//        make.centerY.equalTo(_secondCount);
//    }];
//    [_secondCount mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_secondAdd.mas_left).with.offset(addLeft);
//        make.centerY.equalTo(_secondIcon);
//    }];
//    [_secondIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_secondBtn).with.offset(iconBottom);
//        make.right.equalTo(_secondCount.mas_left).with.offset(0);
//    }];
//    
//    [_thirdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_secondBtn.mas_bottom).with.offset(22);
//        make.centerX.equalTo(_visualView);
//        make.size.mas_equalTo(CGSizeMake(315, 123));
//    }];
//    
//    //third
//    [_thirdTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(titleLeft);
//        make.top.mas_equalTo(titleTop);
//        make.right.mas_lessThanOrEqualTo(_thirdBtn).with.offset(titleRight);
//    }];
//    [_thirdAim mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_thirdTitle);
//        make.top.equalTo(_thirdTitle.mas_bottom).with.offset(0);
//        make.right.lessThanOrEqualTo(_thirdIcon).with.offset(titleRight);
//    }];
//    [_thirdAdd mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_firstBtn).with.offset(-addRight);
//        make.centerY.equalTo(_thirdCount);
//    }];
//    [_thirdCount mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_thirdAdd.mas_left).with.offset(addLeft);
//        make.centerY.equalTo(_thirdIcon);
//    }];
//    [_thirdIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_thirdBtn).with.offset(iconBottom);
//        make.right.equalTo(_thirdCount.mas_left).with.offset(0);
//    }];
//    CGFloat bottomSpace = -25;
//    if (0 == 320) {
//        bottomSpace = 0;
//    }
//    [_disappearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_visualView);
//        make.bottom.equalTo(_visualView.mas_bottom).with.offset(bottomSpace);
//    }];
}

@end
