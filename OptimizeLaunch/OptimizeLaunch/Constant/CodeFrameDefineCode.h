//
//  CodeFrameDefineCode.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#ifndef CodeFrameDefineCode_h
#define CodeFrameDefineCode_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^WALMEVoidBlock)(void);
typedef void(^WALMENetProgressBlock)(float progressValue);
// 返回信息结果
typedef void(^WALMENetRessultMessageBlock)(BOOL isSuccess, id result, NSString * msg);
// 返回信息结果
typedef void(^WALMENetMessageBlock)(BOOL isSuccess, NSString * msg);
// 返回输出结果
typedef void(^WALMENetResultBlock)(BOOL isSuccess, id result);

#pragma mark singleInstance

//#define LCINSTANCE_PROPERTY                 ([LCProperty CurrentProperty])
//#define LCINSTANCE_AUTHTOOL                 LCAuthTool
//#define LCCURRENTCONTROLLER                 (LCINSTANCE_AppDelegate.currentController)

/* other  */
#define kEmptyPlaceholderImage          ([UIImage imageNamed:@"picture_empty"])
#define kEmptyIconPlaceHolderImage      ([UIImage imageNamed:@"somebody_icon"])
#define kFacePlaceholderImage           ([UIImage imageNamed:@"profile_default"])

#define SAFESTRING(str)  ( ( ((str)!=nil)&&![(str) isKindOfClass:[NSNull class]])?[NSString stringWithFormat:@"%@",(str)]:@"" )

#define WALMEMajorVersion         [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];            //APP版本
#define WALMEMinorVersion         [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
#define WALMEBundleIdentifier     [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"];

#ifdef DEBUG
#define NSLog(format, ...) NSLog(@"\n内容: %@", [NSString stringWithFormat:format, ##__VA_ARGS__]);
#define NSDetailLog(format, ...) NSLog(@"\n文件: %@ \n方法: %s \n内容: %@ \n行数: %d",[[[NSString stringWithFormat:@"%s",__FILE__] componentsSeparatedByString:@"/"] lastObject], __FUNCTION__,[NSString stringWithFormat:format, ##__VA_ARGS__],__LINE__);
#else
#define NSLog(format, ...)
#define NSDetailLog(format, ...)
#endif

//#if DEBUG
//#define CPrintLog(FORMAT, ...) fprintf(stderr,"\n function:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#else
//#define CPrintLog(FORMAT, ...) nil
//#endif
//
//#ifdef DEBUG
//
//#define CFLog(FORMAT, ...) fprintf(stderr, "\n\n******(class)%s(begin)******\n(SEL)%s\n(line)%zd\n(data)%s\n******(class)%s(end)******\n\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __FUNCTION__, __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String], [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String]);
//#else
//#define NSLog(FORMAT, ...) nil
//#endif


// NS_FORMAT_FUNCTION(1, 2) 告诉编译器 索引1处的是格式化字符串，参数从2处开始
//FOUNDATION_EXPORT void CLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2) NS_NO_TAIL_CALL {
//    va_list args;
//    va_start(args, format);
////    NSMutableArray *parms = [NSMutableArray array];
////    NSString * newFormat = [@"my CLog" stringByAppendingFormat:format];
//
//    NSString * str  = [[NSString alloc] initWithFormat:format arguments:args];
//    //就是在取出参数列表中的所有参数，它们的类型是UIViewController *，这是因为我知道参数列表里面全是装的这个类型，如果你不知道这些参数的类型，可以写id，比如while (eachObject = va_arg(argumentList, id))
//
////    UIViewController *eachObject;
////    while (eachObject = va_arg(args, UIViewController *))
////        [parms addObject:eachObject];
//
//    va_end(args);
//    const char * cstring = [str UTF8String];
//    fprintf(stderr, cstring);
//}

#define kSetViewText(_view, _text) _view.walme_text = _text;
#define kStringWithFormat(format, ...) [NSString stringWithFormat:@"format", ##__VA_ARGS__];

NS_INLINE BOOL IsArrayWithItems(id object) {
    return (object && [object isKindOfClass:[NSArray class]] &&
            [(NSArray *)object count] > 0);
}

/* 判断类型 c funcs */
NS_INLINE BOOL IsStringWithAnyText(id object) {
    return (object && [object isKindOfClass:[NSString class]] &&
            ![(NSString *)object isEqualToString:@""] &&
            ![(NSString *)object isEqualToString:@"<null>"]);
}

