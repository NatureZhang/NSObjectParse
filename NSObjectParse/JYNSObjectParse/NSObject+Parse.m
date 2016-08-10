//
//  NSObject+Parse.m
//
//  Created by zhangdong on 16/5/20.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import "NSObject+Parse.h"
#import "NSObject+Class.h"
#import "ObjectProperty.h"
#import <objc/runtime.h>

static NSString *const crashLogString = @"需要在类中实现dictObjectTypeInClassOrArray方法返回自定义属性类型....";

@implementation NSObject (Parse)

+ (NSArray *)objectArrayWithValueArray:(NSArray *)valueArray {

    NSMutableArray *arrayModel = [NSMutableArray array];
    NSArray *tmpArray = valueArray;
    
    // 遍历
    for (int i = 0; i < tmpArray.count; i ++) {
        
        id object = tmpArray[i];
        if ([object isFoundationClass]) {
            [arrayModel addObject:object];
        }
        
        if ([object isKindOfClass:[NSArray class]]) {
            
            [arrayModel addObject:[self objectArrayWithValueArray:object]];
            
        }
        
        if ([object isKindOfClass:[NSDictionary class]]) {
            
            id model = [self objectWithKeyValues:object];
            [arrayModel addObject:model];
            
        }
    }
    
    return arrayModel;
}

/// 字典转模型
+ (instancetype)objectWithKeyValues:(NSDictionary *)keyValues {
    
    // 创建一个对象
    id object = [[self alloc] init];
    
    NSArray *propertiesArray = [self properties];
    
    for (int i = 0; i < [propertiesArray count]; i ++) {
        
        // 取出属性
        ObjectProperty *property = propertiesArray[i];
        
        // 取出属性名
        NSString *pNameStr = property.pName;
        
        id pValue = nil;
        
        if ([self respondsToSelector:@selector(dictPropertyAnotherName)]) {
            NSDictionary *dicAnotherName = [self dictPropertyAnotherName];
            
            NSString *realPName = dicAnotherName[pNameStr];
            
            if (realPName) {
                pValue = keyValues[realPName];
            }
            else {
                pValue = keyValues[pNameStr];
            }
        }
        else{
            // 取出字典中与属性名一样的值
            pValue = keyValues[pNameStr];
        }
        
        // 当值的类型是字典时
        if ([pValue isKindOfClass:[NSDictionary class]]) {
            
            objc_property_t pro = property.property;
            NSString *pAttri = @(property_getAttributes(pro));
            NSRange range1 = [pAttri rangeOfString:@"\""];//第一个引号
            NSString *tmpStr = [pAttri substringFromIndex:range1.location+range1.length];
            NSRange range2 = [tmpStr rangeOfString:@"\""];//第二个引号
            NSString *pType = [tmpStr substringToIndex:range2.location];
            
            
            id pClass = NSClassFromString(pType);
            pValue = [pClass objectWithKeyValues:pValue];
            
        }
        
        // 当值的类型为数组时
        if ([pValue isKindOfClass:[NSArray class]]) {
            
            // 数组中是模型 必须实现这个方法 objectClassInArray
            if ([self respondsToSelector:@selector(dictObjectTypeInArray)]) {
                
                // 数组中类型字典
                NSDictionary *dictObjcType = [self dictObjectTypeInArray];
                NSArray *arrayValues = pValue;
                NSMutableArray *arrMTemp = [NSMutableArray array];
                
                for (int i = 0; i < arrayValues.count; i ++) {
                    
                    id item = [arrayValues objectAtIndex:i];
                    // 数组中类
                    id varType = NSClassFromString([dictObjcType objectForKey:pNameStr]);
                    
                    if ([item isKindOfClass:[NSDictionary class]]) {
                        
                        NSDictionary *dict = item;
                        
                        // 为类赋值
                        id varValue = [varType objectWithKeyValues:dict];
                        
                        // 类名错误 对象没有值
                        if (varType == nil || varValue == nil) {

                            NSAssert(false, crashLogString);
                            
                        } else {
                            
                            [arrMTemp addObject:varValue];
                        }

                        
                    }else if([item isKindOfClass:[NSArray class]]){
                        
                        NSArray *array = item;
                        NSArray *objArray = [varType objectArrayWithValueArray:array];
                        [arrMTemp addObject:objArray];
                        
                    }else{
                        
                        [arrMTemp addObject:item];
                        
                    }
                }
                
                pValue = [NSArray arrayWithArray:arrMTemp];
                
            }else{
                
                 NSAssert(false, crashLogString);
            }
        }
        // 赋值
        if (pValue) {
            
            [object setValue:pValue forKey:pNameStr];
            
        } else {

        }
    }
    
    return object;
}

 
// 模型转字典
- (NSDictionary *)dictInstanceKeyValues {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    Class class = [self class];

    NSArray *properties = [class properties];
    
    for (int i = 0; i < properties.count; i ++) {
        
        // 取出属性名
        ObjectProperty *pro = properties[i];
        NSString *pNameStr = pro.pName;
        
        id pValue = [self valueForKey:pNameStr];
        
        if([pValue isFoundationClass]) {
            // FoundationClass
            
        } else if([pValue isKindOfClass:[NSArray class]]){
            // 数组
            
            NSArray *objarr = pValue;
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
            
            for (int i = 0; i < objarr.count; i ++) {
                
                id object = [objarr objectAtIndex:i];
                
                if ([object isKindOfClass:[NSArray class]]) {
                    
                    [arr setObject:[[self class] arrayKeyValuesWithObjectArray:object] atIndexedSubscript:i];
                    
                } else {
                    
                    [arr setObject:[object dictInstanceKeyValues] atIndexedSubscript:i];
                    
                }
            }
            
            pValue = arr;
            
        } else {
            
            // 自定义对象
            pValue = [pValue dictInstanceKeyValues];
        }
        
        if (pValue == nil) {
            pValue = [NSNull null];
        }
        
        [dic setObject:pValue forKey:pNameStr];
    }
    
    return dic;
}

+ (NSArray *)arrayKeyValuesWithObjectArray:(NSArray *)arrObject {
    
    NSMutableArray *arrayKeyValues = [NSMutableArray array];
    NSArray *arrTmp = arrObject;
    
    for (int i = 0; i < arrTmp.count; i ++) {
        
        id object = [arrTmp objectAtIndex:i];
        
        if ([object isFoundationClass]) {
            
            [arrayKeyValues addObject:object];
            
        }else if ([object isKindOfClass:[NSArray class]]) {
            
            [arrayKeyValues addObject:[self arrayKeyValuesWithObjectArray:object]];
            
        }else{
            
            [arrayKeyValues addObject:[object dictInstanceKeyValues]];
        }
    }
    
    return arrayKeyValues;
}

@end
