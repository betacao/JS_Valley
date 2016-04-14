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
#import "SHGBusinessListViewController.h"

@interface SHGBusinessManager()
@property (strong, nonatomic) NSArray *secondListArray;
@property (strong, nonatomic) NSArray *trademixedArray;//同业混业
@property (strong, nonatomic) NSArray *bondFinancingArray;
@property (strong, nonatomic) NSArray *moneySideArray;
@property (strong, nonatomic) NSArray *equityFinancingArray;
@property (strong, nonatomic) NSString *cityName;
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

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"cityName" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"cityName"]) {
        NSString *newValue = [change objectForKey:@"new"];
        [SHGBusinessListViewController sharedController].cityName = newValue;
    }
}

- (NSArray *)secondListArray
{
    if (!_secondListArray) {
        _secondListArray = [NSArray array];
    }
    return _secondListArray;
}

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

//列表
+ (void)getListDataWithParam:(NSDictionary *)param block:(void (^)(NSArray *dataArray, NSString *position, NSString *tipUrl))block;
{
    [Hud showWait];
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/business/getBusinessList"] class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSDictionary *dictionary = response.dataDictionary;

        NSArray *dataArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[dictionary objectForKey:@"businesslist"] class:[SHGBusinessObject class]];
        NSString *positon = [dictionary objectForKey:@"position"];
        NSString *tipUrl = [dictionary objectForKey:@"tipurl"];
        block(dataArray, positon, tipUrl);
        [Hud hideHud];
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        block(nil, nil, nil);
        [Hud showMessageWithText:@"获取列表数据失败"];
    }];
}
//二级分类
- (void)getSecondListBlock:(void (^)(NSArray *, NSString *))block
{
    __weak typeof(self) weakSelf = self;
    if (self.secondListArray.count > 0) {
        NSInteger index = [[SHGBusinessScrollView sharedBusinessScrollView] currentIndex] == 0 ? 1 : [[SHGBusinessScrollView sharedBusinessScrollView] currentIndex];
        NSArray *array = [NSArray arrayWithArray:[self.secondListArray objectAtIndex:index - 1]];
        if (block) {
            block(array, self.cityName);
        }
    } else {
        [Hud showWait];
        [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/business/getBusinessCondition"] parameters:nil success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            weakSelf.trademixedArray = [response.dataDictionary objectForKey:@"trademixed"];
            weakSelf.bondFinancingArray = [response.dataDictionary objectForKey:@"bondfinancing"];
            weakSelf.moneySideArray = [response.dataDictionary objectForKey:@"moneyside"];
            weakSelf.equityFinancingArray = [response.dataDictionary objectForKey:@"equityfinancing"];
            weakSelf.cityName = [response.dataDictionary objectForKey:@"areaname"];

            weakSelf.trademixedArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.trademixedArray class:[SHGBusinessSecondObject class]];
            weakSelf.bondFinancingArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.bondFinancingArray class:[SHGBusinessSecondObject class]];
            weakSelf.moneySideArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.moneySideArray class:[SHGBusinessSecondObject class]];
            weakSelf.equityFinancingArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.equityFinancingArray class:[SHGBusinessSecondObject class]];

            weakSelf.secondListArray = @[weakSelf.bondFinancingArray, weakSelf.equityFinancingArray, weakSelf.moneySideArray, weakSelf.trademixedArray];

            NSInteger index = [[SHGBusinessScrollView sharedBusinessScrollView] currentIndex] == 0 ? 1 : [[SHGBusinessScrollView sharedBusinessScrollView] currentIndex];
            NSArray *array = [NSArray arrayWithArray:[self.secondListArray objectAtIndex:index - 1]];

            if (block) {
                block(array, weakSelf.cityName);
            }
            [Hud hideHud];
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:@"获取分类错误"];
        }];
    }
}

+ (void)deleteBusiness:(NSString *)businessId success:(void (^)(BOOL))block
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/business/deleteBusiness"] parameters:@{@"businessId": businessId} success:^(MOCHTTPResponse *response) {

    } failed:^(MOCHTTPResponse *response) {

    }];
}

+ (void)collectBusiness:(NSString *)businessId success:(void (^)(BOOL))block
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/business/saveBusinessCollect"] parameters:@{@"uid":UID, @"businessId": businessId} success:^(MOCHTTPResponse *response) {

    } failed:^(MOCHTTPResponse *response) {
        
    }];
}

+ (void)unCollectBusiness:(NSString *)businessId success:(void (^)(BOOL))block
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/business/deleteBusinessCollect"] parameters:@{@"uid":UID, @"businessId": businessId} success:^(MOCHTTPResponse *response) {

    } failed:^(MOCHTTPResponse *response) {
        
    }];
}

+ (void)getMyorSearchDataWithParam:(NSDictionary *)param block:(void (^)(NSArray *, NSString *))block
{
    [Hud showWait];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/business/getAllTypeBusinessList"];
    [MOCHTTPRequestOperationManager postWithURL:request class:nil parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        NSDictionary *dictionary = response.dataDictionary;
        NSArray *dataArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[dictionary objectForKey:@"businesslist"] class:[SHGBusinessObject class]];
        NSString *total = [dictionary objectForKey:@"total"];
        block(dataArray, total);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        block(nil, @"0");
        [Hud showMessageWithText:@"获取列表数据失败"];
    }];
}

+ (void)loadHotSearchWordFinishBlock:(void (^)(NSArray *))block
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/getHotSearchWord"];
    [MOCHTTPRequestOperationManager postWithURL:request parameters:nil success:^(MOCHTTPResponse *response) {
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
