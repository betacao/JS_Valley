//
//  SHGCompanyManager.m
//  Finance
//
//  Created by changxicao on 16/8/11.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCompanyManager.h"

@implementation SHGCompanyManager

+ (void)loadBlurCompanyInfo:(NSDictionary *)param success:(void (^)(NSArray *))block
{
    [Hud showWait];
    [MOCHTTPRequestOperationManager getWithURL:kCompanyBlurSearch parameters:param success:^(MOCHTTPResponse *response) {
        NSArray *array = [response.dataDictionary objectForKey:@"companies"];
        array = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:array class:[SHGCompanyObject class]];
        block(array);
        [Hud hideHud];
    } failed:^(MOCHTTPResponse *response) {
        block(nil);
        [Hud hideHud];
    }];
}

+ (void)loadExactCompanyInfo:(NSDictionary *)param success:(void (^)(SHGCompanyObject *))block
{
    [MOCHTTPRequestOperationManager getWithURL:kCompanyExactSearch parameters:param success:^(MOCHTTPResponse *response) {
        NSDictionary *dictionary = [response.dataDictionary objectForKey:@"company"];
        SHGCompanyObject *object = [[[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:@[dictionary] class:[SHGCompanyObject class]] firstObject];
        block(object);
    } failed:^(MOCHTTPResponse *response) {
        block(nil);
    }];
}

@end