NS_INLINE BOOL IsStringLengthGreaterThanZero(NSString * string) {
    return (string != nil && string.length > 0);
}

NS_INLINE BOOL IsDictionaryWithItems(id object) {
    return (object && [object isKindOfClass:[NSDictionary class]] &&
            [(NSDictionary *)object count] > 0);
}

//替换字典里的null
NS_INLINE id processDictionaryIsNSNull(id obj) {
    const NSString *blank = @"";
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dt = [(NSMutableDictionary*)obj mutableCopy];
        for(NSString *key in [dt allKeys]) {
            id object = [dt objectForKey:key];
            if([object isKindOfClass:[NSNull class]]) {
                [dt setObject:blank
                       forKey:key];
            }
            else if ([object isKindOfClass:[NSString class]]){
                NSString *strobj = (NSString*)object;
                if ([strobj isEqualToString:@"<null>"]) {
                    [dt setObject:blank
                           forKey:key];
                }
            }
            else if ([object isKindOfClass:[NSArray class]]){
                NSArray *da = (NSArray*)object;
                da = processDictionaryIsNSNull(da);
                [dt setObject:da
                       forKey:key];
            }
            else if ([object isKindOfClass:[NSDictionary class]]){
                NSDictionary *ddc = (NSDictionary*)object;
                ddc = processDictionaryIsNSNull(object);
                [dt setObject:ddc forKey:key];
            }
        }
        return [dt copy];
    }
    else if ([obj isKindOfClass:[NSArray class]]){
        NSMutableArray *da = [(NSMutableArray*)obj mutableCopy];
        for (int i=0; i<[da count]; i++) {
            NSDictionary *dc = [obj objectAtIndex:i];
            dc = processDictionaryIsNSNull(dc);
            [da replaceObjectAtIndex:i withObject:dc];
        }
        return [da copy];
    }
    else{
        return obj;
    }
}

//NS_INLINE BOOL IsArrayWithIndex(id object, NSInteger index) {
//    return (object && [object isKindOfClass:[NSArray class]] &&
//            [(NSArray *)object count] > index);
//}
//
//NS_INLINE BOOL IsSetWithItems(id object) {
//    return (object && [object isKindOfClass:[NSSet class]] &&
//            [(NSSet *)object count] > 0);
//}
//
//
///* postDataStr 和 dict 互转 */
//NS_INLINE NSDictionary * DicFromPostDataStr(NSString *postStr) {
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    if (!IsStringWithAnyText(postStr)) {
//        return nil;
//    }
//    for (NSString *param in [postStr componentsSeparatedByString:@"&"]) {
//
//        NSArray *vals = [param componentsSeparatedByString:@"="];
//        if ([vals count] == 2)
//        {
//            [dict setObject:[vals objectAtIndex:1] forKey:[vals objectAtIndex:0]];
//        }
//    }
//    return [dict copy];
//}
//
//#pragma mark - .pch 两个文件相互引用 todo
//@class UIViewController;
///* quickly get controller from storyboard */
//NS_INLINE UIViewController * GetInitialControllerFromeStroyboard(NSString *stbName) {
//    UIViewController *controller = nil;
//    if (IsStringWithAnyText(stbName)) {
//        UIStoryboard *story = [UIStoryboard storyboardWithName:stbName bundle:[NSBundle mainBundle]];
//        controller = [story instantiateInitialViewController];
//    }
//    return (UIViewController *)controller;
//}
//
//NS_INLINE LCBaseController * GetControllerFromeStroyboard(NSString *stbName, NSString *stbID) {
//    UIViewController *controller = nil;
//    if (IsStringWithAnyText(stbName) && IsStringWithAnyText(stbID)) {
//
//        UIStoryboard *story = [UIStoryboard storyboardWithName:stbName bundle:[NSBundle mainBundle]];
//        controller = [story instantiateViewControllerWithIdentifier:stbID];
//    }
//    return (UIViewController *)controller;
//}


#endif /* CodeFrameDefineCode_h */



#define KYOFM_CASE_INDEED(__v) - (NSString *)kyfm_caseIndeed:(NSArray *)array {if (![array isKindOfClass:[NSArray class]]){return nil;} for (id str in array) { if (![str isKindOfClass:[NSString class]]) {continue;}if ([str isEqualToString:SAFESTRING(__v)]) {return str;}}return nil;}

#define KYOFM_NULLOBJECT(__v) - (id)kyfm__v:(NSArray*)array{if (![array isKindOfClass:[NSArray class]]) {return nil;}for (id obj in array) {if (![obj isKindOfClass:[NSNull class]]) {continue;}return obj;}return nil;}

#define KYOFM_GETOBJECT(__p) - (id)kyfmDic__p:(NSDictionary*)dict { if (![dict isKindOfClass:[NSDictionary class]]) { return nil; } NSArray *keys = [dict allKeys]; for (NSString *key in keys) { if (![key isKindOfClass:[NSString class]]) { continue; } return dict[key]; } return nil; }

#define KYOFM_VIEW_ADD(__v,__x,__y,__w,__h)  {UIView *kyofm___v = [[UIView alloc]initWithFrame:CGRectMake(__x, __y,__w, __h)];kyofm___v.backgroundColor = [UIColor clearColor];[self.view addSubview:kyofm___v];kyofm___v.hidden = YES;}

#define WALME_BUTTON_ADD(__v,__x,__y,__w,__h)  { \
UIButton * WALME___v = [UIButton buttonWithType:UIButtonTypeCustom]; \
WALME___v.backgroundColor = [UIColor clearColor]; \
[self.view addSubview:WALME___v]; \
WALME___v.frame = CGRectMake(0, 0, 0, 0); \
WALME___v.hidden = YES; \
}

