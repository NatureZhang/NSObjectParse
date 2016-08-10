//
//  ObjectProperty.m
//
//  Created by zhangdong on 16/5/27.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import "ObjectProperty.h"

@implementation ObjectProperty

- (void)setProperty:(objc_property_t)property {
    
    _property = property;
    
    // 属性名
    _pName = @(property_getName(property));
    
    // 属性类型
    // T@"NSString",C,N,V_name  // 因为有数值类型，所以这样写不行
//    NSString *pAttri = @(property_getAttributes(property));
//    NSRange range1 = [pAttri rangeOfString:@"\""];//第一个引号
//    NSString *tmpStr = [pAttri substringFromIndex:range1.location+range1.length];
//    NSRange range2 = [tmpStr rangeOfString:@"\""];//第二个引号
//    NSString *pClass = [tmpStr substringToIndex:range2.location];
//    
//    _pType = pClass;
}

@end
