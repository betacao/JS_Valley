//
//  SHGRecommendViewController.m
//  Finance
//
//  Created by weiqiankun on 16/4/26.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGRecommendViewController.h"
#import "SHGRecommendHeaderView.h"
#import "SHGRecommendCollectionView.h"
#import "SHGPersonalViewController.h"
#import "ApplyViewController.h"
#import "CCLocationManager.h"
#import "SHGDiscoveryObject.h"

@interface SHGRecommendViewController ()

@property (strong, nonatomic) SHGRecommendCollectionView *recommendCollectionView;

@end

@implementation SHGRecommendViewController


- (void)viewDidLoad
{
    self.rightItemtitleName = @"下一步";
    [super viewDidLoad];
    self.title = @"大牛推荐";
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self initView];
    [self addAutoLayout];
    [self uploadCityName];
    [self loadData];
}

- (void)initView
{
    self.recommendCollectionView = [[SHGRecommendCollectionView alloc] init];
    [self.view addSubview:self.recommendCollectionView];
}

- (void)addAutoLayout
{
    self.recommendCollectionView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)uploadCityName
{
    [[CCLocationManager shareLocation] getCity:^{
        NSString *cityName = [SHGGloble sharedGloble].cityName;
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",rBaseAddressForHttp,@"user",@"info",@"saveOrUpdateUserPosition"];
        NSDictionary *parameters = @{@"uid":UID,@"position":cityName};
        [MOCHTTPRequestOperationManager getWithURL:url parameters:parameters success:nil failed:nil];
    }];

}

- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",rBaseAddressForHttp,@"recommended",@"friends",@"getFirstRecommendedFriend"];
    NSDictionary *parameters = @{@"uid":UID};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:parameters success:^(MOCHTTPResponse *response){
        weakSelf.recommendCollectionView.dataArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"list"] class:[SHGDiscoveryRecommendObject class]];
    }failed:^(MOCHTTPResponse *response){

    }];
}

- (void)rightItemClick:(id)sender
{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf loginSuccess];
    });
}

- (void)loginSuccess
{
    [[SHGGloble sharedGloble] getUserAddressList:^(BOOL finished) {
        if(finished){
            [[SHGGloble sharedGloble] uploadPhonesWithPhone:^(BOOL finish) {
                
            }];
        }
    }];
    [[AppDelegate currentAppdelegate] moveToRootController:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
