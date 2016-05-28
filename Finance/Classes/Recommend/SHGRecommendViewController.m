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


UIKIT_EXTERN NSString *const UICollectionElementKindSectionHeader;  //定义好Identifier
static NSString *const HeaderIdentifier = @"HeaderIdentifier";

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

    [self requestCity];
}

- (void)initView
{

}

- (void)addAutoLayout
{
    self.recommendCollectionView = [[SHGRecommendCollectionView alloc] init];
    [self.view addSubview:self.recommendCollectionView];

    self.recommendCollectionView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)requestCity
{
    [[CCLocationManager shareLocation] getCity:^{
        NSString *cityName = [SHGGloble sharedGloble].cityName;
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",rBaseAddressForHttp,@"user",@"info",@"saveOrUpdateUserPosition"];
        NSDictionary *parameters = @{@"uid":UID,@"position":cityName};
        [MOCHTTPRequestOperationManager getWithURL:url parameters:parameters success:nil failed:nil];
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
