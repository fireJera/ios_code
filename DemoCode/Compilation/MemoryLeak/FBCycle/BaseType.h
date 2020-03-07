//
//  BaseType.h
//  Compilation
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <string>

namespace FB { namespace RetainCycleDetector { namespace Parser {
    class BaseType {
    public:
        // 虚函数 希望子类去重载 不要调用父类的实现
        virtual ~BaseType() {}
    };
    
    class Unresolved: public BaseType {
    public:
        std::string value;
        Unresolved(std::string value): value(value) {}
        // = default 编译器生成默认实现
        // 该函数比用户自己定义的默认构造函数获得更高的代码效率
        Unresolved(Unresolved&&) = default;
        Unresolved &operator=(Unresolved&&) = default;
        
        // Unresolved a, b  = delete 应该类似于ns_unavaiable
        // a = Unresolved(b) error
        Unresolved(const Unresolved&) = delete;
        // a = b error
        Unresolved &operator=(const Unresolved&) = delete;
    };
}}}
