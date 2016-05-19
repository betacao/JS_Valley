//
//  SHGRecommendViewController.m
//  Finance
//
//  Created by weiqiankun on 16/4/26.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGRecommendViewController.h"
#import "SHGRecommendCollectionViewCell.h"
#import "SHGRecommendHeaderView.h"
#import "SHGPersonalViewController.h"
#import "ApplyViewController.h"
#import "CCLocationManager.h"

UIKIT_EXTERN NSString *const UICollectionElementKindSectionHeader;  //定义好Identifier
static NSString *const HeaderIdentifier = @"HeaderIdentifier";

@interface SHGRecommendViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation SHGRecommendViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"大牛推荐";
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectZero];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = FontFactor(15.0f);
    [button sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.collectionView.backgroundColor = Color(@"efeeef");
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.flowLayout.headerReferenceSize = CGSizeMake(SCREENWIDTH, MarginFactor(45.0f));
    [self.collectionView registerClass:[SHGRecommendHeaderView  class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];

    [self.collectionView registerNib:[UINib nibWithNibName:@"SHGRecommendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SHGRecommendCollectionViewCell"];

    [self requestCity];
    [self requestContact];
}

- (void)requestCity
{
    [[CCLocationManager shareLocation] getCity:^{
        NSString *cityName = [SHGGloble sharedGloble].cityName;
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",rBaseAddressForHttp,@"user",@"info",@"saveOrUpdateUserPosition"];
        NSDictionary *parameters = @{@"uid":UID,@"position":cityName};
        [MOCHTTPRequestOperationManager getWithURL:url parameters:parameters success:^(MOCHTTPResponse *response){
            
        }failed:^(MOCHTTPResponse *response){
            
        }];
        
    }];
}

-(NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}


- (void)requestContact
{
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",rBaseAddressForHttp,@"recommended",@"friends",@"getFirstRecommendedFriend"];
    NSDictionary *parameters = @{@"uid":UID};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:parameters success:^(MOCHTTPResponse *response){
        weakSelf.dataArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"list"] class:[CircleListObj class]];

         NSLog(@"推荐%@",weakSelf.dataArray );
        [weakSelf.collectionView reloadData];
    }failed:^(MOCHTTPResponse *response){
        
    }];
}


#pragma mark -- UICollectionViewDataSource

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SHGRecommendHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        return headerView;
    }
    return nil;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SHGRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHGRecommendCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    CircleListObj *obj = [self.dataArray objectAtIndex:indexPath.row];
    cell.object = obj;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREENWIDTH - 2 * MarginFactor(12.0f) - MarginFactor(7.0f)) / 2.0f;
    return CGSizeMake(width, MarginFactor(126.0f));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return MarginFactor(7.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return MarginFactor(7.0f);
}

- (UIEdgeInsets )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake (0.0f, MarginFactor(12.0f) ,MarginFactor(7.0f), MarginFactor(12.0f));
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CircleListObj *obj = [self.dataArray objectAtIndex:indexPath.row];
    SHGRecommendCollectionViewCell *cell = (SHGRecommendCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
    controller.userId = obj.userid;
    controller.block = ^(NSString *state){
        cell.attentionState = state;
    };
    [self.navigationController pushViewController:controller animated:YES];
    
}


- (void)nextClick:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf loginSuccess];
    });
}

- (void)loginSuccess
{
    [[SHGGloble sharedGloble] uploadPhonesWithPhone:^(BOOL finish) {

    }];
    [[AppDelegate currentAppdelegate] moveToRootController:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
