//
//  JJClassListViewController.m
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/9.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "JJClassListViewController.h"
#import "JJClassViewController.h"

@interface JJClassListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray<Class> *classes;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation JJClassListViewController

- (instancetype)initWithClasses:(NSArray<Class> *)classes {
    self = [super init];
    if (!self) return nil;
    _classes = classes;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _imageName;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.tableFooterView = [UIView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

- (void)close {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _classes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Class tempClass = _classes[indexPath.row];
    cell.textLabel.text = NSStringFromClass(tempClass);
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JJClassViewController * classView = [[JJClassViewController alloc] initWithClass:_classes[indexPath.row]];
    [self.navigationController pushViewController:classView animated:YES];
}

@end
