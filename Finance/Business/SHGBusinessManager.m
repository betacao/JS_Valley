//
//  SHGBusinessManager.m
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessManager.h"
#import "SHGBusinessObject.h"

@interface SHGBusinessManager()
@property (strong, nonatomic) NSArray *trademixedArray;//同业混业
@property (strong, nonatomic) NSArray *bondFinancingArray;
@property (strong, nonatomic) NSArray *moneySideArray;
@property (strong, nonatomic) NSArray *equityFinancingArray;
@end
@implementation SHGBusinessManager

+ (instancetype)shareManager
{
    static SHGBusinessManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
//列表
+ (void)getListDataWithParam:(NSDictionary *)param block:(void (^)(NSArray *))block
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/business/getBusinessList"] class:[SHGBusinessObject class] parameters:param success:^(MOCHTTPResponse *response) {

    } failed:^(MOCHTTPResponse *response) {

    }];
}
//二级分类
- (void)getSecondListWithType:(NSString *)type block:(void (^)(NSArray *))block
{
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/business/getBusinessCondition"] parameters:nil success:^(MOCHTTPResponse *response) {
        weakSelf.trademixedArray = [response.dataDictionary objectForKey:@"trademixed"];
        weakSelf.bondFinancingArray = [response.dataDictionary objectForKey:@"bondfinancing"];
        weakSelf.moneySideArray = [response.dataDictionary objectForKey:@"moneyside"];
        weakSelf.equityFinancingArray = [response.dataDictionary objectForKey:@"equityfinancing"];
        
    } failed:^(MOCHTTPResponse *response) {

    }];
}
@end
