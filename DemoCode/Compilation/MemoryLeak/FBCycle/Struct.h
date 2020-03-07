//
//  Struct.h
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Type.h"
#import <memory>
#import <string>
#import <vector>

// std::vector 应该可以理解为NSMutableArray 动态分配内存的数组 特点 1.顺序序列 2.动态数组 3.感知内存分配

namespace FB { namespace RetainCycleDetector { namespace Parser {
    class Struct: public Type {
    public:
        const std::string structTypeName;
        
        Struct(const std::string &name,
               const std::string &typeEncoding,
               const std::string &structTypeName,
               std::vector<std::shared_ptr<Type>> &typesContainedInStruct)
        : Type(name, typeEncoding),
        structTypeName(structTypeName),
        typesContainedInStruct(std::move(typesContainedInStruct)) {};
        Struct(Struct&&) = default;
        Struct &operator=(Struct&&) = default;
        
        Struct(const Struct &) = delete;
        Struct &operator=(const Struct&) = delete;
        
        std::vector<std::shared_ptr<Type>> flattenTypes();
        
        virtual void passTypePath(std::vector<std::string> typePath);
        std::vector<std::shared_ptr<Type>> typesContainedInStruct;
    };
}}}
