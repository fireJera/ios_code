//
//  JJIVarDetailViewController.m
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/10.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "JJIvarDetailViewController.h"
#import "JJIvar.h"
#import "JJProperty.h"

@interface JJIvarDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JJIvar * ivar;
@property (nonatomic, strong) JJProperty * property;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation JJIvarDetailViewController

- (instancetype)initWithIvar:(JJIvar *)ivar {
    self = [super init];
    if (!self) return nil;
    _ivar = ivar;
    return self;
}

- (instancetype)initWithProperty:(JJProperty *)property {
    self = [super init];
    if (!self) return nil;
    _property = property;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.tableFooterView = [UIView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_ivar) {
        return 4;
    }
    else if (_property) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (_ivar) {
        if (indexPath.section == 0) {
            cell.textLabel.text = _ivar.prototype;
        }
        else if (indexPath.section == 1) {
            cell.textLabel.text = _ivar.encoding;
        }
        else if (indexPath.section == 2) {
            cell.textLabel.text = @(_ivar.offset).stringValue;
        }
        else if (indexPath.section == 3) {
            cell.textLabel.text = @(_ivar.size).stringValue;
        }
    }
    else if (_property) {
        if (indexPath.section == 0) {
            cell.textLabel.text = _property.prototypeStr;
        }
        else if (indexPath.section == 1) {
            cell.textLabel.text = _property.attribute;
        }
    }
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_ivar) {
        if (section == 0) {
            return @"prototype";
        }
        else if (section == 1) {
            return @"encoding";
        }
        else if (section == 2) {
            return @"offset";
        }
        else if (section == 3) {
            return @"size";
        }
    }
    else if (_property) {
        if (section == 0) {
            return @"prototype";
        }
        else if (section == 1) {
            return @"attribute";
        }
    }
    return @"default";
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 44;
//}

@end
