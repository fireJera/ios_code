//
//  FlexViewController.m
//  FlexLib
//
//  Created by Jeremy on 2019/5/19.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "FlexViewController.h"

@interface FlexViewController ()
{
//    FlexScrollView* _scroll;
    UILabel* _label;
    UIView * _test;
}

@end

@implementation FlexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"FlexLib Demo";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTest:(id)sender {
//    TestVC* vc=[[TestVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}
- (void)onPressTest:(id)sender {
    NSLog(@"pressed");
}
//- (void)onTestTable:(id)sender {
//    TestTableVC* vc=[[TestTableVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//- (void)onTestScrollView:(id)sender {
//    TestScrollVC* vc=[[TestScrollVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//- (void)onTestModalView:(id)sender {
//    TestModalVC* vc=[[TestModalVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//- (void)onTestLoginView:(id)sender {
//    TestLoginVC* vc=[[TestLoginVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//- (void)onCollectionView{
//    TestCollectionViewVC* vc=[[TestCollectionViewVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//- (void)onTextView:(id)sender {
//    TextViewVC* vc=[[TextViewVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//- (void)onViewLayouts:(id)sender {
//    [FlexLayoutViewerVC presentInVC:self];
//}
//- (void)onControls{
//    ControlsVC* vc=[[ControlsVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//- (void)onFrameVC{
//    FrameVC* vc=[[FrameVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//-(void)onExplorerFlex
//{
//    [FlexHttpVC presentInVC:self];
//}
//-(void)onFrameView
//{
//    CGRect rcFrame = [[UIScreen mainScreen]bounds];
//    rcFrame.origin.y = 100;
//    rcFrame.size.height = 500;
//    TestFrameView* frameview=[[TestFrameView alloc]initWithFlex:nil Frame:rcFrame Owner:nil];
//    [self.view addSubview:frameview];
//}

@end
