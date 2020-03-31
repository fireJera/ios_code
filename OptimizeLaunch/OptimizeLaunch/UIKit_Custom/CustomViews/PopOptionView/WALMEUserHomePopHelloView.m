//
//  WALMEUserHomePopHelloView.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/25.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEUserHomePopHelloView.h"
#import "WALMEViewHeader.h"
#import "NSArray+WALME_Custom.h"

static const int kShowNum = 5;

@interface WALMEUserHomePopHelloView () {
    NSInteger _pageIndex;
    NSArray * _array;
}

@end

@implementation WALMEUserHomePopHelloView

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentView.left = 66;
    _contentView.width = self.width - 66 * 2;
    
    _titleLabel.frame = (CGRect){14, 10, _titleLabel.width, _titleLabel.height};
    _refreshBtn.frame = (CGRect){_contentView.width - 30 - 10, 10, 30, 30};
    _refreshBtn.centerY = _titleLabel.centerY;
    _lineLayer.frame = (CGRect){14, 40, _contentView.width - 14 * 2, 1};
    
    __block CGFloat left = 14;
    __block CGFloat top = 51;
    CGFloat maxWidth = _contentView.width - left * 2;
    __block CGFloat contentHeight = top;
    CGFloat horizon = 14, vertical = 14;
    [_textBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!button.hidden) {
            CGSize textSize = [button.titleLabel.text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            textSize.width = MIN(textSize.width + 24, maxWidth);
            textSize.height += 14;
            button.size = textSize;
            if (left * 2 + button.width > _contentView.width) {
                top = contentHeight + vertical;
                left = 14;
            }
            button.left = left;
            button.top = top;
            left += button.width + horizon;
            contentHeight = button.bottom;
        } else {
            button.frame = CGRectZero;
        }
    }];
    
    _contentView.height = contentHeight + 20;
    _contentView.top = (self.height - _contentView.height) / 2;
}

#pragma mark - touch event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self p_walme_close];
}

- (void)p_walme_close {
    if ([_delegate respondsToSelector:@selector(walme_popHelloViewClose:)]) {
        [_delegate walme_popHelloViewClose:self];
    }
    [self removeFromSuperview];
}

- (void)p_walme_refresh:(UIButton *)sender {
    NSInteger totalPage = ceil(_optionStrings.count / 5.0);
    NSInteger fromIndex = _pageIndex * kShowNum;
    NSInteger toIndex = (_pageIndex + 1) * kShowNum;
    toIndex = MIN(toIndex, _optionStrings.count);
    NSInteger length = toIndex - fromIndex;
    _array = [_optionStrings subarrayWithRange:NSMakeRange(fromIndex, length)];
    [_textBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * str = [_array objectOrNilAtIndex:idx];
        [obj setTitle:str forState:UIControlStateNormal];
        obj.hidden = str.length == 0;
    }];
    [self setNeedsLayout];
    _pageIndex++;
    _pageIndex = _pageIndex % totalPage;
}

- (void)p_walme_clickText:(UIButton *)sender {
    NSInteger tag = sender.tag;
    NSString * str = [_optionStrings objectOrNilAtIndex:tag];
    if ([_delegate respondsToSelector:@selector(walme_popHelloViewDidSelected:selectedIndex:string:)]) {
        [_delegate walme_popHelloViewDidSelected:self selectedIndex:tag string:str];
    }
}

- (void)setOptionStrings:(NSArray *)optionStrings {
    _optionStrings = optionStrings;
    [self p_walme_refresh:_refreshBtn];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_walme_init];
    }
    return self;
}

- (void)p_walme_init {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _pageIndex = 0;
    _textBtns = [NSMutableArray array];
    _contentView = ({
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 8;
        [self addSubview:view];
        view;
    });
    
    _titleLabel = ({
        UILabel * label = [WALMEViewHelper walme_labelWithFrame:CGRectZero
                                                          title:@"选择一条搭讪语"
                                                       fontSize:14
                                                      textColor:[UIColor walme_colorWithRGB:0x212121]];
        [label sizeToFit];
        [_contentView addSubview:label];
        label;
    });
    
    _refreshBtn = ({
        UIButton * button = [WALMEViewHelper walme_buttonWithFrame:CGRectZero
                                                           bgImage:nil
                                                             image:@"walme_my_24"
                                                             title:nil
                                                         textColor:nil
                                                            method:@selector(p_walme_refresh:)
                                                            target:self];
        [_contentView addSubview:button];
        button;
    });
    
    _lineLayer = [CALayer layer];
    _lineLayer.backgroundColor = [UIColor walme_colorWithRGB:0xf2f2f2].CGColor;
    [_contentView.layer addSublayer:_lineLayer];
    
    for (int i = 0; i < kShowNum; i++) {
        UIButton * btn = ({
            UIButton * button = [WALMEViewHelper walme_buttonWithFrame:CGRectZero
                                                               bgImage:nil
                                                                 image:nil
                                                                 title:nil
                                                             textColor:[UIColor whiteColor]
                                                                method:@selector(p_walme_clickText:)
                                                                target:self];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 6);
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.layer.cornerRadius = 4;
            button.backgroundColor = [UIColor walme_colorWithHexString:@"#8358D080"];
            button.titleLabel.lineBreakMode = 0;
            button.tag = i;
            [_contentView addSubview:button];
            button;
        });
        [_textBtns addObject:btn];
    }
}

@end
