//
//  DiscoverViewController.m
//  Finance
//
//  Created by HuMin on 15/5/21.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "DiscoverViewController.h"
#import "MyFollowViewController.h"
#import "GameObj.h"
#import "GameViewController.h"

#import "SHGActionListViewController.h"
#import "SHGActionMineViewController.h"
#import "SHGActionSegmentViewController.h"
#import "SHGActionDetailViewController.h"
#import "SHGAuthenticationViewController.h"

@interface DiscoverViewController ()
{
     BOOL hasDataFinished;
}
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (nonatomic,strong) NSMutableArray *gameArray;
@property (assign, nonatomic) NSInteger firstFriendNumber;
@property (assign, nonatomic) NSInteger secondFriendNumber;

@end

@implementation DiscoverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //处理tableView左边空白
    if ([self.listTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.listTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.listTable setLayoutMargins:UIEdgeInsetsZero];
    }
    self.gameArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self httpURL];
    self.firstFriendNumber = 0;
    self.secondFriendNumber = 0;
    [self loadFriendNumber];
    self.listTable.backgroundColor = RGB(236, 236, 236);
    [CommonMethod setExtraCellLineHidden:self.listTable];
}

- (void)loadFriendNumber
{
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[rBaseAddressForHttp stringByAppendingString:@"/friends/getFriendsNum"] class:nil parameters:@{@"uid":UID} success:^(MOCHTTPResponse *response){
        weakSelf.firstFriendNumber = [[response.dataDictionary objectForKey:@"once"] integerValue];
        weakSelf.secondFriendNumber = [[response.dataDictionary objectForKey:@"twice"] integerValue];
        [weakSelf.listTable reloadData];
    } failed:^(MOCHTTPResponse *response){
        NSLog(@"%@",response.errorMessage);
    }];
}

- (void)httpURL{
    NSString *str = @" ";
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:str forKey:@"phone"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME] forKey:@"name"];
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@",rBaseAddressForHttpProduct] class:[GameObj class] parameters:dic success:^(MOCHTTPResponse *response){
        NSLog(@"-------调用游戏接口获得数据%@",response.dataArray);
        for (int i = 0; i<response.dataArray.count; i++){
            NSDictionary *dic = response.dataArray[i];
            GameObj *obj = [[GameObj alloc]init];
            obj.imageurl = [NSString stringWithFormat:@"%@/%@",rBaseAddressForImage,[dic valueForKey:@"imageurl"]];
            obj.name = [dic valueForKey:@"name"];
            obj.url = [dic valueForKey:@"url"];
            [self.gameArray addObject:obj];
        }
        [self.listTable reloadData];
        
    } failed:^(MOCHTTPResponse *response){
        NSLog(@"%@",response.errorMessage);
    }];
}

-(UIBarButtonItem *)rightItem
{
    if (!_rightItem) {
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(0, 0, 100, 40)];
        [rightButton.titleLabel setTextAlignment:NSTextAlignmentRight];
        [rightButton setTitle:@"更新通讯录" forState:UIControlStateNormal];
        [rightButton setTitleColor:RGB(255, 57, 67) forState:UIControlStateNormal];
        [rightButton.titleLabel setFont:[UIFont systemFontOfSize:17] ];
        [rightButton addTarget:self action:@selector(uploadContact) forControlEvents:UIControlEventTouchUpInside];
        
        _rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
    return _rightItem;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

#pragma mark =============  UITableView DataSource  =============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"discoveryCellIdentifer";
    __weak typeof(self)weakSelf = self;
    DiscoveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DiscoveryTableViewCell" owner:self options:nil] lastObject];
    }
    cell.lineView.hidden = YES;
    if (indexPath.section == 0){
        [cell loadDataWithImage:@"合作" title:@"产品合作" rightItem:nil rightItemColor:nil];
        cell.numberLable.text = nil;
    } else if (indexPath.section == 1){
        if (indexPath.row == 0){
            cell.lineView.hidden = NO;
            [cell loadDataWithImage:@"erdurenmai" title:@"二度人脉" rightItem:nil rightItemColor: nil];
            cell.numberLable.text = [NSString stringWithFormat:@"%ld人", (long)weakSelf.secondFriendNumber];
        } else if (indexPath.row == 1){
            [cell loadDataWithImage:@"yidurenmai" title:@"一度人脉" rightItem:nil rightItemColor:nil];
            cell.numberLable.text = [NSString stringWithFormat:@"%ld人", (long)weakSelf.firstFriendNumber];
        } else if (indexPath.row == 2){
            [cell loadDataWithImage:@"action_Icon" title:@"会议活动" rightItem:nil rightItemColor:nil];
            cell.numberLable.text = nil;
        }
        
    } else{
        GameObj *obj = self.gameArray[indexPath.row]; 
        [cell loadDataWithImage:obj.imageurl title:obj.name rightItem:nil rightItemColor:nil];
        cell.numberLable.text = nil;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    } else if (section == 1){
        return 10.0f;
    } else{
        return 0.0f;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 2;
            break;
        
        case 2:
            return self.gameArray.count;
            break;
        default:
            break;
    }
    return 0;
}
- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10.0f)];
    view.backgroundColor = RGB(236, 236, 236);
    return view;
}
#pragma mark =============  UITableView Delegate  =============

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You Click At Section: %ld Row: %ld",(long)indexPath.section,(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        ProductListViewController *vc = [[ProductListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [MobClick event:@"ProductListViewController" label:@"onClick"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{
                ChatListViewController *vc = [[ChatListViewController alloc] init];
                vc.chatListType = ContactTwainListView;
                vc.hidesBottomBarWhenPushed = YES;
                [MobClick event:@"ChatListContactListView" label:@"onClick"];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:{
                ChatListViewController *vc = [[ChatListViewController alloc] init];
                vc.chatListType = ContactListView;
                vc.hidesBottomBarWhenPushed = YES;
                [MobClick event:@"ChatListContactTwainListView" label:@"onClick"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            case 2:{
                SHGActionSegmentViewController *segmentViewController = [SHGActionSegmentViewController sharedSegmentController];
                SHGActionListViewController *leftController = [[SHGActionListViewController alloc] init];
                SHGActionMineViewController *rightController = [[SHGActionMineViewController alloc] init];
                segmentViewController.viewControllers = @[leftController, rightController];
                segmentViewController.hidesBottomBarWhenPushed = YES;
                [MobClick event:@"SHGActionViewController" label:@"onClick"];
                [self.navigationController pushViewController:segmentViewController animated:YES];
            }
            default:
                break;
        }
    }else
    {
        GameViewController *gameVC = [[GameViewController alloc]init];
        GameObj *obj = self.gameArray[indexPath.row];
        gameVC.url = obj.url;
        gameVC.titleName = obj.name;
        [self.navigationController pushViewController:gameVC animated:YES];
    }
}
//处理tableView左边空白
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
}
- (void)goToFollowList
{
    MyFollowViewController *vc = [[MyFollowViewController alloc] init];
    vc.relationShip = 1;
    [MobClick event:@"MyFollowViewController_MyFollow" label:@"onClick"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goToFansList
{
    MyFollowViewController *vc = [[MyFollowViewController alloc] init];
    vc.relationShip = 2;
    [MobClick event:@"MyFollowViewController_MyFans" label:@"onClick"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:17.0f];
        _titleLabel.textColor = TEXT_COLOR;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"发现";
    }
    return _titleLabel;
}

@end
