//
//  WALMEWeShareView.h
//  LetDate
//
//  Created by Jeremy on 2019/3/12.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WALMEWeShareView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *disappearBtn;
@property (nonatomic, strong) UIButton *firstBtn;
@property (nonatomic, strong) UIButton *secondBtn;
@property (nonatomic, strong) UIButton *thirdBtn;

@property (nonatomic, strong) UILabel *firstTitle;
@property (nonatomic, strong) UILabel *secondTitle;
@property (nonatomic, strong) UILabel *thirdTitle;

@property (nonatomic, strong) UILabel *firstAim;
@property (nonatomic, strong) UILabel *secondAim;
@property (nonatomic, strong) UILabel *thirdAim;

@property (nonatomic, strong) UILabel *firstCount;
@property (nonatomic, strong) UILabel *secondCount;
@property (nonatomic, strong) UILabel *thirdCount;

@property (nonatomic, strong) UIImageView *firstIcon;
@property (nonatomic, strong) UIImageView *secondIcon;
@property (nonatomic, strong) UIImageView *thirdIcon;

@property (nonatomic, strong) UIImageView *firstAdd;
@property (nonatomic, strong) UIImageView *secondAdd;
@property (nonatomic, strong) UIImageView *thirdAdd;

@property (nonatomic, strong) NSDictionary * shareData;

- (void)updateShareCount:(NSInteger)tag;

- (instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
