//
//  WALMEUploadExample.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEUploadExampleView.h"
#import "WALMEViewmodelHeader.h"
#import "WALMEViewHeader.h"
#import <objc/runtime.h>

static void * kLeftBlockRuntimeKey = "LeftBlockRuntimeKey";
static void * kRightBlockRuntimeKey = "RightBlockRuntimeKey";

static const int kInitHeight = 140;
static const int kNoteHeight = 30;
static const int kExampleHeight = 150;
static const int kLeft = 16;
static const int kRowPerNum = 4;


@implementation WALMEUploadComponentExampleModel

@end

@implementation WALMEUploadComponentExampleView

- (instancetype)initWithModel:(WALMEUploadComponentExampleModel *)model {
    if (self = [super init]) {
        _model = model;
        [self p_walme_initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_walme_initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self p_walme_initView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self p_walme_initView];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _templateImage.frame = CGRectMake(0, 0, self.width, self.width);
    
    _rightImage.top = _templateImage.bottom + 10;
    _rightImage.centerX = _templateImage.width / 2;
    
    _noteLabel.frame = CGRectMake(0, _rightImage.bottom + 5, self.width, 20);
    _noteLabel.centerX = _templateImage.width / 2;
}

- (void)p_walme_initView {
    _templateImage = [WALMEViewHelper imageViewWithFrame:CGRectZero image:nil];
//    [_templateImage sd_setImageWithURL:[NSURL URLWithString:_model.image]];
    _templateImage.backgroundColor = [UIColor walme_colorWithRGB:0xf7f7f7];
    [self addSubview:_templateImage];
    
    UIImage * rightImage = [UIImage imageNamed:_model.isCorrect ? @"walme_forall_6" : @"walme_forall_7"];
    _rightImage = [WALMEViewHelper imageViewWithFrame:CGRectMake(0, 0, rightImage.size.width, rightImage.size.height) image:rightImage];
    [self addSubview:_rightImage];
    
    _noteLabel = [WALMEViewHelper walme_labelWithFrame:CGRectZero title:_model.desc fontSize:12 textColor:[UIColor walme_colorWithRGB:0x212121]];
    _noteLabel.textAlignment = NSTextAlignmentCenter;
    _noteLabel.font = [UIFont walme_PingFangMedium12];
    [self addSubview:_noteLabel];
}

@end

#pragma mark - markWALMEUploadComponentExampleView

@interface WALMEUploadExampleView () {
    NSMutableArray<UILabel *> * _notes;
    NSMutableArray<WALMEUploadComponentExampleView *> * _exampleViews;
}

@property (nonatomic, strong) UIView * contentFace;

@end

@implementation WALMEUploadExampleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self p_walme_initView];
    }
    return self;
}



- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self p_walme_initView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self p_walme_initView];
    }
    
    return self;
}

#pragma mark - setter


- (void)configWithBtns:(NSArray *)btns
            dictionary:(NSDictionary *)dic
           leftHandler:(WALMEVoidBlock)leftHandler
          rightHandler:(WALMEVoidBlock)rightHandler {
//    if (IsDictionaryWithItems(dic)) {
//        NSString * title = dic[@"title"];
//        NSArray * notes = dic[@"descList"];
//        NSArray * exampleArray = dic[@"imageList"];
//        if (IsArrayWithItems(exampleArray)) {
//            NSMutableArray<WALMEUploadComponentExampleModel *> *examples = [NSMutableArray arrayWithCapacity:exampleArray.count];
//            for (NSDictionary * exampleDic in exampleArray) {
//                if (IsDictionaryWithItems(dic)) {
////                    WALMEUploadComponentExampleModel * model = [WALMEUploadComponentExampleModel yy_modelWithJSON:exampleDic];
////                    [examples addObject:model];
//                }
//                
//            }
//            [self configBtns:btns title:title notes:notes examples:examples leftHandler:leftHandler rightHandler:rightHandler];
//            return;
//        }
//        [self configBtns:btns title:title notes:notes examples:nil leftHandler:leftHandler rightHandler:rightHandler];
//    }
}

