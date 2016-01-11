/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "GroupListViewController.h"

#import "EMSearchBar.h"
#import "SRRefreshView.h"
#import "BaseTableViewCell.h"
#import "EMSearchDisplayController.h"
#import "ChatViewController.h"
#import "CreateGroupViewController.h"
#import "PublicGroupListViewController.h"
#import "RealtimeSearchUtil.h"
#import "UIViewController+HUD.h"
#import "AppDelegate.h"
#import "ChatListViewController.h"
#import "PublicGroupDetailViewController.h"
@interface GroupListViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, IChatManagerDelegate, SRRefreshDelegate>
{
   BOOL _isExpand[4];
}
@property (strong, nonatomic) NSMutableArray *dataSource; //推荐群组
@property (strong, nonatomic) NSMutableArray *commonArr; //我创建的群组
@property (strong, nonatomic) NSMutableArray *joinArr; // 我加入的群组
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) EMSearchDisplayController *searchController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GroupListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"群组";
    _dataSource = [NSMutableArray array];
    _commonArr = [NSMutableArray array];
    _joinArr = [NSMutableArray array];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:NO];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);

    //公共群组
    UIButton *publicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [publicButton setFrame:CGRectMake(0, 0, 24, 24)];
    [publicButton setBackgroundImage:[UIImage imageNamed:@"44"] forState:UIControlStateNormal];
    [publicButton addTarget:self action:@selector(showPublicGroupList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *publicItem = [[UIBarButtonItem alloc] initWithCustomView:publicButton];
    
    self.navigationItem.rightBarButtonItem=publicItem;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"common_backImage"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=rightItem;
    
    [self reloadDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.frame = CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT);

    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView setTableHeaderView:self.searchBar];

    [self searchController];

    [MobClick event:@"GroupListViewController" label:@"onClick"];
}

- (void)refreshHeader
{
    [self.tableView.header endRefreshing];
}
- (void) returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - getter

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak GroupListViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            EMGroup *group = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            if(group!=nil&&![@"-1" isEqualToString:group.groupId])
            {
                NSString *imageName = @"群头像图标";
                cell.imageView.image = [UIImage imageNamed:imageName];
                cell.textLabel.text = group.groupSubject;
            }
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath)
        {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            EMGroup *group = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            PublicGroupDetailViewController *detailController = [[PublicGroupDetailViewController alloc] initWithGroupId:group.groupId];
            detailController.title = group.groupSubject;
            BaseViewController *viewController =(BaseViewController*)weakSelf.parnetVC;
            [viewController.navigationController pushViewController:detailController animated:YES];
        }];
    }
    
    return _searchController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isExpand[section] == YES)
    {
        
        if  (section == 1)
        {
            return [self.dataSource count];
        }
        if (section == 2)
        {
            return [self.commonArr count];
        }
        if (section == 3)
        {
            return [self.joinArr count];
        }
    }else
    {
        if (section == 0)
        {
            return 1;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"161616"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        NSInteger spaceToRight = 15.0f;
        NSInteger lineToTop = 44.0f;
        if (!indexPath.section == 0) {
      
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(spaceToRight, lineToTop, SCREENWIDTH-spaceToRight, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"E6E7E8"];
        [cell addSubview:lineView];
        }
    }

    if (indexPath.section == 0){
        cell.textLabel.textColor = [UIColor colorWithHexString:@"161616"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.text = @"     新建群组";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    } else if (indexPath.section == 1){
        UIImageView * qunImage = [[UIImageView alloc]init];
        qunImage.frame = CGRectMake(15, 8, 28, 28);
        [cell addSubview:qunImage];
        cell.accessoryType = UITableViewCellAccessoryNone;
        EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
        NSString *imageName = group.isPublic ? @"群头像图标" : @"群头像图标";
        qunImage.image = [UIImage imageNamed:imageName];
        if (group.groupSubject && group.groupSubject.length > 0){
            cell.textLabel.text = [NSString stringWithFormat:@"         %@",group.groupSubject];
            
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"         %@",group.groupId];
        }
        
    } else if (indexPath.section == 2){
        UIImageView * qunImage = [[UIImageView alloc]init];
        qunImage.frame = CGRectMake(15, 8, 28, 28);
        [cell addSubview:qunImage];
        cell.accessoryType = UITableViewCellAccessoryNone;
        EMGroup *group = [self.commonArr objectAtIndex:indexPath.row];
        NSString *imageName = group.isPublic ? @"群头像图标" : @"群头像图标";
        qunImage.image = [UIImage imageNamed:imageName];
        if (group.groupSubject && group.groupSubject.length > 0){
            cell.textLabel.text = [NSString stringWithFormat:@"         %@",group.groupSubject];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"         %@",group.groupId];
        }
    } else if (indexPath.section == 3){
        UIImageView * qunImage = [[UIImageView alloc]init];
        qunImage.frame = CGRectMake(15, 8, 28, 28);
        [cell addSubview:qunImage];
        cell.accessoryType = UITableViewCellAccessoryNone;
        EMGroup *group = [self.joinArr objectAtIndex:indexPath.row];
        NSString *imageName = group.isPublic ? @"群头像图标" : @"群头像图标";
        qunImage.image = [UIImage imageNamed:imageName];
        if (group.groupSubject && group.groupSubject.length > 0){
            cell.textLabel.text = [NSString stringWithFormat:@"         %@",group.groupSubject];
        } else{
            cell.textLabel.text = [NSString stringWithFormat:@"         %@",group.groupId];
        }
    }

   return cell;
}

