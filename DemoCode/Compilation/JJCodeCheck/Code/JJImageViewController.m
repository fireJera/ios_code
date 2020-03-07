//
//  JJImageViewController.m
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/9.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "JJImageViewController.h"
#import "JJClassListViewController.h"
#import "objc/runtime.h"

@interface JJImageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray<NSString *> *focusImages;
@property (nonatomic, copy) NSArray<NSString *> *focusNames;

@property (nonatomic, copy) NSArray<NSString *> *otherImages;
@property (nonatomic, copy) NSArray<NSString *> *otherNames;

@end

@implementation JJImageViewController

- (instancetype)initWithFocusImages:(NSArray<NSString *> *)focusImages {
    return [self initWithFocusImages:focusImages otherImages:nil];
}

- (instancetype)initWithFocusImages:(NSArray<NSString *> *)focusImages otherImages:(NSArray<NSString *> *)otherImages {
    if (self = [super init]) {
        _focusImages = focusImages;
        __block NSMutableArray * names = [NSMutableArray array];
        [_focusImages enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray * paths = [obj componentsSeparatedByString:@"/"];
            NSString * imageName = [paths lastObject];
            if (imageName) {
                [names addObject:imageName];
            }
        }];
        _focusNames = [names copy];
        [names removeAllObjects];
        
        _otherImages = otherImages;
        
        [_otherImages enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray * paths = [obj componentsSeparatedByString:@"/"];
            NSString * imageName = [paths lastObject];
            if (imageName) {
                [names addObject:imageName];
            }
        }];
        _otherNames = [names copy];
    }
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close)];
}

- (void)close {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = 0;
    if (_focusNames) {
        count += 1;
    }
    if (_otherNames) {
        count += 1;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && _focusNames) {
            return _focusNames.count;
    }
    else {
        return _otherNames.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0 && _focusNames) {
        cell.textLabel.text = _focusNames[indexPath.row];
    }
    else {
        cell.textLabel.text = _otherNames[indexPath.row];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0 && _focusNames) {
        return @"focus images";
    }
    else {
        return @"other images";
    }
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * imageName;
    NSString * lastName;
    if (indexPath.section == 0 && _focusNames) {
        imageName = _focusImages[indexPath.row];
        lastName = _focusNames[indexPath.row];
    }
    else {
        imageName = _otherImages[indexPath.row];
        lastName = _otherNames[indexPath.row];
    }
    const char * image = [imageName UTF8String];
    unsigned int classCount;
    const char ** classes = objc_copyClassNamesForImage(image, &classCount);
    NSMutableArray<Class> * array = [NSMutableArray array];
    for (unsigned int i = 0; i < classCount; i++) {
        const char * className = classes[i];
        Class tempClass = objc_getClass(className);
        [array addObject:tempClass];
    }
    
    JJClassListViewController * classList = [[JJClassListViewController alloc] initWithClasses:array];
    classList.imageName = lastName;
    [self.navigationController pushViewController:classList animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 16;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 44;
//}

@end
