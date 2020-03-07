//
//  JJClassViewController.m
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/9.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "JJClassViewController.h"
#import "JJIvar.h"
#import "JJMethod.h"
#import "JJProperty.h"
#import "JJDetaiViewController.h"
#import "JJClsLayoutCell.h"
#import <objc/runtime.h>
#import "JJProtocolViewController.h"

@interface JJClassViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) Class cls;
@property (nonatomic, assign) Class superCls;
@property (nonatomic, assign) Class metaCls;
@property (nonatomic, assign) NSUInteger classInsSize;
//@property (nonatomic, copy) NSIndexSet * layoutIndexes;
@property (nonatomic, copy) NSIndexSet * strongIndex;
@property (nonatomic, copy) NSArray<NSNumber *> * layoutArray;

@property (nonatomic, assign) NSUInteger layoutCellHeight;

@property (nonatomic, copy) NSArray<JJIvar *> *ivars;
@property (nonatomic, copy) NSArray<JJProperty *> *propertys;
//@property (nonatomic, copy) NSArray<NSString *> *propertys;
@property (nonatomic, copy) NSArray<JJMethod *> *methods;
@property (nonatomic, copy) NSArray<JJMethod *> *classMethods;
@property (nonatomic, copy) NSArray<NSString *> *protocols;

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation JJClassViewController

- (instancetype)initWithClass:(Class)cls {
    if (self = [super init]) {
        _cls = cls;
        NSInteger vSize = sizeof(void *);
        _superCls = class_getSuperclass(_cls);
        const char * clsName = class_getName(cls);
        _metaCls = objc_getMetaClass(clsName);
        
        _classInsSize = class_getInstanceSize(_cls);
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 32 - 56) / 8;
        _layoutCellHeight = 32 + (width + 8) * ceil(_classInsSize / 8.0);
        const uint8_t * layout = class_getIvarLayout(_cls);
        NSMutableIndexSet * indexSet = [NSMutableIndexSet indexSet];
        
        unsigned int ivarCount;
        Ivar * ivars = class_copyIvarList(_cls, &ivarCount);
        if (ivarCount > 0) {
            Ivar firstIvar = ivars[0];
            ptrdiff_t firstOffset = ivar_getOffset(firstIvar);
            int minimum = (int)(firstOffset / vSize);
            if (layout != NULL) {
                while (*layout != 0x00) {
                    int upper = (*layout & 0xf0) >> 4;
                    int lowwer = *layout & 0xf;
                    minimum += upper;
                    [indexSet addIndexesInRange:NSMakeRange(minimum, lowwer)];
                    minimum += lowwer;
                    //            printf("%02x", *layout);
                    //            printf("%d  - %d\n", upper, lowwer);
                    ++layout;
                }
                _strongIndex = [indexSet copy];
            }
        }
        
//        NSMutableIndexSet * indexSet = [NSMutableIndexSet indexSet];
        NSMutableArray * layouts = [NSMutableArray array];
        
        NSMutableArray * array = [NSMutableArray array];
        for (unsigned int i = 0; i < ivarCount; i++) {
            JJIvar * ivar = [[JJIvar alloc] initWithIvar:ivars[i]];
            [layouts addObject:@(ivar.offset)];
            [layouts addObject:@(ivar.size)];
            NSInteger index = ivar.offset / vSize;
//            [indexSet addIndexesInRange:NSMakeRange(offset, size)];
            ivar.isWeak = ![_strongIndex containsIndex:index];
            [array addObject:ivar];
        }
//        _layoutIndexes = [indexSet copy];
        _layoutArray = [layouts copy];
        _ivars = [array copy];
        
        unsigned int proCount;
        NSMutableArray * pArray = [NSMutableArray array];
        objc_property_t * properties = class_copyPropertyList(_cls, &proCount);
        for (unsigned int i = 0; i < proCount; i++) {
            JJProperty * pro = [[JJProperty alloc] initWithProperty:properties[i]];
            [pArray addObject:pro];
        }
        _propertys = [pArray copy];
        
        Method * methods = class_copyMethodList(_cls, &ivarCount);
        NSMutableArray * methodList = [NSMutableArray array];
        for (unsigned int i = 0; i < ivarCount; i++) {
            JJMethod * methodIns = [[JJMethod alloc] initWithMethod:methods[i]];
            [methodList addObject:methodIns];
        }
        _methods = [methodList copy];
        
        [methodList removeAllObjects];
        methods = class_copyMethodList(_metaCls, &ivarCount);
        for (unsigned int i = 0; i < ivarCount; i++) {
            JJMethod * methodIns = [[JJMethod alloc] initWithMethod:methods[i] isMeta:YES];
            [methodList addObject:methodIns];
        }
        _classMethods = [methodList copy];
        
        [methodList removeAllObjects];
        Protocol * __unsafe_unretained * protocols = class_copyProtocolList(_cls, &proCount);
        for (unsigned int i = 0; i < proCount; i++) {
            Protocol * protocol = protocols[i];
            const char * cName = protocol_getName(protocol);
            NSString * name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
            [methodList addObject:name];
        }
        _protocols = [methodList copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSStringFromClass(_cls);
    
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
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }
    else if (section == 2) {
        return _ivars.count;
    }
    else if (section == 3) {
        return _propertys.count;
    }
    else if (section == 4) {
        return _methods.count;
    }
    else if (section == 5) {
        return _classMethods.count;
    }
    else if (section == 6) {
        return _protocols.count;
    }
    else if (section == 7) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    if (indexPath.section < 6) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"layoutCell" forIndexPath:indexPath];
