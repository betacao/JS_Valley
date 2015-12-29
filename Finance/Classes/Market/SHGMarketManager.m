//
//  SHGMarketManager.m
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketManager.h"
#import "SHGMarketObject.h"

@interface SHGMarketManager ()

@property (strong, nonatomic) NSMutableArray *categoryArray;

@end

@implementation SHGMarketManager

+ (instancetype)shareManager
{
    static SHGMarketManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)loadMarketCategoryBlock:(void (^)(NSArray *array))block
{
    if (!self.categoryArray) {
        __weak typeof(self) weakSelf = self;
        NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/getMarketCatalog"];
        [MOCHTTPRequestOperationManager postWithURL:request class:[SHGMarketFirstCategoryObject class] parameters:nil success:^(MOCHTTPResponse *response) {
            weakSelf.categoryArray = [NSMutableArray arrayWithArray:response.dataArray];
            block(weakSelf.categoryArray);
        } failed:^(MOCHTTPResponse *response) {
            [Hud showMessageWithText:@"获取业务分类错误"];
        }];
    } else{
        block(self.categoryArray);
    }
}

+ (void)loadMarketList:(NSDictionary *)param block:(void (^)(NSArray *array))block
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/getMarketList"];
    [MOCHTTPRequestOperationManager postWithURL:request class:[SHGMarketObject class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        block(response.dataArray);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        block(nil);
        [Hud showMessageWithText:@"获取列表数据失败"];
    }];
}

+ (void)searchMarketList:(NSDictionary *)param block:(void (^)(NSArray *array))block
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/getMarketList"];
    [MOCHTTPRequestOperationManager postWithURL:request class:[SHGMarketObject class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        block(response.dataArray);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        block(nil);
        [Hud showMessageWithText:@"搜索数据失败"];
    }];
}


+ (void)createNewMarket:(NSDictionary *)param success:(void (^)(BOOL success))block
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/saveMarket"];
    [MOCHTTPRequestOperationManager postWithURL:request class:[SHGMarketFirstCategoryObject class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"创建业务成功"];
        block(YES);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"创建业务失败"];
    }];
}

+ (void)modifyMarket:(NSDictionary *)param success:(void (^)(BOOL success))block
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/saveMarket"];
    [MOCHTTPRequestOperationManager postWithURL:request class:[SHGMarketFirstCategoryObject class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"修改业务成功"];
        block(YES);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"修改业务失败"];
    }];
}

@end
