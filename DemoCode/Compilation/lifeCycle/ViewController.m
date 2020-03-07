//
//  ViewController.m
//  lifeCycle
//
//  Created by super on 2018/12/25.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *testView;

@end

@implementation ViewController

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"init");
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        NSLog(@"initWithCoder");
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // awakeFromNib是和initWithCoder绑定存在的。只有从NIB中加载才会s调用initWithCoder
    // 然后才会调用awakeFromNib
    //
    // here self.testView == nil
    NSLog(@"awakeFromNib");
}

- (void)loadView {
    [super loadView];
//    here self.testView != nil
    NSLog(@"loadView");
}

- (void)loadViewIfNeeded {
    [super loadViewIfNeeded];
    NSLog(@"loadViewIfNeeded");
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view layoutIfNeeded];
    NSLog(@"viewDidLoad");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

- (void)viewWillLayoutSubviews {
    NSLog(@"viewWillLayoutSubviews");
}

- (void)viewLayoutMarginsDidChange {
    [super viewLayoutMarginsDidChange];
    NSLog(@"viewLayoutMarginsDidChange");
}

- (void)viewDidLayoutSubviews {
    NSLog(@"viewDidLayoutSubviews");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}

- (void)didReceiveMemoryWarning {
    NSLog(@"didReceiveMemoryWarning");
}

- (void)dealloc {
    NSLog(@"dealloc");
}

@end
