//
//  SHGGloble.m
//  Finance
//
//  Created by changxicao on 15/8/24.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "SHGGloble.h"

@interface SHGGloble ()
/**
 @brief  首页url返回的数据，如果没有数据也不是nil
 
 @since 1.4.1
 */
@property (strong, nonatomic) NSMutableArray *homeArray;

@end

@implementation SHGGloble

+(instancetype)sharedGloble
{
    static SHGGloble *sharedGlobleInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGlobleInstance = [[self alloc] init];
    });
    return sharedGlobleInstance;
}

- (NSString *)cityName
{
    if(!_cityName){
        _cityName = @"";
    }
    return _cityName;
}

- (NSMutableArray *)homeArray
{
    if(!_homeArray){
        _homeArray = [NSMutableArray array];
    }
    return _homeArray;
}

- (void)requestHomePageData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    if(!uid || uid.length == 0){
        //纯粹为了省事 如果没有登录则用一个默认的用户id去拉取首页数据 下个版本要修改了
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange:) name:NSUserDefaultsDidChangeNotification object:nil];
        return;
    }
    NSDictionary *param = @{@"uid":uid, @"type":@"all", @"target":@"first", @"rid":@(0), @"num": rRequestNum, @"total":@(0)};
    
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,circleBak] class:[CircleListObj class] parameters:param success:^(MOCHTTPResponse *response){
        NSLog(@"首页预加载数据成功");
        [weakSelf.homeArray removeAllObjects];
        [weakSelf.homeArray addObjectsFromArray:response.dataArray];
        if(weakSelf.CompletionBlock){
            weakSelf.CompletionBlock(self.homeArray);
        }
    } failed:^(MOCHTTPResponse *response){
        NSLog(@"首页预加载数据失败");
        [weakSelf.homeArray removeAllObjects];
        if(weakSelf.CompletionBlock){
            weakSelf.CompletionBlock(self.homeArray);
        }
    }];
}

- (void)setCompletionBlock:(SHHomeDataCompletionBlock)CompletionBlock
{
    _CompletionBlock = CompletionBlock;
    if(self.homeArray && [self.homeArray count] > 0){
        _CompletionBlock(self.homeArray);
    }
}

- (void)userDefaultsDidChange:(NSNotification *)notification
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    if(uid && uid.length != 0){
        [self requestHomePageData];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}


@end
