//
//  Test.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/27.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct TestStruct {
    int sa;
    char sb;
//    char *structName;
};

union MoneyUnion {
    float alone;
    double down;
};

typedef int(^TestBlock)(float a);

@interface Test : NSObject {
    // 实例变量 在布局时不会进行内存优化
    NSObject * _objcet;                 // encoding : @"NSObject"

    int _intI;                          // encoding : i
    short _shortS;                      // encoding : s
    char _charC;                        // encoding : c
    long _longL;                        // encoding : q
    long long _longlong;                // encoding : q
    unsigned char _ucharC;              // encoding : C
    unsigned int _uintI;                // encoding : I
    unsigned short _ushortS;            // encoding : S
    unsigned long _ulongL;              // encoding : Q
    unsigned long long _ulonglong;      // encoding : Q
    float _floatF;                      // encoding : f
    double _doubleD;                    // encoding : d
    bool _boolB;                        // encoding : B
    BOOL _ocBOOL;                       // encoding : B
    char * _charxing;                   // encoding : *
    
    Class _tempCls;                     // encoding : #  
    SEL _selector;                      // encoding : :
    int _array[10];                     // encoding : [10i]
    SEL _selectors[5];                  // encoding : [5:]
    struct TestStruct _nameStruct;      // encoding : {TestStruct="sa"i"sb"c}
    union MoneyUnion _unionVar;         // encoding : (MoneyUnion="alone"f"down"d)
    void * _voidptr;                    // encoding : ^v
    int * _intPtr;                      // encoding : ^i
    int ** _intPtrPtr;
    struct TestStruct * _structPtr;     // encoding : ^{TestStruct=ic}
    int(*intReturnFunc)(int);           // encoding : ^?
    __weak NSArray * _arrayObj;                // encoding : @"NSArray"
}

// 只有属性在布局时才会进行内存优化
@property (nonatomic, strong) NSObject * _object;
@property (nonatomic) int intI;
@property (nonatomic) short shortS;
@property (nonatomic) char charC;

@property (nonatomic, copy) NSString * name;                                // T@"NSString",C,N,V_name

@property struct TestStruct structPro;                                      // T{TestStruct=ic},V_structPro
@property struct TestStruct * structPtrPro;                                 // T^{TestStruct=ic},V_structPtrPro
@property union MoneyUnion unionPro;                                        // T(MoneyUnion=fd),V_unionPro
@property union MoneyUnion * unionPtrPro;                                   // T^(MoneyUnion=fd),V_unionPtrPro
@property id idPro;                                                         // T@,&,V_idPro
@property NSObject * objPro;                                                // T@"NSObject",&,V_objPro

@property(getter=intGetFoo, setter=intSetFoo:) int intSetterGetter;         // Ti,GintGetFoo,SintSetFoo:,V_intSetterGetter
@property(readonly) int intReadonly;                                        // Ti,R,V_intReadonly
@property(readwrite) int intReadwrite;                                      // Ti,V_intReadwrite
@property(copy) NSObject * objCopy;                                         // T@"NSObject",C,V_objCopy
@property(strong) NSObject * objStrong;                                     // T@"NSObject",&,V_objStrong@end
@property(retain) id objReatin;                                             // T@,&,V_objReatin
@property(weak) NSObject * objWeak;                                         // T@"NSObject",W,V_objWeak
@property(nonatomic, readwrite, nonnull) NSObject * nonnullObj;             // T@"NSObject",&,N,V_nonnullObj
@property(nonatomic, readwrite, nullable) NSObject * nullableObj;           // T@"NSObject",&,N,V_nullableObj
@property (nonatomic, copy) TestBlock testBlock;

@end

@interface TestA : Test

+ (void)classMethod;

- (void)instanceMethod:(int)method;

@end

NS_ASSUME_NONNULL_END
