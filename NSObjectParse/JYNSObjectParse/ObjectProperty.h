//
//  ObjectProperty.h
//
//  Created by zhangdong on 16/5/27.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface ObjectProperty : NSObject

@property (nonatomic, copy, readonly) NSString *pName;
@property (nonatomic, copy, readonly) NSString *pType;

@property (nonatomic, assign) objc_property_t property;

@end
