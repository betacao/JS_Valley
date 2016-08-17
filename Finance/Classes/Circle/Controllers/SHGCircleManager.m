//
//  SHGCircleManager.m
//  Finance
//
//  Created by changxicao on 16/8/17.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCircleManager.h"

@implementation SHGCircleManager

+ (void)getListDataWithParam:(NSDictionary *)param block:(void (^)(NSArray *, NSArray *))block
{
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,dynamicNew] parameters:param success:^(MOCHTTPResponse *response){
        NSLog(@"首页预加载数据成功");
        NSArray *normalArray = [response.dataDictionary objectForKey:@"normalpostlist"];
        normalArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:normalArray class:[CircleListObj class]];

        NSArray *adArray = [response.dataDictionary objectForKey:@"adlist"];
        adArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:adArray class:[CircleListObj class]];
        block(normalArray, adArray);
    } failed:^(MOCHTTPResponse *response){
        block(nil, nil);
    }];
}

+ (void)loadHotSearchWordFinishBlock:(void (^)(NSArray *array))block
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/common/collection/getHotSearchWordCommon"];
    [MOCHTTPRequestOperationManager postWithURL:request parameters:@{@"object":@"dynamic", @"field":@"search_word"} success:^(MOCHTTPResponse *response) {
        NSArray *hotwords = [response.dataDictionary objectForKey:@"hotwords"];
        if (block) {
            block(hotwords);
        }
    } failed:^(MOCHTTPResponse *response) {
        if (block) {
            block(nil);
        }
    }];
}

+ (void)getListDataWithCategory:(NSDictionary *)param block:(void (^)(NSArray *))block
{
    [MOCHTTPRequestOperationManager getWithURL:[rBaseAddressForHttp stringByAppendingString:@"/dynamic/classifyDynamic"] parameters:param success:^(MOCHTTPResponse *response){
        NSArray *array = [response.dataDictionary objectForKey:@"normalpostlist"];
        array = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:array class:[CircleListObj class]];
        block(array);
    } failed:^(MOCHTTPResponse *response){
        block(nil);
    }];
}
@end
