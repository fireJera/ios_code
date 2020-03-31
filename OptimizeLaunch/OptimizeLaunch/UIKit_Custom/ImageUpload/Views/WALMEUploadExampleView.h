//
//  WALMEUploadExampleView.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CodeFrameDefineCode.h"
NS_ASSUME_NONNULL_BEGIN

@interface WALMEUploadComponentExampleModel : NSObject

@property (nonatomic, copy) NSString * image;
@property (nonatomic, copy) NSString * desc;
@property (nonatomic, assign) BOOL isCorrect;

@end

@interface WALMEUploadComponentExampleView : UIView

@property (nonatomic, strong) UIImageView * templateImage;
@property (nonatomic, strong) UIImageView * rightImage;
@property (nonatomic, strong) UILabel * noteLabel;
@property (nonatomic, strong) WALMEUploadComponentExampleModel * model;

- (instancetype)initWithModel:(WALMEUploadComponentExampleModel *)model;

@end

@interface WALMEUploadExampleView : UIView

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * noteLabel;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UIButton * cameraBtn;         //left
@property (nonatomic, strong) UIButton * albumBtn;          //right

@property (nonatomic, copy) NSArray<NSString *> * titles;
@property (nonatomic, copy) NSArray<WALMEUploadComponentExampleModel *> * exampleModels;

@property (nonatomic, assign) BOOL shouldTouchClose;

- (void)configBtns:(NSArray<NSString *> *)btns
             title:(NSString *)title
             notes:(NSArray<NSString *> *)notes
          examples:(nullable NSArray<WALMEUploadComponentExampleModel *> *)examples
       leftHandler:(WALMEVoidBlock)leftHandler
      rightHandler:(WALMEVoidBlock)rightHandler;

- (void)configWithBtns:(NSArray *)btns
            dictionary:(NSDictionary *)dic
           leftHandler:(WALMEVoidBlock)leftHandler
          rightHandler:(WALMEVoidBlock)rightHandler;

@end
NS_ASSUME_NONNULL_END
