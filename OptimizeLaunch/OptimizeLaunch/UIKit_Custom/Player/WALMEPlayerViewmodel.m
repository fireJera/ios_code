//
//  WALMEPlayerViewmodel.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEPlayerViewmodel.h"
#import "WALMEViewmodelHeader.h"
#import "WALMEPlayerModel.h"
//#import "WALMESignGuideModel.h"

@interface WALMEPlayerViewmodel () {
    NSString * _videoPath;
}

@property (nonatomic, strong) WALMEPlayerModel * model;
@property (nonatomic, copy) WALMEPlayerViewBlock operationBlock;
//@property (nonatomic, weak) id<WALMEPlayerViewmodelDelegate> delegate;

@end

@implementation WALMEPlayerViewmodel {
    UIImage * _image;
}

- (instancetype)initWithNSDictionary:(NSDictionary *)dic image:(UIImage *)snapImage {
    if (self = [super init]) {
        NSDictionary * tempDic = dic[@"pageData"];
//        if (IsDictionaryWithItems(dic)) {
//            if (tempDic) {
////                _model = [WALMEPlayerModel yy_modelWithJSON:tempDic];
//            } else {
////                _model = [WALMEPlayerModel yy_modelWithJSON:dic];
//            }
////            _playerType = WALMEPlayerViewTypeNormal;
//        }
        _image = snapImage;
    }
    return self;
}

- (instancetype)initWithVideoPath:(NSString *)videoPath image:(UIImage *)snapImage {
    self = [super init];
    if (!self) return nil;
    _image = snapImage;
    _videoPath = videoPath;
    //    _playerType = WALMEPlayerViewTypeNormal;
    return self;
}

//- (instancetype)initWithDelegate:(id<WALMEPlayerViewmodelDelegate>)delegate {
//    self = [super init];
//    if (!self) return nil;
//    _delegate = delegate;
//    if ([_delegate respondsToSelector:@selector(video)]) {
//        _videoPath = _delegate.video;
//    }
////    if ([_delegate respondsToSelector:@selector(playerType)]) {
////        _playerType = _delegate.playerType;
////    }
//    return self;
//}

- (instancetype)init {
    return [self initWithVideoPath:nil image:nil];
}

- (void)setRefreshBlock:(WALMEPlayerViewBlock)refreshBlock {
    _operationBlock = refreshBlock;
}

//- (WALMEPlayerViewType)viewType {
//    return _playerType;
//}

- (NSString *)nickname {
    return _model.nickname;
//    if ([_delegate respondsToSelector:@selector(nickname)]) {
//        return _delegate.nickname;
//    }
//    return nil;
}

- (NSURL *)avatarUrl {
    return [NSURL URLWithString:_model.avatar];
//    if ([_delegate respondsToSelector:@selector(avatar)]) {
//        return [NSURL URLWithString:_delegate.avatar];
//    }
//    return nil;
}

//- (NSURL *)coverUrl {
//    return [NSURL URLWithString:_model.avatar];
//}

- (NSString *)videoPath {
    if (_model) return _model.video;
    else return _videoPath;
}

- (NSURL *)videoUrl {
    if (_model) return [NSURL URLWithString:_model.video];
    else return [NSURL URLWithString:_videoPath];
}

- (NSString *)userid {
    return _model.userid;
}

- (NSString *)signature {
    return _model.introduce;
}

- (NSString *)selfDesc {
    return _model.introduce;
}

- (UIImage *)snapImage {
    return _image;
}

//- (int)refresh {
//    return _model.refresh;
//}
//
- (BOOL)canPlay {
    if (_model) return _model.canPlay;
    else return YES;
}

- (BOOL)isSelf {
    if (_model) {
        return [_model.userid isEqualToString:WALMEINSTANCE_USER.uid];
    }
    return YES;
}

- (NSString *)blurNote {
    return _model.blurNote;
}

- (NSString *)blurBtnTitle {
    return _model.blurBtnTitle;
}

- (void)changeFollow:(BOOL)followed {
    _model.followed = followed;
}

- (void)clickBlurOperation {
//    [[WALMENetCallback alloc] init].walme_deal(_model.blurOperation).resultBlock = ^(BOOL isSuccess, id result) {
//        if (isSuccess) {
//            [_model yy_modelSetWithJSON:result[@"data"]];
//        }
//        if (_operationBlock) {
//            _operationBlock(isSuccess);
//        }
//    };
}

- (BOOL)isShowAd {
    return _model.isShowAd;
}

- (NSDictionary *)notPlayAlert {
    return _model.notPlayAlert;
}

- (NSArray *)feedList {
    return _model.feedList;
}

- (UIView *)feedView {
    return _adView;
}

//
//- (int)realAuth {
//    return _model.realAuth.realAuth;
//}
//
//- (NSString *)nickname {
//    return [NSString stringWithFormat:@"  %@", _model.userInfo.nickname];
//}
//
//- (NSString *)avatar {
//    return _model.userInfo.headPic;
//}
//
//- (NSURL *)avatarUrl {
//    return [NSURL URLWithString:_model.userInfo.headPic];
//}
//
//- (NSString *)cover {
//    return _model.videoInfo.cover;
//}
//
//- (NSURL *)coverUrl {
//    return [NSURL URLWithString:_model.videoInfo.cover];
//}
//
//- (NSString *)video {
//    return _model.videoInfo.video;
//}
//
//- (NSURL *)videoUrl {
//    if (_videoPath) return [NSURL URLWithString:_videoPath];
//    return [NSURL URLWithString:_model.videoInfo.video];
//}
//
//- (NSString *)userid {
//    return _model.userInfo.userid;
//}
//
//- (NSString *)tips {
//    return _model.realAuth.tips;
//}
@end
