//
//  SHGFriendViewController.m
//  Finance
//
//  Created by changxicao on 16/1/13.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGConnectionsViewController.h"
#import "EMSearchBar.h"
#import "SHGConnectionsTableViewCell.h"
#import "SHGPersonalViewController.h"
#import "SHGFriendGroupingViewController.h"
#import "RealtimeSearchUtil.h"
#import "SHGEmptyDataView.h"

@interface SHGConnectionsViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) EMSearchBar *searchBar;
@property (assign, nonatomic) NSInteger normalPage;
@property (assign, nonatomic) NSInteger searchPage;
@property (strong, nonatomic) NSMutableArray *resultArray;
@property (assign, nonatomic) BOOL searchLocal;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@end

@implementation SHGConnectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.type) {
        case SHGFriendTypeFirst:
            self.title = @"一度人脉";
            break;

        default:
            self.title = @"二度人脉";
            break;
    }
    self.tableView.tableHeaderView = self.searchBar;
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"分组" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    self.normalPage = 1;
    self.searchPage = 1;
    NSDictionary *param = @{@"uid":UID ,@"pagesize":@"15" ,@"pagenum":@(self.normalPage)};

    __weak typeof(self) weakSelf = self;
    [self loadFriendList:param block:^(NSArray *array) {
        [weakSelf.listArray addObjectsFromArray:array];
        weakSelf.resultArray = [NSMutableArray arrayWithArray:array];
        [weakSelf.tableView reloadData];
    }];
    self.searchLocal = YES;
}

- (void)rightButtonClick:(UIButton *)button
{
    SHGFriendGroupingViewController *controller = [[SHGFriendGroupingViewController alloc] init];
    switch (self.type) {
        case SHGFriendTypeFirst:
            controller.type = @"once";
            break;
        case SHGFriendTypeSecond:
            controller.type = @"twice";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)refreshFooter
{
    if (self.searchLocal) {
        if (self.resultArray.count > 0) {
            NSDictionary *param = @{@"uid":UID ,@"pagesize":@"15" ,@"pagenum":@(self.normalPage + 1)};
            __weak typeof(self) weakSelf = self;
            [self loadFriendList:param block:^(NSArray *array) {
                weakSelf.normalPage++;
                [weakSelf.listArray addObjectsFromArray:array];
                [weakSelf.resultArray addObjectsFromArray:array];
                [weakSelf.tableView reloadData];
            }];
        }
    } else{
        if (self.resultArray.count > 0) {
            NSDictionary *param = nil;
            __weak typeof(self)weakSelf = self;
            switch (self.type) {
                case SHGFriendTypeFirst:
                    param = @{@"uid":UID, @"pagenum":@(self.searchPage + 1), @"pagesize":@"15", @"type":@"once", @"condition":self.searchBar.text};
                    break;

                default:
                    param = @{@"uid":UID, @"pagenum":@(self.searchPage + 1), @"pagesize":@"15", @"type":@"twice", @"condition":self.searchBar.text};
                    break;
            }
            [self searchFriendList:param block:^(NSArray *array) {
                weakSelf.searchPage++;
                [weakSelf.resultArray addObjectsFromArray:array];
                [weakSelf.tableView reloadData];
            }];
        }
    }
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入姓名/公司名/职位";
    }

    return _searchBar;
}

- (UITableViewCell *)emptyCell
{
    if (!_emptyCell) {
        _emptyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_emptyCell.contentView addSubview:self.emptyView];
    }
    return _emptyCell;
}


- (SHGEmptyDataView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SHGEmptyDataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
    }
    return _emptyView;
}


- (void)loadFriendList:(NSDictionary *)param block:(void (^)(NSArray *array))block
{
    __weak typeof(self) weakSelf = self;
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = @"";
    switch (self.type) {
        case SHGFriendTypeFirst:
            request = [rBaseAddressForHttp stringByAppendingString:@"/friends/level/one"];
            break;

        default:
            request =[rBaseAddressForHttp stringByAppendingString:@"/friends/level/two"];
            break;
    }
    [MOCHTTPRequestOperationManager getWithURL:request class:[SHGPeopleObject class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [weakSelf.tableView.footer endRefreshing];
        block(response.dataArray);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [weakSelf.tableView.footer endRefreshing];
        block(nil);
        [Hud showMessageWithText:@"获取好友信息失败"];
    }];
}

