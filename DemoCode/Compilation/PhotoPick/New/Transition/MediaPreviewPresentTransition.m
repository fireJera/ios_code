////
////  MediaPreviewPresentTransition.m
////  PhotoPick
////
////  Created by Jeremy on 2019/3/23.
////  Copyright © 2019 Jeremy. All rights reserved.
////
//
//#import "MediaPreviewPresentTransition.h"
//#import "PhotoView.h"
//#import "HXPhotoSubViewCell.h"
//#import "PhotoView.h"
//#import "MediaPreviewViewController.h"
//#import "PhotoModel.h"
//#import "AlbumTool.h"
//
//@interface MediaPreviewPresentTransition ()
//@property (strong, nonatomic) PhotoView *photoView ;
//@property (assign, nonatomic) MediaPreviewPresentTransitionType type;
//@end
//
//@implementation MediaPreviewPresentTransition
//
//+ (instancetype)transitionWithTransitionType:(MediaPreviewPresentTransitionType)type photoView:(PhotoView *)photoView {
//    return [[self alloc] initWithTransitionType:type photoView:photoView];
//}
//
//- (instancetype)initWithTransitionType:(MediaPreviewPresentTransitionType)type photoView:(PhotoView *)photoView {
//    self = [super init];
//    if (self) {
//        self.type = type;
//        self.photoView = photoView;
//    }
//    return self;
//}
//
//- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
//    if (self.type == MediaPreviewPresentTransitionTypePresent) {
//        return 0.45f;
//    }else {
//        return 0.25f;
//    }
//}
//
//- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
//    switch (self.type) {
//        case MediaPreviewPresentTransitionTypePresent:
//            [self presentAnimation:transitionContext];
//            break;
//            
//        case MediaPreviewPresentTransitionTypeDismiss:
//            [self dismissAnimation:transitionContext];
//            break;
//    }
//}
//
//- (void)presentAnim:(id<UIViewControllerContextTransitioning>)transitionContext Image:(UIImage *)image Model:(PhotoModel *)model FromVC:(UIViewController *)fromVC ToVC:(MediaPreviewViewController *)toVC cell:(HXPhotoSubViewCell *)cell{
//    model.tempImage = image;
//    UIView *containerView = [transitionContext containerView];
//    UIImageView *tempView = [[UIImageView alloc] initWithImage:image];
//    UIView *tempBgView = [[UIView alloc] initWithFrame:containerView.bounds];
//    tempView.clipsToBounds = YES;
//    tempView.contentMode = UIViewContentModeScaleAspectFill;
//    tempView.frame = [cell.imageView convertRect:cell.imageView.bounds toView:containerView];
//    if (!image) {
//        tempView.image = cell.imageView.image;
//    }
//    [tempBgView addSubview:tempView];
//    [containerView addSubview:toVC.view];
//    [toVC.view insertSubview:tempBgView atIndex:0];
//    toVC.collectionView.hidden = YES;
//    model.endDateImageSize = CGSizeZero;
//    CGFloat imgWidht = model.endDateImageSize.width;
//    CGFloat imgHeight = model.endDateImageSize.height;
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height - kTopMargin - kBottomMargin;
//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
//        if (kDevice_Is_iPhoneX) {
//            height = [UIScreen mainScreen].bounds.size.height - kTopMargin - 21;
//        }
//    }
//    toVC.navigationController.navigationBar.userInteractionEnabled = NO;
//    
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.75f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        tempView.frame = CGRectMake((width - imgWidht) / 2, (height - imgHeight) / 2 + kTopMargin, imgWidht, imgHeight);
//    } completion:^(BOOL finished) {
//        toVC.collectionView.hidden = NO;
//        [tempBgView removeFromSuperview];
//        [tempView removeFromSuperview];
//        toVC.navigationController.navigationBar.userInteractionEnabled = YES;
//        [transitionContext completeTransition:YES];
//    }];
//}
///**
// *  实现present动画
// */
//- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
//    MediaPreviewViewController *toVC = (MediaPreviewViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    
//    UICollectionView *collectionView = (UICollectionView *)self.photoView.collectionView;
//    if ([fromVC isKindOfClass:[UINavigationController class]]) {
//        UINavigationController *nav = (UINavigationController *)fromVC;
//        fromVC = nav.viewControllers.lastObject;
//    }else if ([fromVC isKindOfClass:[UITabBarController class]]) {
//        UITabBarController *tabBar = (UITabBarController *)fromVC;
//        if ([tabBar.selectedViewController isKindOfClass:[UINavigationController class]]) {
//            UINavigationController *nav = (UINavigationController *)tabBar.selectedViewController;
//            fromVC = nav.viewControllers.lastObject;
//        }else {
//            fromVC = tabBar.selectedViewController;
//        }
//    }
//    HXPhotoSubViewCell *cell = (HXPhotoSubViewCell *)[collectionView cellForItemAtIndexPath:self.photoView.currentIndexPath];
//    PhotoModel *model = cell.model;
//    __weak typeof(self) weakSelf = self;
//    [AlbumTool getHighQualityFormatPhotoForPHAsset:model.asset size:CGSizeMake(model.endImageSize.width * 0.8, model.endImageSize.height * 0.8) completion:^(UIImage *image, NSDictionary *info) {
//        [weakSelf presentAnim:transitionContext Image:image Model:model FromVC:fromVC ToVC:toVC cell:cell];
//    } error:^(NSDictionary *info) {
//        [weakSelf presentAnim:transitionContext Image:model.thumbPhoto Model:model FromVC:fromVC ToVC:toVC cell:cell];
//    }];
//}
//
///**
// *  实现dimiss动画
// */
//- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
//    MediaPreviewViewController *fromVC = (MediaPreviewViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    PhotoModel *model = [fromVC.modelArray objectAtIndex:fromVC.currentModelIndex];
//    HXDatePhotoPreviewViewCell *fromCell = [fromVC currentPreviewCell:model];
//    
//    UIImageView *tempView = [[UIImageView alloc] initWithImage:fromCell.imageView.image];
//    UICollectionView *collectionView = (UICollectionView *)self.photoView.collectionView;
//    
//    if ([toVC isKindOfClass:[UINavigationController class]]) {
//        UINavigationController *nav = (UINavigationController *)toVC;
//        toVC = nav.viewControllers.lastObject;
//    }else if ([toVC isKindOfClass:[UITabBarController class]]) {
//        UITabBarController *tabBar = (UITabBarController *)toVC;
//        if ([tabBar.selectedViewController isKindOfClass:[UINavigationController class]]) {
//            UINavigationController *nav = (UINavigationController *)tabBar.selectedViewController;
//            toVC = nav.viewControllers.lastObject;
//        }else {
//            toVC = tabBar.selectedViewController;
//        }
//    }
//    HXPhotoSubViewCell *cell = (HXPhotoSubViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:model.endCollectionIndex inSection:0]];
//    if (!tempView.image) {
//        tempView = [[UIImageView alloc] initWithImage:cell.imageView.image];
//    }
//    tempView.clipsToBounds = YES;
//    tempView.contentMode = UIViewContentModeScaleAspectFill;
//    
//    
//    UIView *containerView = [transitionContext containerView];
//    tempView.frame = [fromCell.imageView convertRect:fromCell.imageView.bounds toView:containerView];
//    [containerView addSubview:tempView];
//    
//    CGRect rect = [cell convertRect:cell.bounds toView:containerView];
//    cell.hidden = YES;
//    fromVC.view.hidden = YES;
//    
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//        if (cell) {
//            tempView.frame = rect;
//        }else {
//            tempView.alpha = 0;
//            tempView.transform = CGAffineTransformMakeScale(1.3, 1.3);
//        }
//    } completion:^(BOOL finished) {
//        cell.hidden = NO;
//        [tempView removeFromSuperview];
//        [transitionContext completeTransition:YES];
//    }];
//}
//@end
