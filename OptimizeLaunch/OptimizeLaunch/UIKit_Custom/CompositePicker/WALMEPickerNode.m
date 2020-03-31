//
//  WALMEPickerNode.m
//  CodeFrame
//
//  Created by hd on 2019/4/13.
//  Copyright © 2019年 JersiZhu. All rights reserved.
//

#import "WALMEPickerNode.h"

@implementation WALMEPickerNode{
    NSInteger _treeDepth;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.childNodes = [NSMutableArray array];
    }
    return self;
}

// 初始化
+ (instancetype)nodeWithNodeName:(NSString *)nodeName {
    WALMEPickerNode *node = [[[self class] alloc] init];
    node.nodeName = nodeName;
    
    return node;
}

// 添加子节点
- (void)addNode:(WALMEPickerNode *)node {
    [self.childNodes addObject:node];
}

// 删除子节点
- (void)removeNode:(WALMEPickerNode *)node {
    [self.childNodes removeObject:node];
}

// 获取子节点
- (WALMEPickerNode *)childNodeAtIndex:(NSInteger)index {
    if (index >= self.childNodes.count) {
        return nil;
    } else {
        return self.childNodes[index];
    }
}

- (NSInteger)treeDepth {
    _treeDepth = 0;
    [self countDepthChildOfNode:self];
    
    return _treeDepth;
}

- (void)countDepthChildOfNode:(WALMEPickerNode *)node {
    if (node.childNodes.count) {
        _treeDepth ++;
        [self countDepthChildOfNode:[node childNodeAtIndex:0]];
    }
}

- (NSInteger)nodeDegree {
    return self.childNodes.count;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"node - %@",self.nodeName];
}

@end
