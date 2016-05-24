//
//  SHGDiscovryManager.m
//  Finance
//
//  Created by changxicao on 16/5/24.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGDiscoveryManager.h"

@interface SHGDiscoveryManager()

@end

@implementation SHGDiscoveryManager

+ (instancetype)shareManager
{
    static SHGDiscoveryManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+ (void)loadDiscoveryData:(NSDictionary *)param block:(void (^)(NSArray *, NSString *, NSString *, NSString *))block
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString: @"/neo4j/friend/getIndustryCountByPhone"] parameters:param success:^(MOCHTTPResponse *response) {

    } failed:^(MOCHTTPResponse *response) {

    }];
}

@end
