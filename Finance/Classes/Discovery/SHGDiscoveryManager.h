//
//  SHGDiscovryManager.h
//  Finance
//
//  Created by changxicao on 16/5/24.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHGDiscoveryManager : NSObject

//决定是不是显示邀请好友
@property (assign, nonatomic) BOOL hideInvateButton;

+ (instancetype)shareManager;

//发现首页
+ (void)loadDiscoveryData:(NSDictionary *)param block:(void (^)(NSArray *firstArray, NSArray *secondArray))block;

//发现首页搜索接口
+ (void)searchDiscovery:(NSDictionary *)param block:(void (^)(NSArray *dataArray, NSString *total))block;

//发现中邀请好友列表
+ (void)loadDiscoveryInvateData:(NSDictionary *)param block:(void (^)(NSArray *firstArray, NSArray *secondArray))block;

//发现首页中行业统计人数点击进入接口
+ (void)loadDiscoveryMyDepartmentData:(NSDictionary *)param block:(void (^)(NSArray *firstArray, NSArray *secondArray))block;

//发现首页中点击行业,地区后进入行业地区统计人数接口
+ (void)loadDiscoveryGroupUser:(NSDictionary *)param block:(void (^)(NSArray *dataArray))block;
//点击行业进入行业统计列表后点击某个行业的接口
//点击地区进入地区统计列表后点击某个地区的接口
+ (void)loadDiscoveryGroupUserDetail:(NSDictionary *)param block:(void (^)(NSArray *firstArray, NSArray *secondArray))block;
@end
