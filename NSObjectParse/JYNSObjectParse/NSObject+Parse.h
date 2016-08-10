//
//  NSObject+Parse.h
//
//  Created by zhangdong on 16/5/20.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParseKeyValueProtocol <NSObject>

@optional

/// 如果有数组属性，实现该方法 返回数组中元素类型字典
+ (NSDictionary *)dictObjectTypeInArray;

/// 属性值的别名  @{@"anotherName" : @"realName"}  ps:模型转字典不支持属性名替换
+ (NSDictionary *)dictPropertyAnotherName;
@end

@interface NSObject (Parse)<ParseKeyValueProtocol>

/// 最外层是数组
+ (NSArray *)objectArrayWithValueArray:(NSArray *)valueArray;

/// 字典 转 模型
+ (instancetype)objectWithKeyValues:(NSDictionary *)keyValues;

/// 模型 转 字典
- (NSDictionary *)dictInstanceKeyValues;

/// 模型数组 转 数组
+ (NSArray *)arrayKeyValuesWithObjectArray:(NSArray *)arrObject;
@end