#define KYOFM_CODE_START(__v) {int ky_l__v = 0;for (ky_l__v = 0; ky_l__v < 1; ky_l__v++) {NSLog(@“%d”,ky_l__v);}}

#define KYOFM_CODE_END(__v,__str) {NSString *ky_string__v=[[NSString alloc]initWithFormat:__str];ky_string__v = SAFESTRING(ky_string__v);NSLog(@“the string is %@“, ky_string__v);}


#pragma mark - view & viewcontroller

#define WEAKSELF_WALME_CODE_ADDDATEVIEW [weakSelf p_walme_addMatchView];
#define SELF_WALME_CODE_ADDDATEVIEW [self p_walme_addMatchView];

#define WALME_CODE_ADDDATEVIEW - (void)p_walme_addMatchView {\
UIView * temp = nil;\
if ([self isKindOfClass:[UIViewController class]]) {\
temp = (UIView *)[self valueForKey:@"view"];\
} else {\
temp = (UIView *)self;\
}\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
UIView * dateView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 11, 11)];\
dateView.backgroundColor = [UIColor clearColor];\
dateView.layer.cornerRadius = dateView.width / 2;\
dateView.layer.masksToBounds = YES;\
[temp addSubview:dateView];\
[temp sendSubviewToBack:dateView];\
dateView.hidden = YES;\
}\
}\

#define WEAKSELF_WALME_CODE_ADDDATELAYER [weakSelf p_walme_addMatchLayer];
#define SELF_WALME_CODE_ADDDATELAYER [self p_walme_addMatchLayer];
#define WALME_CODE_ADDDATELAYER - (void)p_walme_addMatchLayer {\
UIView * temp = nil;\
if ([self isKindOfClass:[UIViewController class]]) {\
temp = (UIView *)[self valueForKey:@"view"];\
} else {\
temp = (UIView *)self;\
}\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
CALayer * layer = [CALayer layer];\
layer.backgroundColor = [UIColor clearColor].CGColor;\
CGFloat width = 30;\
layer.frame = CGRectMake(10, 10, width, width);\
layer.hidden = YES;\
layer.cornerRadius = width / 2;\
layer.masksToBounds = YES;\
[temp.layer insertSublayer:layer below:temp.layer];\
layer.opaque = YES;\
}\
}\