#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    headerView.backgroundColor = [[UIColor alloc]initWithRed:1 green:1 blue:1 alpha:1];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30, 1, 320, 42);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize: 13.0f];
    [button setTitleColor:[UIColor colorWithHexString:@"161616"] forState:UIControlStateNormal];
    button.tag = section;
    [button addTarget:self action:@selector(sectionBurronClick:) forControlEvents:UIControlEventTouchUpInside];
    //设置每组的的标题
    
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(15, 20, 8, 11);
    imageBtn.tag = section;
    [imageBtn setImage:[UIImage imageNamed:@"arrowRight"] forState:UIControlStateNormal];
    [imageBtn addTarget:self action:@selector(sectionBurronClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:imageBtn];
    if (_isExpand[section] == YES){
        [imageBtn setImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];
    }
    
    if (section == 0){
        
    }
    else if (section == 1){
        UIView *upVIew = [[UIView alloc]initWithFrame:CGRectMake(15, 0, self.view.bounds.size.height, 0.5)];
        upVIew.backgroundColor = [[UIColor alloc]initWithHue:0 saturation:0 brightness:0 alpha:0.1];
        [headerView addSubview:upVIew];
        [button setTitle:[NSString stringWithFormat:@"推荐群组 (%lu)",(unsigned long)self.dataSource.count] forState:UIControlStateNormal];
    }
    else if (section == 2){
        [button setTitle:[NSString stringWithFormat:@"我创建的群组  (%lu)",(unsigned long)self.commonArr.count] forState:UIControlStateNormal];
    }
    if (section == 3){
        [button setTitle:[NSString stringWithFormat:@"我加入的群组 (%lu)",(unsigned long)self.joinArr.count] forState:UIControlStateNormal];
    }
    
    [headerView addSubview:button];
    
    UIView *lineVIew = [[UIView alloc]initWithFrame:CGRectMake(15, 44, self.view.bounds.size.height, 0.5)];
    lineVIew.backgroundColor = [[UIColor alloc]initWithHue:0 saturation:0 brightness:0 alpha:0.1];
    [headerView addSubview:lineVIew];
    
    return headerView;
}
-(void)sectionBurronClick:(UIButton*)button
{
    _isExpand[button.tag] = !_isExpand[button.tag];
    NSIndexSet *set =[NSIndexSet indexSetWithIndex:button.tag];
    [_tableView reloadSections:set withRowAnimation: UITableViewRowAnimationNone];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 45.0f;
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        if(indexPath.row==0)
        {
            [self createGroup];
        }
    }
    if (indexPath.section == 1)
    {
        
         EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
         PublicGroupDetailViewController *detailController = [[PublicGroupDetailViewController alloc] initWithGroupId:group.groupId];
         detailController.title = group.groupSubject;
         if ([self.parnetVC isKindOfClass:[ChatListViewController class]])
         {
             BaseViewController *viewController =(BaseViewController*)self.parnetVC;
             [viewController.navigationController pushViewController:detailController animated:YES];
         }else
         {
             [self.navigationController pushViewController:detailController animated:YES];
         }
        
    }
    if (indexPath.section == 2)
    {
        EMGroup *group = [self.commonArr objectAtIndex:indexPath.row];
        ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:group.groupId isGroup:YES];
        chatController.title = group.groupSubject;
        if ([self.parnetVC isKindOfClass:[ChatListViewController class]])
        {
            BaseViewController *viewController =(BaseViewController*)self.parnetVC;
            [viewController.navigationController pushViewController:chatController animated:YES];
        }else
        {
            [self.navigationController pushViewController:chatController animated:YES];
        }
    }
    if (indexPath.section == 3)
    {
        EMGroup *group = [self.joinArr objectAtIndex:indexPath.row];
        ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:group.groupId isGroup:YES];
        chatController.title = group.groupSubject;
        if ([self.parnetVC isKindOfClass:[ChatListViewController class]])
        {
            BaseViewController *viewController =(BaseViewController*)self.parnetVC;
            [viewController.navigationController pushViewController:chatController animated:YES];
        }else
        {
            [self.navigationController pushViewController:chatController animated:YES];
        }
    }
    
}
//处理tableView左边空白
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,15,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,15,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0,15,0,0)];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsMake(0,15,0,0)];
        
    }
}
#pragma mark - UISearchBarDelegate
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    for(UIView * v in controller.searchResultsTableView.superview.subviews)
    {
        NSLog(@"%@",[v class]);
        if([v isKindOfClass:NSClassFromString(@"_EMSearchDisplayControllerDimmingView")])
    {
        v.frame = CGRectMake(0,44,SCREENWIDTH,SCREENHEIGHT);
    }
    }

}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataSource searchText:(NSString *)searchText collationStringSelector:@selector(groupSubject) resultBlock:^(NSArray *results)
    {
        if (results)
        {
            dispatch_async(dispatch_get_main_queue(),^
            {
                [self.searchController.resultsSource removeAllObjects];
                EMGroup *grp=[[EMGroup alloc] initWithGroupId:@"-1"];
                NSMutableArray *resultArr=[[NSMutableArray alloc] initWithArray:results];
                [resultArr removeObject:grp];
                [self.searchController.resultsSource addObjectsFromArray:resultArr];
                [self.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - IChatManagerDelegate

- (void)groupDidUpdateInfo:(EMGroup *)group error:(EMError *)error
{
    if (!error)
    {
        [self reloadDataSource];
    }
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self reloadDataSource];
}

#pragma mark - data
#pragma mark -获取公开群组
-(void)didFetchAllPublicGroups:(NSArray *)groups error:(EMError*)error
{
    [self hideHud];
    [self.dataSource addObjectsFromArray:groups];
    [self.tableView reloadData];
}

- (void)reloadDataSource
{
    //增加点击进入增加群组
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    [[EaseMob sharedInstance].chatManager asyncFetchAllPublicGroups];
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error){
        for (EMGroup *group in groups){
            [self hideHud];
            [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:group.groupId completion:^(EMGroup *group, EMError *error) {
                if (!error){
                    if (![group.owner isEqualToString:loginInfo[@"username"]]){
                        [_joinArr addObject:group];
                    }else{
                        [_commonArr addObject:group];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [self.tableView reloadData];
                });
            } onQueue:nil];
        }
    }
    onQueue:nil];
    [self.dataSource removeAllObjects];
    [self.joinArr removeAllObjects];
    [self.commonArr removeAllObjects];
}

#pragma mark - action

- (void)showPublicGroupList
{
    PublicGroupListViewController *publicController = [[PublicGroupListViewController alloc] init];
    [self.navigationController pushViewController:publicController animated:YES];
}

- (void)createGroup
{
    CreateGroupViewController *createChatroom = [[CreateGroupViewController alloc] init];
    if ([self.parnetVC isKindOfClass:[ChatListViewController class]])
    {
        BaseViewController *viewController =(BaseViewController*)self.parnetVC;
        [viewController.navigationController pushViewController:createChatroom animated:YES];
    }else{
        [self.navigationController pushViewController:createChatroom animated:YES];
    }
    
}


@end
