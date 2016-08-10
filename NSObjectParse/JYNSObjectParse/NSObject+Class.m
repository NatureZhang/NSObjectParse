//
//  NSObject+Class.m
//
//  Created by zhangdong on 16/5/27.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import "NSObject+Class.h"
#import <objc/runtime.h>
#import "ObjectProperty.h"

@implementation NSObject (Class)

+ (NSArray *)properties {
    
    NSMutableArray *propertiesArray = [NSMutableArray array];
    
    Class class = self;
    
    while (class != [NSObject class]) {
        
        unsigned int pCount = 0;
        objc_property_t *properties = class_copyPropertyList(class, &pCount);
        
        for (int i = 0; i < pCount; i ++) {
            
            // 取出属性
            ObjectProperty *objectProperty = [[ObjectProperty alloc] init];
            objectProperty.property = properties[i];
            [propertiesArray addObject:objectProperty];
        }
        
        free(properties);
        class = class_getSuperclass(class);
    }
    
    return propertiesArray;
}

// 框架类
- (BOOL)isFoundationClass {
    
    if ([self isKindOfClass:[NSString class]]
        || [self isKindOfClass:[NSNumber class]]
        || [self isKindOfClass:[NSNull class]]
        || [self isKindOfClass:[NSURL class]]
        || [self isKindOfClass:[NSValue class]]
        || [self isKindOfClass:[NSData class]]
        || [self isKindOfClass:[NSError class]]
        || [self isKindOfClass:[NSAttributedString class]]) {
        
        return YES;
    }
    
    return NO;
}

@end
