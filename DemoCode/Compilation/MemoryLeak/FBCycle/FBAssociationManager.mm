//
//  FBAssociationManager.m
//  MemoryLeak
//
//  Created by Jeremy on 2019/6/24.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#if __has_feature(objc_arc)
#error This file must be compiled with MRR. Use -fno-objc-arc flag.
#endif

#import <algorithm>
#import <map>
#import <mutex>
#import <objc/runtime.h>
#import <unordered_map>
#import <unordered_set>
#import <vector>

#import "FBAssociationManager+Internal.h"
#import "FBRetainCycleDetector.h"

#import "fishhook.h"

#if _INTERNAL_RCD_ENABLED

namespace FB { namespace AssociationManager {
    /*
     using 四个作用:
     1. using namespace 命名o空间
     2. using name = typename 起别名 和typedef一样
     3 && 4. https://www.jianshu.com/p/a6ce5ead071f
     */
    using ObjectAssociationSet = std::unordered_set<void *>;  // hash 表的实现 (目测)
    using AssociationMap = std::unordered_map<id, ObjectAssociationSet *>; // NSDictionary 的实现(目测)
    
    static auto _associationMap = new AssociationMap();
    static auto _associationMutex = new std::mutex; //c++ 中最基本的互斥量
    
    static std::mutex * hookMutex(new std::mutex);
    static bool hookTaken = false;
    // 将某个object的key对应的value删除(意图为强引用变为弱引用的时候删除强引用的值) 弱引用的时候调用
    void _threadUnsafeResetAssociationAtKey(id object, void *key) {
        auto i = _associationMap->find(object);
        
        if (i == _associationMap->end()) {
            return;
        }
        auto *refs = i->second;
        auto j = refs->find(key);
        if (j != refs->end()) {
            refs->erase(j);
        }
    }
    
    // 将某个object的key 保存 强引用的时候调用
    void _threadUnsafeSetStrongAssociation(id object, void * key, id value) {
        if (value) {
            auto i = _associationMap->find(object);
            ObjectAssociationSet *refs;
            if (i != _associationMap->end()) {
                refs = i->second;
            } else {
                refs = new ObjectAssociationSet;
                (*_associationMap)[object] = refs;
            }
            refs->insert(key);
        } else {
            _threadUnsafeResetAssociationAtKey(object, key);
        }
    }
    
    // 将某个object的所有key删除
    void _threadUnsafeRemoveAssociations(id object) {
        if (_associationMap->size() == 0) {
            return;
        }
        auto i = _associationMap->find(object);
        if (i == _associationMap->end()) {
            return;
        }
        auto * refs = i->second;
        delete refs;
        _associationMap->erase(i);
    }
    
    // 通过object的所有key获得其所有的value
    NSArray * associations(id object) {
        // 正常的 锁和解锁 可能会出现死锁 那么使用lockguard 则保证锁只在 {} 内有效
        //            _associationMutex->lock();
        //            _associationMutex->unlock();
        std::lock_guard<std::mutex> l(*_associationMutex);
        
        if (_associationMap->size() == 0) {
            return nil;
        }
        auto i = _associationMap->find(object);
        if (i == _associationMap->end()) {
            return nil;
        }
        
        auto *refs = i->second;
        NSMutableArray * array = [NSMutableArray array];
        for (auto *key: *refs) {
            id value = objc_getAssociatedObject(object, key);
            if (value) {
                [array addObject:value];
            }
        }
        return array;
    }
    
    static void(*fb_orig_objc_setAssociatedObject)(id object, void *key, id value, objc_AssociationPolicy policy);
    static void(*fb_orig_objc_removeAssociatedObjects)(id object);
    
    static void fb_objc_setAssociatedObject(id object, void * key, id value, objc_AssociationPolicy policy) {
        {
            std::lock_guard<std::mutex> l(*_associationMutex);
            if (policy == OBJC_ASSOCIATION_RETAIN ||
                policy == OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
                _threadUnsafeSetStrongAssociation(object, key, value);
            } else {
                _threadUnsafeResetAssociationAtKey(object, key);
            }
        }
        
        fb_orig_objc_setAssociatedObject(object, key, value, policy);
    }
    
    static void fb_objc_removeAssociatedObjects(id object) {
        {
            std::lock_guard<std::mutex> l(*_associationMutex);
            _threadUnsafeRemoveAssociations(object);
        }
        fb_orig_objc_removeAssociatedObjects(object);
    }
    
    static void cleanUp() {
        std::lock_guard<std::mutex> l(*_associationMutex);
        _associationMap->clear();
    }
} }

#endif

@implementation FBAssociationManager

+ (void)hook {
#if _INTERNAL_RCD_ENABLED
    std::lock_guard<std::mutex> l(*FB::AssociationManager::hookMutex);
    rcd_rebind_symbols((struct rcd_rebinding[2]) {
        {
            "objc_setAssociatedObject",
            (void *)FB::AssociationManager::fb_objc_setAssociatedObject,
            (void **)&FB::AssociationManager::fb_orig_objc_setAssociatedObject
        },
        {
            "objc_getAssociatedObject",
            (void *)FB::AssociationManager::fb_objc_removeAssociatedObjects,
            (void **)&FB::AssociationManager::fb_orig_objc_removeAssociatedObjects
        }}, 2);
    FB::AssociationManager::hookTaken = true;
#endif
}

+ (void)unhook {
#if _INTERNAL_RCD_ENABLED
    std::lock_guard<std::mutex> l(*FB::AssociationManager::hookMutex);
    if (FB::AssociationManager::hookTaken) {
        rcd_rebind_symbols((struct rcd_rebinding[2]){
            {
                "objc_setAssociatedObject",
                (void *)FB::AssociationManager::fb_orig_objc_setAssociatedObject,
            },
            {
                "objc_getAssociatedObject",
                (void *)FB::AssociationManager::fb_orig_objc_removeAssociatedObjects,
            }
        }, 2);
        FB::AssociationManager::cleanUp();
    }
#endif
}

+ (NSArray *)associationsForObject:(id)object {
#if _INTERNAL_RCD_ENABLED
    return FB::AssociationManager::associations(object);
#else
    return nil;
#endif
}

@end


