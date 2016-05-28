//
//  SHGRecommendObject.m
//  Finance
//
//  Created by changxicao on 16/5/27.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGRecommendManager.h"

@implementation SHGRecommendManager

+ (instancetype)shareManager
{
    static SHGRecommendManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;

}

+ (void)loadRegistRecommendList:(NSDictionary *)param block:(void (^)(NSArray *))block
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/recommended/friends/getFirstRecommendedFriend"] parameters:param success:^(MOCHTTPResponse *response){
        NSArray *dataArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"list"] class:[CircleListObj class]];
        if (block) {
            block(dataArray);
        }
    }failed:^(MOCHTTPResponse *response){

    }];
}

@end
