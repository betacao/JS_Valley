//
//  SHGDiscovryManager.h
//  Finance
//
//  Created by changxicao on 16/5/24.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHGDiscoveryManager : NSObject

+ (instancetype)shareManager;

//发现首页
+ (void)loadDiscoveryData:(NSDictionary *)param block:(void (^)(NSArray *dataArray))block;

//发现首页中点击行业,地区后进入行业地区统计人数接口
+ (void)loadDiscoveryGroupUser:(NSDictionary *)param block:(void (^)(NSArray *dataArray))block;
@end