- (void)searchFriendList:(NSDictionary *)param block:(void (^)(NSArray *array))block
{
    __weak typeof(self) weakSelf = self;
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request =[rBaseAddressForHttp stringByAppendingString:@"/friends/searchFriends"];

    [MOCHTTPRequestOperationManager getWithURL:request class:[SHGPeopleObject class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [weakSelf.tableView.footer endRefreshing];
        block(response.dataArray);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [weakSelf.tableView.footer endRefreshing];
        block(nil);
        [Hud showMessageWithText:@"获取好友信息失败"];
    }];
}


#pragma mark - TableViewDelegate & TableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.resultArray.count > 0){
        return self.resultArray.count;
    } else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.resultArray.count == 0) {
        return CGRectGetHeight(self.view.frame);
    } else{
        BasePeopleObject *buddy = [self.resultArray objectAtIndex:indexPath.row];
        return [tableView cellHeightForIndexPath:indexPath model:buddy keyPath:@"object" cellClass:[SHGConnectionsTableViewCell class] contentViewWidth:CGFLOAT_MAX];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.resultArray.count > 0) {
        static NSString *CellIdentifier = @"SHGConnectionsTableViewCell";
        SHGConnectionsTableViewCell *cell = (SHGConnectionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
        }
        SHGPeopleObject *buddy = [self.resultArray objectAtIndex:indexPath.row];
        if (self.type == SHGFriendTypeFirst){
            cell.type = SHGContactTypeFirst;
        }else{
            cell.type = SHGContactTypeSecond;
        }
        cell.object = buddy;
        return cell;
    } else{
        return self.emptyCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.resultArray.count > 0) {
        BasePeopleObject *buddy = [self.resultArray  objectAtIndex:indexPath.row];
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        if (loginUsername && loginUsername.length > 0){
            if ([loginUsername isEqualToString:buddy.uid]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
        }
        if ([buddy.rela isEqualToString:@"2"]){
            return;
        }
        SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
        controller.hidesBottomBarWhenPushed = YES;
        controller.userId = buddy.uid;
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];

    return YES;
}
#pragma mark -- 检索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    if (self.searchLocal || searchText.length == 0) {
        self.searchLocal = YES;
        if (searchText.length == 0) {
            [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
        } else{
            self.tableView.footer = nil;
        }

        if (self.type == SHGFriendTypeFirst) {
            [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.listArray searchText:searchText firstSel:@selector(name) secondSel:@selector(company) thirdSel:@selector(position) resultBlock:^(NSArray *results) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.resultArray removeAllObjects];
                    [weakSelf.resultArray addObjectsFromArray:results];
                    [weakSelf.tableView reloadData];
                });
            }];
        } else{
            [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.listArray searchText:searchText firstSel:@selector(nickname) secondSel:@selector(company) thirdSel:@selector(position) resultBlock:^(NSArray *results) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.resultArray removeAllObjects];
                    [weakSelf.resultArray addObjectsFromArray:results];
                    [weakSelf.tableView reloadData];
                });
            }];
        }
    }
}

//网络搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    if (searchBar.text.length > 0) {
        self.searchLocal = NO;
        [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
        NSDictionary *param = nil;
        self.searchPage = 1;
        __weak typeof(self)weakSelf = self;
        switch (self.type) {
            case SHGFriendTypeFirst:
                param = @{@"uid":UID, @"pagenum":@(self.searchPage), @"pagesize":@"15", @"type":@"once", @"condition":searchBar.text};
                break;

            default:
                param = @{@"uid":UID, @"pagenum":@(self.searchPage), @"pagesize":@"15", @"type":@"twice", @"condition":searchBar.text};
                break;
        }
        [self searchFriendList:param block:^(NSArray *array) {
            [weakSelf.resultArray removeAllObjects];
            [weakSelf.resultArray addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
        }];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar setShowsCancelButton:NO animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
