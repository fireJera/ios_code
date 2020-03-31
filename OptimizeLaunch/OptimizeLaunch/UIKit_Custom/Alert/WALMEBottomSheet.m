//
//  WALMEBottomSheet.m
//  CodeFrame
//
//  Created by hd on 2019/4/9.
//  Copyright © 2019年 JersiZhu. All rights reserved.
//

#import "WALMEBottomSheet.h"
#import "WALMEViewHeader.h"

@interface WALMEBottomSheet () {
    CGFloat _itemHeight;
    CGFloat _backButtonTopSpacing;
    CGFloat _itemSpacing;
}

@property (nonatomic, strong) UIView* containerView;
@property (nonatomic, strong) NSArray* titleArray;
@property (nonatomic, strong) NSMutableArray<UIButton*>* btnArray;
@property (nonatomic, strong) NSMutableArray<UIView*>* sepaLineArray;
@property (nonatomic, strong) UIButton* backBtn;

@end

@implementation WALMEBottomSheet
//+ (instancetype)walme_bottomSheetWithTitleArray:(NSArray*)titleArray delegate:(id<WALMEBottomSheetDelegate>)delegate{
//    WALMEBottomSheet* sheet = [[WALMEBottomSheet alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    [sheet walme_updateWithTitleArray:titleArray];
//    sheet.delegate = delegate;
//    return sheet;
//}

+ (instancetype)walme_bottomSheetWithTitleArray:(NSArray*)titleArray block:(void(^)(NSInteger index))block{
    WALMEBottomSheet* sheet = [[WALMEBottomSheet alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [sheet walme_updateWithTitleArray:titleArray];
    sheet.clickBlock = block;
    return sheet;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = kColorWithRGBAlpah(0x000000, 0.2);
    _itemHeight = 50;
    _backButtonTopSpacing = 8;
    _itemSpacing = 1;
    [self addSubview:self.containerView];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    BOOL show = self.containerView.bottom = self.height;
    CGFloat bottomHeight;
//    = kIphoneXBottomHeight;
    self.containerView.height = (self.titleArray.count + 1) * _itemHeight + _backButtonTopSpacing + (self.titleArray.count - 1) * 1 + bottomHeight;
    if (show) {
        self.containerView.bottom = self.height;
    }
    self.containerView.width = self.width;
    
    CGFloat top = self.containerView.height - _itemHeight - bottomHeight;
    self.backBtn.frame = CGRectMake(0, top, self.containerView.width, _itemHeight);
    top = top - (_backButtonTopSpacing + _itemHeight);
    for (int i = 0; i < self.titleArray.count; i ++) {
        int index = (int)(self.titleArray.count - i - 1);
        self.btnArray[index].frame = CGRectMake(0, top, self.containerView.width, _itemHeight);
        self.sepaLineArray[index].frame = CGRectMake(0, self.btnArray[index].bottom - _itemSpacing, self.containerView.width, _itemSpacing);
        top = top - (_itemHeight + _itemSpacing);
    }
}


#pragma mark - Private Mehtod

- (void)walme_updateWithTitleArray:(NSArray*)titleArray {
    self.titleArray = titleArray;
    
    self.containerView.height = (self.titleArray.count + 1) * _itemHeight + _backButtonTopSpacing + (self.titleArray.count - 1) * 1;
    
    UIColor *titleColor = kColorWithRGB(0x212121);
    UIFont *titleFont = [UIFont systemFontOfSize:15];//PFSCRegular(16)
    UIColor *sepaColor = kColorWithRGB(0xf2f2f2);
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton* tempBtn;
        UIView* sepaLine;
        if (i < self.btnArray.count) {
            tempBtn = self.btnArray[i];
            sepaLine = self.sepaLineArray[i];
        }
        else {
            tempBtn = [[UIButton alloc] init];
            tempBtn.titleLabel.font = titleFont;
            
            [tempBtn setTitleColor:titleColor forState:UIControlStateNormal];
            [self.btnArray addObject:tempBtn];
            
            sepaLine = [[UIView alloc] init];
            sepaLine.backgroundColor = sepaColor;
            [self.sepaLineArray addObject:sepaLine];
        }
        tempBtn.backgroundColor = [UIColor whiteColor];
        [tempBtn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        tempBtn.tag = i;
        [tempBtn addTarget:self action:@selector(walme_sheetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:tempBtn];
        
        [self.containerView addSubview:sepaLine];
    }
    for (NSInteger i = self.titleArray.count; i < self.btnArray.count; i ++) {
        [self.btnArray[i] removeFromSuperview];
        [self.sepaLineArray[i] removeFromSuperview];
    }
}

- (void)walme_show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.top = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.bottom = self.height;
    }];
}

- (void)walme_hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.top = self.height;
    } completion:^(BOOL finished) {
        self.top = 0;
        [self removeFromSuperview];
    }];
}

- (void)walme_sheetButtonClicked:(UIButton*)sender {
    [self walme_hide];
//    if ([self.delegate respondsToSelector:@selector(walme_clickSheetAtIndex:)]) {
//        [self.delegate walme_clickSheetAtIndex:sender.tag];
//    }
    if (self.clickBlock) {
        self.clickBlock(sender.tag);
    }
}

#pragma mark - Getter
- (NSMutableArray *)btnArray {
    if (_btnArray == nil) {
        _btnArray = [[NSMutableArray alloc] init];
    }
    return _btnArray;
}

-(NSMutableArray<UIView *> *)sepaLineArray {
    if (_sepaLineArray == nil) {
        _sepaLineArray = [NSMutableArray array];
    }
    return _sepaLineArray;
}

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.backgroundColor = [UIColor whiteColor];
        [_backBtn setTitle:@"取消" forState:UIControlStateNormal];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:15];//PFSCRegular(16)
        [_backBtn setTitleColor:kColorWithRGB(0x7f7f7f) forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(walme_hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = kColorWithRGB(0xf2f2f2);
        _containerView.top = self.height;
        [_containerView addSubview:self.backBtn];
    }
    return _containerView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self walme_hide];
}

@end
