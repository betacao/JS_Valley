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
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString: @"/neo4j/friend/getIndustryCountByPhone"] parameters:param success:^(MOCHTTPResponse *response) {
        NSArray *industryList = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"industrylist"] class:[SHGDiscoveryObject class]];
        NSArray *list = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"list"] class:[SHGDiscoveryObject class]];
        if (block) {
            block(industryList, list);
        }
    } failed:^(MOCHTTPResponse *response) {

    }];
}

+ (void)searchDiscovery:(NSDictionary *)param block:(void (^)(NSArray *, NSString *))block
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString: @"/discoverUser/searchUser"] parameters:param success:^(MOCHTTPResponse *response) {
        NSArray *array = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"list"] class:[SHGDiscoveryPeopleObject class]];
        NSString *total = [response.dataDictionary objectForKey:@"total"];
        if (block) {
            block(array, total);
        }
    } failed:^(MOCHTTPResponse *response) {

    }];
}

+ (void)loadDiscoveryInvateData:(NSDictionary *)param block:(void (^)(NSArray *, NSArray *))block
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString: @"/neo4j/friend/getMyPhoneFriend"] parameters:param success:^(MOCHTTPResponse *response) {
        NSArray *array = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"phonelist"] class:[SHGDiscoveryInvateObject class]];
        if (block) {
            block(array, nil);
        }
    } failed:^(MOCHTTPResponse *response) {

    }];
}

+ (void)loadDiscoveryMyDepartmentData:(NSDictionary *)param block:(void (^)(NSArray *, NSArray *))block
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString: @"/neo4j/friend/searchNeo4jFriend"] parameters:param success:^(MOCHTTPResponse *response) {
        NSArray *firstArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"friendlist"] class:[SHGDiscoveryDepartmentObject class]];
        NSArray *secondArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"list"] class:[SHGDiscoveryDepartmentObject class]];
        if (block) {
            block(firstArray, secondArray);
        }
    } failed:^(MOCHTTPResponse *response) {

    }];
}

+ (void)loadDiscoveryGroupUser:(NSDictionary *)param block:(void (^)(NSArray *))block
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString: @"/discoverUser/groupUser"] parameters:param success:^(MOCHTTPResponse *response) {
        NSArray *array = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"list"] class:[SHGDiscoveryIndustryObject class]];
        if (block) {
            block(array);
        }
    } failed:^(MOCHTTPResponse *response) {

    }];
}

+ (void)loadDiscoveryGroupUserDetail:(NSDictionary *)param block:(void (^)(NSArray *, NSArray *))block
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString: @"/discoverUser/searchUser"] parameters:param success:^(MOCHTTPResponse *response) {
        NSArray *firstArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"list"] class:[SHGDiscoveryPeopleObject class]];
        if (block) {
            block(firstArray, nil);
        }
    } failed:^(MOCHTTPResponse *response) {

    }];
}

@end
