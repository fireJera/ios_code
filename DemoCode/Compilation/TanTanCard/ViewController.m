//
//  ViewController.m
//  TanTanCard
//
//  Created by Jeremy on 2019/7/18.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "ViewController.h"
//#import "SwipView.h"
//#import "Card.h"
#import "CardScrollView.h"
#import "CardView.h"
#import "CardModel.h"

@interface ViewController () <CardScrollViewDelegate, CardScrollViewDataSource>

@property (nonatomic, strong) CardScrollView * cardScrollView;
@property (nonatomic, strong) NSArray<CardModel *> *models;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    SwipView *view = [[SwipView alloc] initWithFrame:self.view.bounds contentView:^UIView *(int index, CGRect frame, id  _Nonnull model) {
//        UIView * subview = [[UIView alloc] initWithFrame:frame];
//        subview.backgroundColor = [UIColor yellowColor];
//        return subview;
//    } bufferSize:3];
//    NSMutableArray * array = [NSMutableArray array];
//    for (int i = 0; i < 10; i++) {
//        [array addObject:[NSObject new]];
//    }
//    [view showTinderCards:array isDummyShow:YES];
//    [self.view addSubview:view];
    
    _cardScrollView = [[CardScrollView alloc] initWithFrame:self.view.bounds bufferSize:3];
    _cardScrollView.delegate = self;
    _cardScrollView.dataSource = self;
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        CardModel * model  = [[CardModel alloc] init];
        model.nickname = @"jiejie";
        [array addObject:model];
    }
    _models = [array copy];
    
    [_cardScrollView reloadData];
    [self.view addSubview:_cardScrollView];
}

#pragma mark - CardScrollViewDelegate



#pragma mark - CardScrollViewDataSource

@end
