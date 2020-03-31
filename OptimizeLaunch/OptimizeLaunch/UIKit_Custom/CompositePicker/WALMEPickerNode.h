//
//  WALMEPickerNode.h
//  CodeFrame
//
//  Created by hd on 2019/4/13.
//  Copyright © 2019年 JersiZhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WALMEPickerNode : NSObject

// 节点名字
@property (nonatomic, copy) NSString *nodeName;

// 子节点集合
@property (nonatomic, strong) NSMutableArray<WALMEPickerNode *> *childNodes;

// 初始化
+ (instancetype)nodeWithNodeName:(NSString *)nodeName;

// 添加子节点
- (void)addNode:(WALMEPickerNode *)node;

// 删除子节点
- (void)removeNode:(WALMEPickerNode *)node;

// 获取子节点
- (WALMEPickerNode *)childNodeAtIndex:(NSInteger)index;

//获取树结构的深度
- (NSInteger)treeDepth;

//当前节点的度（子节点的个数）
- (NSInteger)nodeDegree;

@end
