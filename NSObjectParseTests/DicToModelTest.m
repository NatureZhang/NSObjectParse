//
//  JsonToModelTest.m
//  UnitTestDemo
//
//  Created by zhangdong on 16/7/19.
//  Copyright © 2016年 __Nature__. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+Parse.h"

@interface User : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSNumber *age;
@end
@implementation User
@end

@interface UserList : NSObject
@property (nonatomic, strong) NSString *usersDesc;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSArray *userList;
@end
@implementation UserList
+ (NSDictionary *)dictObjectTypeInArray {
    return @{@"userList":@"User"};
}
@end

@interface ReplaceNameModel : NSObject
@property (nonatomic, strong) NSString *nameId;
@property (nonatomic, strong) NSString *name;
@end
@implementation ReplaceNameModel
+ (NSDictionary *)dictPropertyAnotherName {
    return @{@"nameId":@"id"};
}
@end



@interface DicToModelTest : XCTestCase
{
    User *user;
}

@end

@implementation DicToModelTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDicToModel {
    
    NSDictionary *dic = @{
                          @"name":@"Jack",
                          @"sex":@"男",
                          @"age":@12,
                         };
    user = [User objectWithKeyValues:dic];
    XCTAssertNotNil(user, @"Cannot create Calculator instance");
    XCTAssertTrue([user.name isEqualToString:@"Jack"]);
    XCTAssertTrue([user.sex isEqualToString:@"男"]);
    XCTAssertTrue(user.age.integerValue == 12);
    XCTAssertTrue(user.nickName == nil);
}

- (void)testArrayToModel {
    
    NSArray *dictArray = @[
                                @{
                                    @"name" : @"Jack",
                                    @"sex" : @"男",
                                    },

                                @{
                                    @"name" : @"Rose",
                                    @"nickName":@"Rose Li",
                                    @"sex" : @"女",
                                    },
                                @{
                                    @"name" : @"Jack",
                                    @"sex" : @"男",
                                    },
                                @{
                                    @"name" : @"Rose",
                                    @"icon" : @"nami.png",
                                    }
                           ];
    
    NSArray *users = [User objectArrayWithValueArray:dictArray];
    XCTAssertNotNil(users);
    XCTAssertTrue(users.count == 4);
    User *user1 = users[1];
    XCTAssertNotNil(user1);
    XCTAssertTrue([user1.name isEqualToString:@"Rose"]);
    XCTAssertTrue([user1.sex isEqualToString:@"女"]);
    XCTAssertTrue(user1.age == nil);
    XCTAssertTrue([user1.nickName isEqualToString:@"Rose Li"]);
}

// 数组中有数组
- (void)testArray2Object {
    
    NSArray *dictArray2 = @[

                            @[
                                @{
                                    @"name" : @"Jack",
                                    @"sex" : @"男",
                                    },

                                @{
                                    @"name" : @"Rose",
                                    @"nickName":@"Rose Li",
                                    @"sex" : @"女",
                                    }
                                ],
                            @[
                                @{
                                    @"name" : @"Jack",
                                    @"sex" : @"男",
                                    },
                                
                                @{
                                    @"name" : @"Rose",
                                    @"nickName":@"Rose Li",
                                    @"sex" : @"女",
                                    @"age":@23,
                                    }
                                ]
                            
                           ];
    NSArray *usersUser = [User objectArrayWithValueArray:dictArray2];
    XCTAssertNotNil(usersUser);
    XCTAssertTrue(usersUser.count == 2);
    NSArray *users1 = usersUser[1];
    XCTAssertTrue(users1.count == 2);
    User *userRose = users1[1];
    XCTAssertNotNil(userRose);
    XCTAssertTrue([userRose.name isEqualToString:@"Rose"]);
    XCTAssertTrue([userRose.sex isEqualToString:@"女"]);
    XCTAssertTrue(userRose.age.integerValue == 23);
    XCTAssertTrue([userRose.nickName isEqualToString:@"Rose Li"]);

}

// 字典中有对象
- (void)testObjectInDic {
    
    NSDictionary *dict = @{
                           @"usersDesc":@"这是一个测试",
                           @"user" :  @{
                                        @"name" : @"zhangdong",
                                        @"sex" : @"nan",
                                        },
                           @"userList":@[

                                   @[
                                       @{
                                           @"name" : @"Jack",
                                           @"sex" : @"男",
                                           },
                                       
                                       @{
                                           @"name" : @"Rose",
                                           @"nickName":@"Rose Li",
                                           @"sex" : @"女",
                                           }
                                       ],
                                   @[
                                       @{
                                           @"name" : @"Jack",
                                           @"sex" : @"男",
                                           },
                                       
                                       @{
                                           @"name" : @"Rose",
                                           @"nickName":@"Rose Li",
                                           @"sex" : @"女",
                                           @"age":@23,
                                           }
                                       ]
                                   ]
                            };
    UserList *userListModel = [UserList objectWithKeyValues:dict];
    XCTAssertNotNil(userListModel);
    User *userModel = userListModel.user;
    XCTAssertTrue([userModel.name isEqualToString:@"zhangdong"]);
    XCTAssertNotNil(userListModel.userList);
    NSArray *userList = userListModel.userList;
    XCTAssertNotNil(userList);
    XCTAssertTrue(userList.count == 2);
    NSArray *users = userList[1];
    XCTAssertNotNil(users);
    XCTAssertTrue(users.count == 2);
    User *userRose = users[1];
    XCTAssertNotNil(userRose);
    XCTAssertTrue([userRose.name isEqualToString:@"Rose"]);
    XCTAssertTrue([userRose.sex isEqualToString:@"女"]);
    XCTAssertTrue(userRose.age.integerValue == 23);
    XCTAssertTrue([userRose.nickName isEqualToString:@"Rose Li"]);
}

- (void)testReplacePropertyName {
    NSDictionary *dic = @{
                          @"id":@"zhang-dong",
                          @"name":@"zhangdong",
                          };
    
    ReplaceNameModel *model = [ReplaceNameModel objectWithKeyValues:dic];
    XCTAssertNotNil(model);
    XCTAssertTrue([model.name isEqualToString:@"zhangdong"]);
    XCTAssertTrue([model.nameId isEqualToString:@"zhang-dong"]);
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
}

@end