#define WEAKSELF_WALME_CODE_ADDDATEIMAGEVIEW [weakSelf p_walme_addDateImageView];
#define SELF_WALME_CODE_ADDDATEIMAGEVIEW [self p_walme_addDateImageView];
#define WALME_CODE_ADDDATEIMAGEVIEW - (void)p_walme_addDateImageView {\
UIView * temp = nil;\
if ([self isKindOfClass:[UIViewController class]]) {\
temp = (UIView *)[self valueForKey:@"view"];\
} else {\
temp = (UIView *)self;\
}\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
UIImageView * imageView = [[UIImageView alloc] init];\
imageView.backgroundColor = [UIColor clearColor];\
UIImage * image = [UIImage imageNamed:@"walme_user_4"];\
if (image) {\
imageView.frame = CGRectMake(10, 10, image.size.width, image.size.height);\
}\
[temp addSubview:imageView];\
[temp sendSubviewToBack:imageView];\
imageView.hidden = YES;\
}\
}\

#define WEAKSELF_WALME_CODE_ADDDATELABEL [weakSelf p_walme_addDateLabel];
#define SELF_WALME_CODE_ADDDATELABEL [self p_walme_addDateLabel];
#define WALME_CODE_ADDDATELABEL - (void)p_walme_addDateLabel {\
UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];\
UIView * temp = nil;\
if ([self isKindOfClass:[UIViewController class]]) {\
temp = (UIView *)[self valueForKey:@"view"];\
} else {\
temp = (UIView *)self;\
}\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
label.text = @"text";\
label.font = [UIFont fontWithName:@"" size:15];\
[label sizeToFit];\
label.hidden = YES;\
[temp addSubview:label];\
[temp sendSubviewToBack:label];\
label.left = temp.width - 200;\
label.top = temp.height - 100;\
}\
}\

#define WEAKSELF_WALME_CODE_ADDDATEBUTTON [weakSelf p_walme_addDateButton];
#define SELF_WALME_CODE_ADDDATEBUTTON [self p_walme_addDateButton];
#define WALME_CODE_ADDDATEBUTTON - (void)p_walme_addDateButton {\
UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];\
UIView * temp = nil;\
if ([self isKindOfClass:[UIViewController class]]) {\
temp = (UIView *)[self valueForKey:@"view"];\
} else {\
temp = (UIView *)self;\
}\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
[button addTarget:self action:@selector(p_walme_btnClick:) forControlEvents:UIControlEventTouchUpInside];\
button.backgroundColor = [UIColor clearColor];\
[button setTitle:@"back" forState:UIControlStateNormal];\
[temp addSubview:button];\
button.frame = CGRectMake(temp.width - 80, temp.height - 40, 80, 40);\
button.hidden = YES;\
[temp sendSubviewToBack:button];\
}\
}\

#define WEAKSELF_WALME_CODE_ADDDATESCROLLVIEW [weakSelf p_walme_addDateScrollView];
#define SELF_WALME_CODE_ADDDATESCROLLVIEW [self p_walme_addDateScrollView];
#define WALME_CODE_ADDDATESCROLLVIEW - (void)p_walme_addDateScrollView {\
UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];\
scrollView.left = 5;\
scrollView.top = 10;\
UIView * temp = nil;\
if ([self isKindOfClass:[UIViewController class]]) {\
temp = (UIView *)[self valueForKey:@"view"];\
} else {\
temp = (UIView *)self;\
}\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
scrollView.backgroundColor = [UIColor clearColor];\
scrollView.width = 300;\
scrollView.showsHorizontalScrollIndicator = NO;\
scrollView.showsVerticalScrollIndicator = NO;\
scrollView.height = 500;\
[temp addSubview:scrollView];\
scrollView.hidden = YES;\
[temp sendSubviewToBack:scrollView];\
}\
}\

#define WEAKSELF_WALME_CODE_ADDDATERESPONDER [weakSelf p_walme_addMatchResponder];
#define SELF_WALME_CODE_ADDDATERESPONDER [self p_walme_addMatchResponder];
#define WALME_CODE_ADDDATERESPONDER - (void)p_walme_addMatchResponder {\
UIView *temp = nil;\
if ([self isKindOfClass:[UIViewController class]]) {\
temp = (UIView *)[self valueForKey:@"view"];\
} else {\
temp = (UIView *)self;\
}\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
UIControl * control = [[UIControl alloc] init];\
[control addTarget:self action:@selector(p_walme_controlClick:) forControlEvents:UIControlEventTouchUpInside];\
control.hidden = YES;\
control.frame = CGRectMake(temp.width - 80, temp.height - 40, 80, 40);\
[temp addSubview:control];\
[temp sendSubviewToBack:control];\
}\
}\

