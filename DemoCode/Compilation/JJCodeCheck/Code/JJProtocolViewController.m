
//
//  JJProtocolViewController.m
//  JJCodeCheck
//
//  Created by Jeremy on 2019/7/16.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "JJProtocolViewController.h"
#import <objc/runtime.h>
#import "JJMethod.h"
#import "JJProperty.h"
#import "JJDetaiViewController.h"

@interface JJProtocolViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) Protocol * protocol;
@property (nonatomic, copy) NSArray<NSString *> *protocols;

@property (nonatomic, copy) NSArray<JJProperty *> *insReqPros;
@property (nonatomic, copy) NSArray<JJProperty *> *insNoReqPros;
@property (nonatomic, copy) NSArray<JJProperty *> *clsReqPros;
@property (nonatomic, copy) NSArray<JJProperty *> *clsNoReqPros;

@property (nonatomic, copy) NSArray<JJMethod *> *insReqMethods;
@property (nonatomic, copy) NSArray<JJMethod *> *insNoReqMethods;
@property (nonatomic, copy) NSArray<JJMethod *> *clsReqMethods;
@property (nonatomic, copy) NSArray<JJMethod *> *clsNoReqMethods;

@end

@implementation JJProtocolViewController

- (instancetype)initWithProtocolName:(NSString *)protocolName {
    self = [super init];
    if (!self) return nil;
    _protocol = NSProtocolFromString(protocolName);
//    @interface Protocol : Object
//    {
//    @private
//        char *protocol_name OBJC2_UNAVAILABLE;
//        struct objc_protocol_list *protocol_list OBJC2_UNAVAILABLE;
//        struct objc_method_description_list *instance_methods OBJC2_UNAVAILABLE;
//        struct objc_method_description_list *class_methods OBJC2_UNAVAILABLE;
//    }
    unsigned int count;
    NSMutableArray * array = [NSMutableArray array];
    Protocol * __unsafe_unretained * protocols = protocol_copyProtocolList(_protocol, &count);
    for (unsigned int i = 0; i < count; i++) {
        Protocol * protocol = protocols[i];
        const char * cName = protocol_getName(protocol);
        NSString * name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [array addObject:name];
    }
    _protocols = [array copy];
    [array removeAllObjects];
    
    objc_property_t *properties = protocol_copyPropertyList(_protocol, &count);
    for (unsigned int i = 0; i < count; i++) {
        JJProperty * pro = [[JJProperty alloc] initWithProperty:properties[i]];
        [array addObject:pro];
    }
    _insReqPros = [array copy];
    [array removeAllObjects];
    
    properties = protocol_copyPropertyList2(_protocol, &count, NO, YES);
    for (unsigned int i = 0; i < count; i++) {
        JJProperty * pro = [[JJProperty alloc] initWithProperty:properties[i]];
        [array addObject:pro];
    }
    _insNoReqPros = [array copy];
    [array removeAllObjects];
    
    properties = protocol_copyPropertyList2(_protocol, &count, YES, NO);
    for (unsigned int i = 0; i < count; i++) {
        JJProperty * pro = [[JJProperty alloc] initWithProperty:properties[i]];
        [array addObject:pro];
    }
    _clsReqPros = [array copy];
    [array removeAllObjects];
    
    properties = protocol_copyPropertyList2(_protocol, &count, NO, NO);
    for (unsigned int i = 0; i < count; i++) {
        JJProperty * pro = [[JJProperty alloc] initWithProperty:properties[i]];
        [array addObject:pro];
    }
    _clsNoReqPros = [array copy];
    [array removeAllObjects];
    
    struct objc_method_description * methods = protocol_copyMethodDescriptionList(_protocol, YES, YES, &count);
    for (unsigned int i = 0; i < count; i++) {
        struct objc_method_description mDesc = methods[i];
//        Method method = NSSelectorFromString(<#NSString * _Nonnull aSelectorName#>)
        JJMethod * method = [[JJMethod alloc] initWithMethodDesc:mDesc];
        [array addObject:method];
    }
    _insReqPros = [array copy];
    [array removeAllObjects];
    
    methods = protocol_copyMethodDescriptionList(_protocol, YES, NO, &count);
    for (unsigned int i = 0; i < count; i++) {
        struct objc_method_description mDesc = methods[i];
        JJMethod * method = [[JJMethod alloc] initWithMethodDesc:mDesc];
        [array addObject:method];
    }
    _clsReqPros = [array copy];
    [array removeAllObjects];
    
    methods = protocol_copyMethodDescriptionList(_protocol, NO, YES, &count);
    for (unsigned int i = 0; i < count; i++) {
        struct objc_method_description mDesc = methods[i];
        JJMethod * method = [[JJMethod alloc] initWithMethodDesc:mDesc];
        [array addObject:method];
    }
    _insNoReqPros = [array copy];
    [array removeAllObjects];
    
    methods = protocol_copyMethodDescriptionList(_protocol, NO, NO, &count);
    for (unsigned int i = 0; i < count; i++) {
        struct objc_method_description mDesc = methods[i];
        JJMethod * method = [[JJMethod alloc] initWithMethodDesc:mDesc];
        [array addObject:method];
    }
    _clsNoReqPros = [array copy];
    [array removeAllObjects];
    
//    Method * methods = class_copyMethodList(_cls, &ivarCount);
//    NSMutableArray * methodList = [NSMutableArray array];
//    for (unsigned int i = 0; i < ivarCount; i++) {
//        JJMethod * methodIns = [[JJMethod alloc] initWithMethod:methods[i]];
//        [methodList addObject:methodIns];
//    }
//    _methods = [methodList copy];
//    protocol_copyMethodDescriptionList(_protocol, <#BOOL isRequiredMethod#>, <#BOOL isInstanceMethod#>, <#unsigned int * _Nullable outCount#>)
//    Method * methods =
//    NSMutableArray * methodList = [NSMutableArray array];
//    for (unsigned int i = 0; i < ivarCount; i++) {
//        JJMethod * methodIns = [[JJMethod alloc] initWithMethod:methods[i]];
//        [methodList addObject:methodIns];
//    }
//    _methods = [methodList copy];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.tableFooterView = [UIView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    [_tableView registerClass:[JJClsLayoutCell class] forCellReuseIdentifier:@"layoutCell"];
    [self.view addSubview:_tableView];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _protocols.count;
    }
    else if (section == 1) {
        return _insReqPros.count;
    }
    else if (section == 2) {
        return _insNoReqPros.count;
    }
    else if (section == 3) {
        return _clsReqPros.count;
    }
    else if (section == 4) {
        return _clsNoReqPros.count;
    }
    else if (section == 5) {
        return _insReqMethods.count;
    }
    else if (section == 6) {
        return _insNoReqMethods.count;
    }
    else if (section == 7) {
        return _clsReqMethods.count;
    }
    else if (section == 8) {
        return _clsNoReqMethods.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        NSString * name = _protocols[indexPath.row];
        cell.textLabel.text = name;
//        Protocol * protocol = _protocols[indexPath.row];
//        const char * cName = protocol_getName(protocol);
//        cell.textLabel.text = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
    }
    else if (indexPath.section == 1) {
        JJProperty * property = _insReqPros[indexPath.row];
        cell.textLabel.text = property.name;
    }
    else if (indexPath.section == 2) {
        JJProperty * property = _insNoReqPros[indexPath.row];
        cell.textLabel.text = property.name;
    }
    else if (indexPath.section == 3) {
        JJProperty * property = _clsReqPros[indexPath.row];
        cell.textLabel.text = property.name;
    }
    else if (indexPath.section == 4) {
        JJProperty * property = _clsNoReqPros[indexPath.row];
        cell.textLabel.text = property.name;
    }
    else if (indexPath.section == 5) {
        JJMethod * method = _insReqMethods[indexPath.row];
        cell.textLabel.text = method.name;
    }
    else if (indexPath.section == 6) {
        JJMethod * method = _insNoReqMethods[indexPath.row];
        cell.textLabel.text = method.name;
    }
    else if (indexPath.section == 7) {
        JJMethod * method = _clsReqMethods[indexPath.row];
        cell.textLabel.text = method.name;
    }
    else if (indexPath.section == 8) {
        JJMethod * method = _clsNoReqMethods[indexPath.row];
        cell.textLabel.text = method.name;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"protocols";
    }
    else if (section == 1) {
        return @"required instance propertys";
    }
    else if (section == 2) {
        return @"optinal instance propertys";
    }
    else if (section == 3) {
        return @"required class propertys";
    }
    else if (section == 4) {
        return @"optinal class propertys";
    }
    else if (section == 5) {
        return @"required instance methods";
    }
    else if (section == 6) {
        return @"optinal instance methods";
    }
    else if (section == 7) {
        return @"required class methods";
    }
    else if (section == 8) {
        return @"optinal class methods";
    }
    return @"";
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController * viewController;
    if (indexPath.section == 0) {
//        Protocol * protocol = _protocols[indexPath.row];
//        const char * cName = protocol_getName(protocol);
//        NSString * pName = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        NSString * pName = _protocols[indexPath.row];
        viewController = [[JJProtocolViewController alloc] initWithProtocolName:pName];
    }
    else if (indexPath.section == 1) {
        JJProperty * property = _insReqPros[indexPath.row];
        viewController = [JJDetaiViewController detailWithProperty:property];
    }
    else if (indexPath.section == 2) {
        JJProperty * property = _insNoReqPros[indexPath.row];
        viewController = [JJDetaiViewController detailWithProperty:property];
    }
    else if (indexPath.section == 3) {
        JJProperty * property = _clsReqPros[indexPath.row];
        viewController = [JJDetaiViewController detailWithProperty:property];
    }
    else if (indexPath.section == 4) {
        JJProperty * property = _clsNoReqPros[indexPath.row];
        viewController = [JJDetaiViewController detailWithProperty:property];
    }
    else if (indexPath.section == 5) {
        JJMethod * method = _insReqMethods[indexPath.row];
        viewController = [JJDetaiViewController detailWithMethod:method];
    }
    else if (indexPath.section == 6) {
        JJMethod * method = _insNoReqMethods[indexPath.row];
        viewController = [JJDetaiViewController detailWithMethod:method];
    }
    else if (indexPath.section == 7) {
        JJMethod * method = _clsReqMethods[indexPath.row];
        viewController = [JJDetaiViewController detailWithMethod:method];
    }
    else if (indexPath.section == 8) {
        JJMethod * method = _clsNoReqMethods[indexPath.row];
        viewController = [JJDetaiViewController detailWithMethod:method];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 44;
//}

@end
