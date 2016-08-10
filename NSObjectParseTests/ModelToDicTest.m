//
//  ModelToDic.m
//  UnitTestDemo
//
//  Created by zhangdong on 16/7/19.
//  Copyright © 2016年 __Nature__. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+Parse.h"

@interface UserModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSNumber *age;
@end
@implementation UserModel
@end

@interface UserModelDesc : NSObject
@property (nonatomic, strong) NSString *modelDesc;
@property (nonatomic, strong) UserModel *userModel;
@end
@implementation UserModelDesc
@end

@interface ModelToDicTest : XCTestCase

@end

@implementation ModelToDicTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testModelToDic {
    UserModel *user = [[UserModel alloc] init];
    user.name = @"zhangdong";
    user.nickName = @"zhang-dong";
    user.sex = @"男";
    user.age = @23;
    
    NSDictionary *dic = [user dictInstanceKeyValues];
    XCTAssert([dic isKindOfClass:[NSDictionary class]]);
    XCTAssert([dic[@"age"] isEqual:@(23)]);
    XCTAssert([dic[@"name"] isEqualToString:@"zhangdong"]);
    XCTAssert([dic[@"nickName"] isEqualToString:@"zhang-dong"]);
    XCTAssert([dic[@"sex"] isEqualToString:@"男"]);
}

- (void)testModelToArray {
    
    UserModel *user = [[UserModel alloc] init];
    user.name = @"zhangdong";
    user.nickName = @"zhang-dong";
    user.sex = @"男";
    user.age = @23;

    UserModel *user1 = [[UserModel alloc] init];
    user1.name = @"那惺博";
    user1.nickName = @"naxingbo";
    user1.sex = @"男";
    user1.age = @26;
    
    NSArray *array = @[user, user1];
    NSArray *dicArray = [UserModel arrayKeyValuesWithObjectArray:array];
    
    XCTAssert([dicArray isKindOfClass:[NSArray class]]);
    XCTAssert(dicArray.count == 2);
    XCTAssert([dicArray[0] isKindOfClass:[NSDictionary class]]);
    XCTAssert([dicArray[0][@"name"] isEqualToString:@"zhangdong"]);
    XCTAssert([dicArray[1][@"nickName"] isEqualToString:@"naxingbo"]);
    XCTAssert([dicArray[1][@"age"] isEqual:@26]);
}

- (void)testModelInModelToDic {
   
    UserModelDesc *model = [[UserModelDesc alloc] init];
    model.modelDesc = @"这是一个测试modle";
    UserModel *user = [[UserModel alloc] init];
    user.name = @"userModel";
    user.nickName = @"user-Model";
    user.age = @23;
    user.sex = @"男";
    model.userModel = user;
    
    NSDictionary *dic = [model dictInstanceKeyValues];
    XCTAssert([dic isKindOfClass:[NSDictionary class]]);
    XCTAssert([dic[@"userModel"][@"name"] isEqualToString:@"userModel"]);
    XCTAssert([dic[@"userModel"][@"nickName"] isEqualToString:@"user-Model"]);
    XCTAssert([dic[@"userModel"][@"age"] isEqual:@23]);
    XCTAssert([dic[@"userModel"][@"sex"] isEqualToString:@"男"]);
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