#define WALME_CODE_BTNCLICK - (void)p_walme_btnClick:(UIButton *)sender {\
if (sender) {\
NSLog(@"%@", sender.description);\
sender.selected = !sender.selected;\
}\
}\

#define WALME_CODE_CONTROLCLICK - (void)p_walme_controlClick:(UIControl *)sender {\
if (sender) {\
sender.selected = !sender.selected;\
NSLog(@"%@", sender.description);\
}\
}\

#pragma mark - viewmodel

#define SELF_WALME_CODE_ARRAY(_f_count) [self p_walme_getArray:_f_count];
#define WALME_CODE_ARRAY(_f_count) - (NSArray *)p_walme_getArray:(int)_f_count {\
NSMutableArray * temps = [NSMutableArray arrayWithCapacity:_f_count];\
for (int i = 0; i < _f_count; i++) {\
int num = arc4random() % 89 + 1;\
[temps addObject:[NSNumber numberWithInt:num]];\
}\
return [temps copy];\
}\

#define SELF_WALME_CODE_DICTIONARY [self p_walme_getDictionary];
#define WALME_CODE_DICTIONARY - (NSDictionary *)p_walme_getDictionary {\
NSArray * keys = [self p_walme_getArray:5];\
NSArray * values = [self p_walme_getArray:5];\
NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:5];\
for (int i = 0; i < keys.count; i++) {\
NSString * key = [NSString stringWithFormat:@"%d", [keys[i] intValue]];\
NSString * value = [NSString stringWithFormat:@"%d", [values[i] intValue]];\
[dic setObject:value forKey:key];\
}\
return [dic copy];\
}\

#define SELF_WALME_CODE_SET(_f_count) [self p_walme_getSet:_f_count];
#define WALME_CODE_SET(_f_count) - (NSSet *)p_walme_getSet:(int)_f_count {\
NSMutableSet * temps = [NSMutableSet setWithCapacity:_f_count];\
for (int i = 0; i < _f_count; i++) {\
int num = arc4random() % 98 + 1;\
[temps addObject:[NSNumber numberWithInt:num]];\
}\
return [temps copy];\
}\

#define SELF_WALME_CODE_MUTABLEARRAY [self p_walme_getMutableArray];
#define WALME_CODE_MUTABLEARRAY - (NSMutableArray *)p_walme_getMutableArray {\
int count = arc4random() % 10 + 6;\
NSMutableArray * temps = [NSMutableArray arrayWithCapacity:count];\
for (int i = 0; i < count; i++) {\
[temps addObject:[NSNumber numberWithInt:21]];\
}\
return temps;\
}\

#define SELF_WALME_CODE_MUTALBEDICTIONARY [self p_walme_getMutableDictionary];
#define WALME_CODE_MUTALBEDICTIONARY - (NSMutableDictionary *)p_walme_getMutableDictionary {\
int count = arc4random() % 6;\
count += 5;\
NSArray * keys = [self p_walme_getArray:count];\
NSArray * values = [self p_walme_getArray:count];\
NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:count];\
for (int i = 0; i < keys.count; i++) {\
NSString * key = [NSString stringWithFormat:@"%d", [keys[i] intValue]];\
NSString * value = [NSString stringWithFormat:@"%d", [values[i] intValue]];\
[dic setObject:value forKey:key];\
}\
return dic;\
}\

#define SELF_WALME_CODE_MUTABLESET [self p_walme_getMutableSet];
#define WALME_CODE_MUTABLESET - (NSMutableSet *)p_walme_getMutableSet {\
int count = arc4random() % 8;\
count += 12;\
NSMutableSet * temps = [NSMutableSet setWithCapacity:count];\
for (int i = 0; i < count; i++) {\
[temps addObject:[NSNumber numberWithInt:i]];\
}\
return temps;\
}\

#define SELF_WALME_CODE_STRING [self p_walme_getString];
#define WALME_CODE_STRING - (NSString *)p_walme_getString {\
int count = arc4random() % 143;\
return [self p_walme_randomString:count];\
}\

#define SELF_WALME_CODE_MUTABLESTRING [self p_walme_getMutableString];
#define WALME_CODE_MUTABLESTRING - (NSMutableString *)p_walme_getMutableString {\
int count = arc4random() % 112;\
NSString * str = [self p_walme_randomString:count];\
return [NSMutableString stringWithString:str];\
}\

