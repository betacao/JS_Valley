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
#import "CircleListObj.h"
#import "ApplyViewController.h"
#import "CCLocationManager.h"
UIKIT_EXTERN NSString *const UICollectionElementKindSectionHeader;  //定义好Identifier
static NSString *const HeaderIdentifier = @"HeaderIdentifier";
@interface SHGRecommendViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CircleListDelegate>
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
    button.frame =CGRectMake(0, 0, 50, 44);
    [button addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button setTitle:@"下一步" forState:UIControlStateHighlighted];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self requestCity];
    [self requestContact];
    self.collectionView.backgroundColor = Color(@"efeeef");
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.flowLayout.headerReferenceSize = CGSizeMake(SCREENWIDTH, MarginFactor(45.0f));
    [self.collectionView registerClass:[SHGRecommendHeaderView  class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];

    [self.collectionView registerNib:[UINib nibWithNibName:@"SHGRecommendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SHGRecommendCollectionViewCell"];
    
   

    
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
    cell.delegate = self;
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
    return YES ;
    
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

#pragma mark ------ 关注
- (void)attentionClicked:(CircleListObj *)obj
{
    [Hud showWait];
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID], @"oid":obj.userid};
    if (![obj.isattention isEqualToString:@"Y"]) {
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                for (CircleListObj *cobj in self.dataArray) {
                    if ([cobj.userid isEqualToString:obj.userid]) {
                        cobj.isattention = @"Y";
                    }
                }
                [Hud showMessageWithText:@"关注成功"];

            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:obj];
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
    } else{
        
        [MOCHTTPRequestOperationManager deleteWithURL:url parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                for (CircleListObj *cobj in self.dataArray) {
                    if ([cobj.userid isEqualToString:obj.userid]) {
                        cobj.isattention = @"N";
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:obj];

                [Hud showMessageWithText:@"取消关注成功"];
            }
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
    }
    
}


- (void)addNewAddress
{
    [self chatLoagin];
    [self dealFriendPush];
    [self didUploadAllUserInfo];
}
- (void)chatLoagin
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:uid password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        if (loginInfo && !error) {
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
            EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
            if (!error) {
                error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
            }
            [[ApplyViewController shareController] loadDataSourceFromLocalDB];
            
        }else {
            switch (error.errorCode) {
                case EMErrorServerNotReachable:
                    NSLog(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                    break;
                case EMErrorServerAuthenticationFailure:
                    NSLog(@"%@",error.description);
                    break;
                case EMErrorServerTimeout:
                    NSLog(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                    break;
                default:
                    break;
            }
            
        }
    } onQueue:nil];
}
- (void)dealFriendPush
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    uid = uid ? uid : @"";
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friend/dealFriendPush"];
    NSDictionary *parm = @{@"uid":uid};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:parm success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]){
        }
        
    } failed:^(MOCHTTPResponse *response) {
        
    }];
    
}
- (void)didUploadAllUserInfo
{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [Hud hideHud];
        [weakSelf loginSuccess];
    });
}

- (void)loginSuccess
{
    [[AppDelegate currentAppdelegate] moveToRootController:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
