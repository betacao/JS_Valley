//
//  SHGCircleManager.m
//  Finance
//
//  Created by changxicao on 16/8/17.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCircleManager.h"

@implementation SHGCircleManager

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

@end
