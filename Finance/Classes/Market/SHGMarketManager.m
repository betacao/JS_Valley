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

+ (void)loadMarketListBlock:(void (^)(NSArray *))block
{
//    SHGMarketManager *manager = [self shareManager];
//    [MOCHTTPRequestOperationManager ]
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
        [Hud showMessageWithText:@"创建业务成功"];
        block(YES);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"获取业务失败"];
    }];
}

@end
