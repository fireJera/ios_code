//
//  JJMethodDetailViewController.m
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/10.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "JJMethodDetailViewController.h"
#import "JJMethod.h"
#import "JJClsLayoutCell.h"

@interface JJMethodDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) JJMethod * method;
@property (nonatomic, assign) NSInteger layoutCellHeight;

@end

@implementation JJMethodDetailViewController

- (instancetype)initWithMethod:(JJMethod *)method {
    self = [super init];
    if (!self) return nil;
    _method = method;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 32 - 56) / 8;
    _layoutCellHeight = 32 + (width + 8) * ceil(_method.layoutLength / 8.0);
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.tableFooterView = [UIView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[JJClsLayoutCell class] forCellReuseIdentifier:@"layoutCell"];
    [self.view addSubview:_tableView];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    if (indexPath.section < 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"layoutCell" forIndexPath:indexPath];
        [((JJClsLayoutCell *)cell) updateMethodLayout:_method.layoutLength layout:_method.layoutIndexes];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = _method.prototype;
    }
    else if (indexPath.section == 1) {
        cell.textLabel.text = [NSString stringWithCString:_method.typeEncoding encoding:NSUTF8StringEncoding];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"prototype";
    }
    else if (section == 1) {
        return @"encoding";
    }
    else if (section == 2) {
        return @"layout";
    }
    return nil;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section < 2 ? 44 : _layoutCellHeight;
}

@end
