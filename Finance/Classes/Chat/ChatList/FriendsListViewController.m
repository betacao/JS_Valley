//
//  FriendsListViewController.m
//  Finance
//
//  Created by haibo li on 15/5/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "FriendsListViewController.h"
#import "SRRefreshView.h"
#import "ChatListCell.h"
#import "EMSearchBar.h"
#import "NSDate+Category.h"
#import "RealtimeSearchUtil.h"
#import "ChatViewController.h"
#import "EMSearchDisplayController.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "GroupListViewController.h"
#import "BasePeopleObject.h"
#import "BasePeopleTableViewCell.h"
#import "ApplyViewController.h"
#import "MessageViewController.h"
//#import "ContactsViewController.h"
#import "ChatListViewController.h"
#import "HeadImage.h"

static NSString * const kUid				= @"uid";
static NSString * const kHeadImg			= @"headimg";
static NSString * const kNickName			= @"nickname";
static NSString * const kRela			= @"rela";
static NSString * const kCompany			= @"company";
static NSString * const kCommonFriend			= @"commonfriend";
static NSString * const kCommonFNum			= @"commonnum";
@interface FriendsListViewController ()<UITableViewDelegate,UITableViewDataSource, UISearchDisplayDelegate,SRRefreshDelegate, UISearchBarDelegate, IChatManagerDelegate>
{
    NSInteger pageNum;
    BOOL hasMoreData;

}

@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (strong, nonatomic) UITableView           *tableView;
@property (nonatomic, strong) EMSearchBar           *searchBar;
@property (nonatomic, strong) SRRefreshView         *slimeView;
@property (nonatomic, strong) UIView                *networkStateView;
@property (strong, nonatomic) EMSearchDisplayController *searchController;

@end

@implementation FriendsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _contactsSource = [NSMutableArray array];
        pageNum = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择好友";
    [self removeEmptyConversationsFromDB];
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];


    self.searchBar.hidden = NO;
    [self.view addSubview:self.tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView addSubview:self.slimeView];
    [self networkStateView];
    
    [self searchController];
    
    [self refreshDataSource];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations deleteMessages:YES append2Chat:NO];
    }
}

#pragma mark - getter

- (SRRefreshView *)slimeView
{
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        _slimeView.backgroundColor = [UIColor whiteColor];
    }
    
    return _slimeView;
}

- (EMSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"chatListCell"];
        _tableView.tableHeaderView=self.searchBar;
    }
    
    return _tableView;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak UISearchBar *weakSBar=self.searchBar;
        __weak FriendsListViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"BasePeopleTableViewCell";
            BasePeopleTableViewCell *cell = (BasePeopleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            // Configure the cell...
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
                //			cell.delegate = self;
            }
            
            BasePeopleObject *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            
            [cell.headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,buddy.headImageUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
            [cell.headerView updateStatus:[buddy.userStatus isEqualToString:@"true"]?YES:NO];
            cell.nameLabel.text = buddy.name;
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [BasePeopleTableViewCell tableView:tableView heightForRowAtIndexPath:indexPath];
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            BasePeopleObject *buddy = [weakSelf.searchController.resultsSource  objectAtIndex:indexPath.row];
            NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
            NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
            if (loginUsername && loginUsername.length > 0) {
                if ([loginUsername isEqualToString:buddy.uid]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                    [alertView show];
                    return;
                }
            }
            [weakSBar resignFirstResponder];
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:buddy.uid isGroup:NO];
            chatVC.title = buddy.name;
            chatVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:chatVC animated:YES];
            
        }];
    }
    
    return _searchController;
}

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

#pragma mark - TableViewDelegate & TableViewDatasource

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"BasePeopleTableViewCell";
    BasePeopleTableViewCell *cell = (BasePeopleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
    }
    
    BasePeopleObject *buddy = [self.contactsSource objectAtIndex:indexPath.row];
    
    [cell.headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,buddy.headImageUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
    [cell.headerView updateStatus:[buddy.userStatus isEqualToString:@"true"]?YES:NO];
    cell.nameLabel.text = buddy.name;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contactsSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BasePeopleObject *buddy = [self.contactsSource  objectAtIndex:indexPath.row];
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if (loginUsername && loginUsername.length > 0) {
        if ([loginUsername isEqualToString:buddy.uid]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
    }
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:buddy.uid isGroup:NO];
    chatVC.title = buddy.name;
    chatVC.isShare = self.isShare;
    chatVC.shareRid = self.shareRid;
    chatVC.shareContent = self.shareContent;
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.contactsSource searchText:(NSString *)searchText collationStringSelector:@selector(name) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchController.resultsSource removeAllObjects];
                [self.searchController.resultsSource addObjectsFromArray:results];
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

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate
//刷新消息列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self refreshDataSource];
    
    [_slimeView endRefresh];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}

#pragma mark - public

-(void)refreshHeader
{
    pageNum = 1;
    [self refreshDataSource];
}
-(void)refreshFooter
{
    if (hasMoreData) {
        pageNum ++;
        [self refreshDataSource];
    } else{
        [self.tableView.footer endRefreshingWithNoMoreData];
    }
}

-(void)refreshDataSource
{
    [self showHudInView:self.view hint:NSLocalizedString(@"refreshData", @"Refresh data...")];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    
    NSDictionary *param = @{@"uid":uid, @"pagenum":[NSNumber numberWithInteger:pageNum], @"pagesize":@15};
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends/level/one"] parameters:param success:^(MOCHTTPResponse *response){
        if(response.dataArray.count > 0){
            if (pageNum == 1) {
                [self.contactsSource removeAllObjects];
            }
        }
        for (int i = 0; i<response.dataArray.count; i++){
            NSDictionary *dic = response.dataArray[i];
            BasePeopleObject *obj = [[BasePeopleObject alloc] init];
            obj.name = [dic valueForKey:@"nick"];
            obj.headImageUrl = [dic valueForKey:@"avatar"];
            obj.uid = [dic valueForKey:@"username"];
            obj.rela = [dic valueForKey:@"rela"];
            obj.company = [dic valueForKey:@"company"];
            obj.commonfriend = @"";
            obj.commonfriendnum = @"";
            if (![obj.rela isEqualToString:@"2"]) {
                [self.contactsSource addObject:obj];

            }
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [HeadImage inertWithArr:self.contactsSource];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Hud hideHud];
                BOOL moreData = NO;
                for (NSDictionary *dics in response.dataArray) {
                    NSString *rela = [dics valueForKey:@"rela"];
                    if (![rela isEqualToString:@"2"]) {
                        moreData = YES;
                        break;
                    }
                }
                hasMoreData = moreData;
                if (hasMoreData) {
                    [self.tableView reloadData];
                } else{
                    [_tableView.footer endRefreshingWithNoMoreData];
                }

                [self.tableView.header endRefreshing];
                [self.tableView.footer endRefreshing];
            });
        });
        
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:response.errorMessage];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
}

- (void)willReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.beginReceiveOffine", @"Begin to receive offline messages"));
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages{
    NSLog(NSLocalizedString(@"message.endReceiveOffine", @"End to receive offline messages"));
    [self refreshDataSource];
}

@end