- (void)configBtns:(NSArray<NSString *> *)btns
             title:(NSString *)title
             notes:(NSArray<NSString *> *)notes
          examples:(nullable NSArray<WALMEUploadComponentExampleModel *> *)examples
       leftHandler:(WALMEVoidBlock)leftHandler
      rightHandler:(WALMEVoidBlock)rightHandler {
    
    _titleLabel.text = title;
    
//    if (IsArrayWithItems(notes)) {
//        _noteLabel.text = notes.firstObject;
//        _notes = [NSMutableArray arrayWithCapacity:notes.count];
//        for (int i = 1; i < notes.count; i++) {
//            UILabel * label = [WALMEViewHelper walme_labelWithFrame:CGRectZero
//                                                              title:notes[i]
//                                                           fontSize:13
//                                                          textColor:[UIColor walme_colorWithRGB:0x212121]];
//
//
//            label.font = [UIFont walme_PingFangMedium15];
//            [_contentFace addSubview:label];
//            [_notes addObject:label];
//        }
//    }
    
//    if (IsArrayWithItems(examples)) {
//        _exampleViews = [NSMutableArray arrayWithCapacity:notes.count];
//
//        [examples enumerateObjectsUsingBlock:^(WALMEUploadComponentExampleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            WALMEUploadComponentExampleView * view = [[WALMEUploadComponentExampleView alloc] initWithModel:obj];
//            [_contentFace addSubview:view];
//            [_exampleViews addObject:view];
//        }];
//    }
    
    int height = kInitHeight;
    height += MAX(0, notes.count - 1) * kNoteHeight;
    height += MAX(0, ceil(examples.count / 4.0)) * kExampleHeight;
    _contentFace.height = height;
    _contentFace.top = self.height - _contentFace.height;
    if (leftHandler) {
        objc_setAssociatedObject(self, kLeftBlockRuntimeKey, leftHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    if (rightHandler) {
        
        objc_setAssociatedObject(self, kRightBlockRuntimeKey, rightHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    [btns enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 2) {
            *stop = YES;
        }
        NSString * tempStr;
        if ([obj isEqualToString:@"camera"]) {
            tempStr = @"拍摄";
        } else if ([obj isEqualToString:@"choose"]) {
            tempStr = @"相册";
        }
        if (idx == 0) {
            [_cameraBtn setTitle:tempStr forState:UIControlStateNormal];
        } else {
            [_albumBtn setTitle:tempStr forState:UIControlStateNormal];
        }
    }];
}

#pragma mark - touch func
- (void)close:(UIButton *)sender {
    [self removeFromSuperview];
}

//right

- (void)album:(UIButton *)sender {
    WALMEVoidBlock block = objc_getAssociatedObject(self, kRightBlockRuntimeKey);
    if (block) {
        block();
    }
    [self removeFromSuperview];
}
//left

- (void)camera:(UIButton *)sender {
    WALMEVoidBlock block = objc_getAssociatedObject(self, kLeftBlockRuntimeKey);
    if (block) {
        block();
    }
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_shouldTouchClose) {
        CGPoint point = [[touches anyObject] locationInView:self];
        point = [_contentFace.layer convertPoint:point fromLayer:self.layer];
        if (![_contentFace.layer containsPoint:point]) {
            [self removeFromSuperview];
            
        }
    }
}

#pragma mark - layout view
- (void)layoutSubviews {
    [super layoutSubviews];
    _contentFace.left = 0;
    _contentFace.width = self.width;
    int width = self.width - kLeft * 2;
    
    _titleLabel.frame = CGRectMake(kLeft, 20, width - 60, 20);
    _noteLabel.frame = CGRectMake(kLeft, _titleLabel.bottom + 20, width, 20);
    
    _closeBtn.frame = CGRectMake(_contentFace.width - 40, 0, 40, 40);
    _closeBtn.centerY = _titleLabel.centerY;
    
    __block CGFloat initY = _noteLabel.bottom + 20;
    
//    if (IsArrayWithItems(_notes)) {
//        [_notes enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            obj.frame = CGRectMake(kLeft, initY, width, 20);
//            initY = obj.bottom + 20;
//        }];
//    }
    
    CGFloat exampleWidth = (self.width - kLeft * 5) / kRowPerNum;
    CGFloat height = exampleWidth + 50;
//    if (IsArrayWithItems(_exampleViews)) {
//        [_exampleViews enumerateObjectsUsingBlock:^(WALMEUploadComponentExampleView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            obj.frame = CGRectMake(kLeft + (kLeft + exampleWidth) * (idx % kRowPerNum), initY + (height + 20) * (idx / kRowPerNum) , exampleWidth, height);
//        }];
//    }
    int contentHeight = kInitHeight;
    contentHeight += MAX(0, _notes.count - 1) * kNoteHeight;
    contentHeight += MAX(0, ceil(_exampleViews.count / 4.0)) * (height + 20);
    contentHeight += 40;
    _contentFace.height = contentHeight;
    _contentFace.top = self.height - _contentFace.height;
    
    int btnHeight = 60;
    _cameraBtn.frame = CGRectMake(0, _contentFace.height - btnHeight, self.width / 2, btnHeight);
    _albumBtn.frame = CGRectMake(self.width / 2, _contentFace.height - btnHeight, self.width / 2, btnHeight);
}

- (void)p_walme_initView {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _shouldTouchClose = YES;
    
    _contentFace = [[UIView alloc] init];
    _contentFace.backgroundColor = [UIColor whiteColor];
    _contentFace.layer.cornerRadius = 4;
    _contentFace.layer.masksToBounds = YES;
    _contentFace.userInteractionEnabled = YES;
    [self addSubview:_contentFace];
    
    _titleLabel = [WALMEViewHelper walme_labelWithFrame:CGRectZero title:nil fontSize:13 textColor:[UIColor walme_colorWithRGB:0x4c4c4c]];
    _titleLabel.font = [UIFont walme_PingFangMedium13];
    [_contentFace addSubview:_titleLabel];
    
    _noteLabel = [WALMEViewHelper walme_labelWithFrame:CGRectZero title:nil fontSize:13 textColor:[UIColor walme_colorWithRGB:0x212121]];
    _noteLabel.font = [UIFont walme_PingFangMedium15];
    [_contentFace addSubview:_noteLabel];
    
    _closeBtn = [WALMEViewHelper walme_buttonWithFrame:CGRectZero
                                               bgImage:nil
                                                 image:@"walme_forall_5"
                                                 title:nil
                                             textColor:nil
                                                method:@selector(close:)
                                                target:self];
    
    [_contentFace addSubview:_closeBtn];
    
    _cameraBtn = [WALMEViewHelper walme_buttonWithFrame:CGRectZero
                                                bgImage:nil
                                                  image:nil
                                                  title:@"拍摄"
                                              textColor:[UIColor whiteColor]
                                                 method:@selector(camera:)
                                                 target:self];
    _cameraBtn.titleLabel.font = [UIFont walme_PingFangMedium18];
    _cameraBtn.backgroundColor = [UIColor blueColor];
    [_contentFace addSubview:_cameraBtn];
    
    _albumBtn = [WALMEViewHelper walme_buttonWithFrame:CGRectZero
                                               bgImage:nil
                                                 image:nil
                                                 title:@"相册"
                                             textColor:[UIColor whiteColor]
                                                method:@selector(album:)
                                                target:self];
    _albumBtn.titleLabel.font = [UIFont walme_PingFangMedium18];
    _albumBtn.backgroundColor = [UIColor blueColor];
    [_contentFace addSubview:_albumBtn];
}

@end