#define SELF_WALME_CODE_ENUM(_f_object) [self p_walme_enum:_f_object];
#define WALME_CODE_ENUM(_f_object) - (void)p_walme_enum:(id)_f_object {\
if (!_f_object) return;\
if ([_f_object isKindOfClass:[NSArray class]]) {\
NSArray * array = (NSArray *)_f_object;\
if (array.count > 4) {\
[array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {\
if (idx == 45) {\
NSLog(@"%@", obj);\
}\
}];\
}\
}\
else if ([_f_object isKindOfClass:[NSString class]]) {\
NSString * string = (NSString *)_f_object;\
if (string.length > 1) {\
NSLog(@"is string: %@", string);\
}\
}\
}\

#define SELF_WALME_CODE_FOR(_f_object) [self p_walme_for:_f_object];
#define WALME_CODE_FOR(_f_object) - (void)p_walme_for:(id)_f_object {\
if (!_f_object) return;\
if ([_f_object isKindOfClass:[NSArray class]]) {\
NSArray * array = (NSArray *)_f_object;\
if (array.count > 13) {\
for (int i = 0; i < array.count; i++) {\
if (i == 6) {\
NSLog(@"%@", array[i]);\
}\
}\
}\
}\
else if ([_f_object isKindOfClass:[NSString class]]) {\
NSString * string = (NSString *)_f_object;\
if (string.length > 4) {\
NSLog(@"is string: %@", string);\
}\
}\
}\

#define SELF_WALME_CODE_DISAPPLY(_f_object) [self p_walme_dispatchApply:_f_object];
#define WALME_CODE_DISAPPLY(_f_object) - (void)p_walme_dispatchApply:(id)_f_object {\
if (!_f_object) return;\
if ([_f_object isKindOfClass:[NSArray class]]) {\
NSArray * array = (NSArray *)_f_object;\
if (array.count > 5) {\
dispatch_apply(array.count, dispatch_get_global_queue(0, 0), ^(size_t index) {\
if (index == 6) {\
NSLog(@"sixth is %@", array[index]);\
}\
});\
}\
}\
else if ([_f_object isKindOfClass:[NSString class]]) {\
NSString * string = (NSString *)_f_object;\
if (string.length > 6) {\
NSLog(@"is string: %@", string);\
}\
}\
}\

#define SELF_WALME_CODE_RANDOMSTRING(_f_count) [self p_walme_randomString:_f_count];
#define WALME_CODE_RANDOMSTRING(_f_count) - (NSString *)p_walme_randomString:(NSInteger)_f_count {\
NSUInteger totalCount = MAX(149, _f_count);\
NSString *ramdom;\
NSMutableArray *array = [NSMutableArray array];\
for (int i = 1; i ; i ++) {\
int a = (arc4random() % 102); \
if (a > 56) {\
char c = (char)a;\
[array addObject:[NSString stringWithFormat:@"%c",c]];\
if (array.count == totalCount) {\
break;\
}\
} else continue;\
}\
ramdom = [array componentsJoinedByString:@""];\
return ramdom;\
}\

#pragma mark - func defines

/* tips */
#define kShowPopTip(view_,title_,message_)      \
[LCLoadingTool showAlertTitle:title_ message:message_ toView:view_];

#define kShowSPopTip(view_,title_,message_,delay_)      \
[LCLoadingTool showSmallAlertTitle:title_ message:message_ toView:view_ afterDelay:delay_];

#define kShowPopView(view_,title_,message_,imageName_)      \
[LCLoadingTool showWhiteAlertTitle:title_ message:message_ imageName:imageName_ toView:view_];

#define kShowAlert(title_,msg_,btnTitle_)        \
LCAlertController *alert = [LCAlertController alertControllerWithTitle:title_ message:msg_ preferredStyle:UIAlertControllerStyleAlert];   \
[alert addActionWithTitle:btnTitle_ style:UIAlertActionStyleDefault handler:nil];   \
[alert show];

#define kShowStatusBarTips(tip_,img_,bgColor_)  \
[LCINSTANCE_AppDelegate showStatusBarTips:tip_ image:img_ bgColor:bgColor_];
/* loading  */
#define kShowLoadingInView(view_,style_)        \
[LCLoadingTool showLoadingInView:view_ style:style_];

#define kHideLoadingInView(view_)               \
[LCLoadingTool hideLoadingInView:view_];

