//
//  Struct.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "Struct.h"

#import <algorithm>

namespace FB { namespace RetainCycleDetector { namespace Parser {
    void Struct::passTypePath(std::vector<std::string> typePath) {
        this->typePath = typePath;
        
        if (name.length() > 0) {
            // = push_back
            typePath.emplace_back(name);
        }
        if (structTypeName.length() > 0 && structTypeName != "?") {
            typePath.emplace_back(structTypeName);
        }
        for (auto &type: typesContainedInStruct) {
            type->passTypePath(typePath);
        }
    }
    
    // shared_ptr 指向新的对象时 引用计数+1 离开时-1
    std::vector<std::shared_ptr<Type>> Struct::flattenTypes() {
        std::vector<std::shared_ptr<Type>> flattenedTypes;
        
        for (const auto &type: typesContainedInStruct) {
            // dynamic_pointer_cast 强制类型转换
            const auto maybeStruct = std::dynamic_pointer_cast<Struct>(type);
            if (maybeStruct) {
                // Complex type, recursively grab all references
                flattenedTypes.reserve(flattenedTypes.size() + std::distance(maybeStruct->typesContainedInStruct.begin(),
                                                                             maybeStruct->typesContainedInStruct.end()));
                flattenedTypes.insert(flattenedTypes.end(),
                                      maybeStruct->typesContainedInStruct.begin(),
                                      maybeStruct->typesContainedInStruct.end());
            } else {
                // Simple type
                flattenedTypes.emplace_back(type);
            }
        }
        
        return flattenedTypes;
    }
} } }
