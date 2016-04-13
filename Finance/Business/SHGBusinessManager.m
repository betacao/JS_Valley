//
//  SHGBusinessManager.m
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessManager.h"
#import "SHGBusinessObject.h"
#import "SHGBusinessScrollView.h"

@interface SHGBusinessManager()
@property (strong, nonatomic) NSArray *secondListArray;
@property (strong, nonatomic) NSArray *trademixedArray;//同业混业
@property (strong, nonatomic) NSArray *bondFinancingArray;
@property (strong, nonatomic) NSArray *moneySideArray;
@property (strong, nonatomic) NSArray *equityFinancingArray;
@end
@implementation SHGBusinessManager
//创建新业务
+ (void)createNewBusiness:(NSDictionary *)param success:(void (^)(BOOL))block
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/business/saveBusiness"];
    [MOCHTTPRequestOperationManager postWithURL:request class:[SHGBusinessObject class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"发布业务成功"];
        block(YES);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"发布业务失败"];
    }];
}

+ (instancetype)shareManager
{
    static SHGBusinessManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (NSArray *)secondListArray
{
    if (!_secondListArray) {
        _secondListArray = [NSArray array];
    }
    return _secondListArray;
}

//列表
+ (void)getListDataWithParam:(NSDictionary *)param block:(void (^)(NSArray *dataArray, NSString *position, NSString *tipUrl))block;
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/business/getBusinessList"] class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSDictionary *dictionary = response.dataDictionary;

        NSArray *dataArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[dictionary objectForKey:@"businesslist"] class:[SHGBusinessObject class]];
        NSString *positon = [dictionary objectForKey:@"position"];
        NSString *tipUrl = [dictionary objectForKey:@"tipurl"];
//        block(dataArray, positon, tipUrl);

    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        block(nil, nil, nil);
        [Hud showMessageWithText:@"获取列表数据失败"];
    }];
}
//二级分类
- (void)getSecondListBlock:(void (^)(NSArray *))block
{
    __weak typeof(self) weakSelf = self;
    if (self.secondListArray.count > 0) {
        NSArray *array = [NSArray arrayWithArray:[self.secondListArray objectAtIndex:[[SHGBusinessScrollView sharedBusinessScrollView] currentIndex] - 1]];
        block(array);
    } else {
        [Hud showWait];
        [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/business/getBusinessCondition"] parameters:nil success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            weakSelf.trademixedArray = [response.dataDictionary objectForKey:@"trademixed"];
            weakSelf.bondFinancingArray = [response.dataDictionary objectForKey:@"bondfinancing"];
            weakSelf.moneySideArray = [response.dataDictionary objectForKey:@"moneyside"];
            weakSelf.equityFinancingArray = [response.dataDictionary objectForKey:@"equityfinancing"];

            weakSelf.trademixedArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.trademixedArray class:[SHGBusinessSecondObject class]];
            weakSelf.bondFinancingArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.bondFinancingArray class:[SHGBusinessSecondObject class]];
            weakSelf.moneySideArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.moneySideArray class:[SHGBusinessSecondObject class]];
            weakSelf.equityFinancingArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.equityFinancingArray class:[SHGBusinessSecondObject class]];

            weakSelf.secondListArray = @[weakSelf.bondFinancingArray, weakSelf.equityFinancingArray, weakSelf.moneySideArray, weakSelf.trademixedArray];

            NSArray *array = [NSArray arrayWithArray:[self.secondListArray objectAtIndex:[[SHGBusinessScrollView sharedBusinessScrollView] currentIndex] - 1]];
            block(array);
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:@"获取分类错误"];
        }];
    }
}

@end