/* font */
// 正常字体
//#define kFontEach(var_5_5_inch_font, var_4_7_inch_font, var_4_inch_font) \
//((!kIs5_5InchScreen && !kIsIpad) ? \
//(kIs4_7InchScreen ? [UIFont systemFontOfSize:var_4_7_inch_font] : [UIFont systemFontOfSize:var_4_inch_font]) : [UIFont systemFontOfSize:var_5_5_inch_font])
//// 粗体
//#define kBlocFontEach(var_5_5_inch_font, var_4_7_inch_font, var_4_inch_font) \
//((!kIs5_5InchScreen && !kIsIpad) ? \
//(kIs4_7InchScreen ? [UIFont boldSystemFontOfSize:var_4_7_inch_font] : [UIFont boldSystemFontOfSize:var_4_inch_font]) : [UIFont boldSystemFontOfSize:var_5_5_inch_font])
//
//#define LCSize(var_5_5_inch_size, var_4_7_inch_size, var_4_inch_size) \
//((!kIs5_5InchScreen && !kIsIpad) ? \
//(kIs4_7InchScreen ? var_4_7_inch_size : var_4_inch_size) : var_5_5_inch_size)
//
//
//#define kFontFromPx(px)                 kFontEach(px / 2, px / 2, px / 2)
//#define kBoldFontFromPx(px)             kBlocFontEach(px / 2 + 1, px / 2, px / 2)

//NSAssert/NSCAssert 两者的差别通过定义可以看出来, 前者是适合于Objective-C的方法,_cmd 和 self 与运行时有关. 后者是适用于C的函数.
//NSParameterAssert/NSCparameterAssert两者的区别也是前者适用于Objective-C的方法,后者适用于C的函数.
//
//NSAssert/NSCAssert 和 NSParameterAssert/NSCparameterAssert 的区别是前者是所有断言, 后者只是针对参数是否存在的断言, 所以可以先进行参数的断言,确认参数是正确的,再进行所有的断言,确认其他原因.

//@weakify(self)
//#define weakify(...) \
//rac_keywordify \
//metamacro_foreach_cxt(rac_weakify_,, __weak, __VA_ARGS__)
//
//#define strongify(...) \
//rac_keywordify \
//_Pragma("clang diagnostic push") \
//_Pragma("clang diagnostic ignored \"-Wshadow\"") \
//metamacro_foreach(rac_strongify_,, __VA_ARGS__) \
//_Pragma("clang diagnostic pop")
//
//
//#define metamacro_foreach_cxt(MACRO, SEP, CONTEXT, ...) \
//metamacro_concat(metamacro_foreach_cxt, metamacro_argcount(__VA_ARGS))(MACRO, SEP, CONTEXT, __VA_ARGS)
//
//#define metamacro_concact(A, B) \
//metamacro_concact_(A, B)
//
//#define metamacro_concact_(A, B) A##B
//
//#define metamacro_argcount(...) \
//metamacro_at(20, __VA_ARGS__, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
//
//#define metamacro_at(N, ...) \
//metamacro_concat(metamacro_at, N)(__VA_ARGS)
//
//#define metamacro_at20(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, ...) metamacro_head(__VA_ARGS__)
//
//#define metamacro_head(...) \
//metamacro_head(__VA_ARGS, 0)
//
//#define metamacro_head_(FIRST, ...) FIRST
//
//#define metamacro_foreach_cxt1(MACRO, SEP, CONTEXT, _0) MACRO(0, CONTEXT, _0)
//
//#define rac_weakify(INDEX, CONTEXT, VAR) \
//CONTEXT __typeof__(VAR) metamacro_concact(VAR, __weak) = (VAR);
//
//#if DEBUG
//#define rac_keywordify autoreleasepool{}
//#else
//#define rac_keywordify try {} @catch(...) {}
//#endif

// metamacro_foreach_cxt1(MACRO, SEP, CONTEXT, ...)
// metamacro_foreach_cxt1(rac_weakify_,, __weak)
// rac_weakify_(0, __weak, __VA_ARGS)
//__weak __typeof(self) self__weak = (self);


// metamacro_at(20, self, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
// metamacro_concat(metamacro_at, 20)(self, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
// metamacro_at20(self, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
// metamacro_head(1)

//#endif /* CodeFrameDefineCode_h */
