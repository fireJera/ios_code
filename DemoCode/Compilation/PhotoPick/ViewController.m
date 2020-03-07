//
//  ViewController.m
//  PhotoPick
//
//  Created by Jeremy on 2019/3/21.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import "LETADAlbumListViewController.h"
#import "HXPhotoManager.h"
#import "HXPhotoManager.h"
//#import "HXPhotoManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)pickImage:(id)sender {
    
    
    
    
//    HXPhotoManagerSelectedType type;
////    if ([_viewmodel.uploadType isEqualToString:@"photo"]) {
////        type = HXPhotoManagerSelectedTypePhoto;
////    } else if ([_viewmodel.uploadType isEqualToString:@"video"]) {
////        type = HXPhotoManagerSelectedTypeVideo;
////    } else if ([_viewmodel.uploadType isEqualToString:@"all"]) {
//        type = HXPhotoManagerSelectedTypePhotoAndVideo;
////    } else {
////        type = HXPhotoManagerSelectedTypePhoto;
////    }
//    HXPhotoManager *_manager = [[HXPhotoManager alloc] initWithType:type];
//    switch (type) {
//        case HXPhotoManagerSelectedTypePhoto:
//            _manager.photoMaxNum = 9;//_viewmodel.maxNumer;
//            _manager.maxNum = 9;//_viewmodel.maxNumer;
//            _manager.singleSelected = NO;//_viewmodel.maxNumer == 1;
//            break;
//        case HXPhotoManagerSelectedTypeVideo:
//            _manager.videoMaxNum = 1;//_viewmodel.maxNumer;
//            _manager.singleSelected = YES;//_viewmodel.maxNumer == 1;
//            _manager.videoMaxDuration = 10;//_viewmodel.maxTime;
//            _manager.videoMinDuration = 3;//_viewmodel.minTime;
//            break;
//        case HXPhotoManagerSelectedTypePhotoAndVideo:
//            _manager.singleSelected = YES;//_viewmodel.maxNumer == 1;;
//            _manager.maxNum = 1;//_viewmodel.maxNumer;
//            _manager.photoMaxNum = 1;//_viewmodel.maxNumer;
//            _manager.videoMaxNum = 1;//_viewmodel.maxNumer;
//            _manager.videoMaxDuration = 10;//_viewmodel.maxTime;
//            _manager.videoMinDuration = 3;//_viewmodel.minTime;
//            break;
//    }
//    _manager.selectTogether = YES;
//    _manager.goCamera = NO;
//    _manager.showDateHeaderSection = YES;
//    _manager.reverseDate = NO;
//
//    _manager.cacheAlbum = NO;
//    _manager.openCamera = NO;
//    _manager.rowCount = 3;
//    _manager.style = HXPhotoAlbumStylesWeibo;
//    _manager.deleteTemporaryPhoto = NO;
//    _manager.lookLivePhoto = YES;
//
//    LETADAlbumListViewController * album = [[LETADAlbumListViewController alloc] init];
//    album.manager = _manager;
//    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:album];
//    [self presentViewController:navi animated:YES completion:nil];
}

@end
