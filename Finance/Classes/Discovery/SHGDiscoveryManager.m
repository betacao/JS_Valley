//
//  SHGDiscovryManager.m
//  Finance
//
//  Created by changxicao on 16/5/24.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGDiscoveryManager.h"
#import "SHGDiscoveryObject.h"

@interface SHGDiscoveryManager()

@property (strong, nonatomic) NSArray *industryArray;
@property (strong, nonatomic) NSArray *listArray;

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

+ (void)loadDiscoveryData:(NSDictionary *)param block:(void (^)(NSArray *, NSArray *))block
{
    if ([SHGDiscoveryManager shareManager].industryArray && [SHGDiscoveryManager shareManager].listArray && block) {
        block([SHGDiscoveryManager shareManager].industryArray, [SHGDiscoveryManager shareManager].listArray);
    }
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString: @"/neo4j/friend/getIndustryCountByPhone"] parameters:param success:^(MOCHTTPResponse *response) {
        [SHGDiscoveryManager shareManager].industryArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"industrylist"] class:[SHGDiscoveryObject class]];
        [SHGDiscoveryManager shareManager].listArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"list"] class:[SHGDiscoveryRecommendObject class]];
        [SHGDiscoveryManager shareManager].hideInvateButton = [[response.dataDictionary objectForKey:@"phonecount"] isEqualToString:@"0"] ? YES : NO;
        if (block) {
            block([SHGDiscoveryManager shareManager].industryArray, [SHGDiscoveryManager shareManager].listArray);
        }
    } failed:^(MOCHTTPResponse *response) {

    }];
}

+ (void)searchDiscovery:(NSDictionary *)param block:(void (^)(NSArray *, NSString *))block
{
    [Hud showWait];
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString: @"/discoverUser/searchUser"] parameters:param success:^(MOCHTTPResponse *response) {
        NSArray *array = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"list"] class:[SHGDiscoveryPeopleObject class]];
        NSString *total = [response.dataDictionary objectForKey:@"total"];
        if (block) {
            block(array, total);
        }
        [Hud hideHud];
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
    }];
}

+ (void)loadDiscoveryInvateData:(NSDictionary *)param block:(void (^)(NSArray *, NSArray *))block
{
    [Hud showWait];
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString: @"/neo4j/friend/getMyPhoneFriend"] parameters:param success:^(MOCHTTPResponse *response) {
        NSArray *array = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"phonelist"] class:[SHGDiscoveryInvateObject class]];
        if (block) {
            block(array, nil);
        }
        [Hud hideHud];
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];

    }];
}

+ (void)loadDiscoveryMyDepartmentData:(NSDictionary *)param block:(void (^)(NSArray *, NSArray *))block
{
    [Hud showGrayWait];
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString: @"/neo4j/friend/searchNeo4jFriend"] parameters:param success:^(MOCHTTPResponse *response) {
        NSArray *firstArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"friendlist"] class:[SHGDiscoveryDepartmentObject class]];
        NSArray *secondArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"list"] class:[SHGDiscoveryRecommendObject class]];
        if (block) {
            block(firstArray, secondArray);
        }
        [Hud hideHud];
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];

    }];
}

+ (void)loadDiscoveryGroupUser:(NSDictionary *)param block:(void (^)(NSArray *))block
{
    [Hud showWait];
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString: @"/discoverUser/groupUser"] parameters:param success:^(MOCHTTPResponse *response) {
        NSArray *array = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"list"] class:[SHGDiscoveryIndustryObject class]];
        if (block) {
            block(array);
        }
        [Hud hideHud];
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];

    }];
}

+ (void)loadDiscoveryGroupUserDetail:(NSDictionary *)param block:(void (^)(NSArray *, NSArray *))block
{
    [Hud showWait];
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString: @"/discoverUser/searchUser"] parameters:param success:^(MOCHTTPResponse *response) {
        NSArray *firstArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"list"] class:[SHGDiscoveryPeopleObject class]];
        if (block) {
            block(firstArray, nil);
        }
        [Hud hideHud];
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];

    }];
}

@end