//        [((JJClsLayoutCell  *)cell) updateLayout:_classInsSize range:_layoutIndexes];
        [((JJClsLayoutCell  *)cell) updateLayout:_classInsSize layout:_layoutArray];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = NSStringFromClass(_superCls);
    }
    else if (indexPath.section == 1) {
        const char * metaName = class_getName(_metaCls);
        cell.textLabel.text = [NSString stringWithCString:metaName encoding:NSUTF8StringEncoding];
    }
    else if (indexPath.section == 2) {
        JJIvar * ivar = _ivars[indexPath.row];
        cell.textLabel.text = ivar.name;
    }
    else if (indexPath.section == 3) {
        JJProperty * property = _propertys[indexPath.row];
        cell.textLabel.text = property.name;
    }
    else if (indexPath.section == 4) {
        JJMethod * method = _methods[indexPath.row];
        cell.textLabel.text = method.name;
    }
    else if (indexPath.section == 5) {
        JJMethod * method = _classMethods[indexPath.row];
        cell.textLabel.text = method.name;
    }
    else if (indexPath.section == 6) {
        cell.textLabel.text = _protocols[indexPath.row];
    }
    else if (indexPath.section == 7) {
        
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"super class";
    }
    else if (section == 1) {
        return @"meta class";
    }
    else if (section == 2) {
        return @"ivars";
    }
    else if (section == 3) {
        return @"propertys";
    }
    else if (section == 4) {
        return @"methods";
    }
    else if (section == 5) {
        return @"class methods";
    }
    else if (section == 6) {
        return @"protocols";
    }
    else if (section == 7) {
        return @"layout";
    }
    return @"";
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController * viewController;
    if (indexPath.section == 0) {
        JJClassViewController * classView = [[JJClassViewController alloc] initWithClass:_superCls];
        [self.navigationController pushViewController:classView animated:YES];
    }
    else if (indexPath.section == 1) {
        JJClassViewController * classView = [[JJClassViewController alloc] initWithClass:_metaCls];
        [self.navigationController pushViewController:classView animated:YES];
    }
    else if (indexPath.section == 2) {
        JJIvar * ivar = _ivars[indexPath.row];
        viewController = [JJDetaiViewController detailWithIvar:ivar];
    }
    else if (indexPath.section == 3) {
        JJProperty * property = _propertys[indexPath.row];
        viewController = [JJDetaiViewController detailWithProperty:property];
    }
    else if (indexPath.section == 4) {
        JJMethod * method = _methods[indexPath.row];
        viewController = [JJDetaiViewController detailWithMethod:method];
    }
    else if (indexPath.section == 5) {
        JJMethod * method = _classMethods[indexPath.row];
        viewController = [JJDetaiViewController detailWithMethod:method];
    }
    else if (indexPath.section == 6) {
        NSString * pName = _protocols[indexPath.row];
        viewController = [[JJProtocolViewController alloc] initWithProtocolName:pName];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section < 6 ? 44 : _layoutCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
@end
