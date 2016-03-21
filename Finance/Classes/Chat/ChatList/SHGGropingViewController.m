//
//  SHGGropingViewController.m
//  Finance
//
//  Created by changxicao on 16/1/4.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGGropingViewController.h"
#import "BasePeopleObject.h"
#import "SHGConnectionsTableViewCell.h"
#import "SHGPersonalViewController.h"

@interface SHGGropingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger currentPage;
@end

@implementation SHGGropingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.condition;
    self.currentPage = 1;
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self loadDataWithPage:[NSString stringWithFormat:@"%ld", (long)self.currentPage] module:self.module type:self.type];
}

- (void)refreshFooter
{
    self.currentPage++;
    [self loadDataWithPage:[NSString stringWithFormat:@"%ld",(long)self.currentPage] module:self.module type:self.type];
}

- (void)loadDataWithPage:(NSString *)page module:(NSString *)module type:(NSString *)type
{
    [Hud showWait];
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"pagenum":page, @"uid":UID, @"pagesize":@"20", @"module":module, @"type":type, @"condition":self.condition};
    [MOCHTTPRequestOperationManager getWithURL:[rBaseAddressForHttp stringByAppendingString:@"/friends/searchFriendsAsModuleName"] class:[BasePeopleObject class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];

        if (response.dataArray.count < 10) {
            [weakSelf.tableView.footer endRefreshingWithNoMoreData];
        }
        for (NSDictionary *dic in response.dataArray) {
            BasePeopleObject *obj = [[BasePeopleObject alloc] init];
            if ([type isEqualToString:@"twice"]) {
                obj.name = [dic valueForKey:@"nickname"];
                obj.headImageUrl = [dic valueForKey:@"avatar"];
                obj.uid = [dic valueForKey:@"username"];
                obj.rela = @"";
                obj.company = [dic valueForKey:@"company"];
                obj.commonfriend = [dic valueForKey:@"commonfriend"];
                obj.commonfriendnum = [dic valueForKey:@"commonfriendnum"];
                obj.poststring = [dic valueForKey:@"poststring"];
                obj.position = [dic valueForKey:@"position"];
                obj.userstatus = [dic valueForKey:@"userstatus"];
            } else{
                obj.name = [dic valueForKey:@"nick"];
                obj.headImageUrl = [dic valueForKey:@"avatar"];
                obj.uid = [dic valueForKey:@"username"];
                obj.rela = [dic valueForKey:@"rela"];
                obj.company = [dic valueForKey:@"company"];
                obj.commonfriend = @"";
                obj.commonfriendnum = @"";
            }
            [weakSelf.dataArr addObject:obj];
        }
        [weakSelf.tableView reloadData];
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        [Hud showMessageWithText:@"获取数据失败"];
    }];
}

#pragma mark ------tableview的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BasePeopleObject *buddy = [self.dataArr objectAtIndex:indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:buddy keyPath:@"object" cellClass:[SHGConnectionsTableViewCell class] contentViewWidth:CGFLOAT_MAX];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SHGConnectionsTableViewCell";
    SHGConnectionsTableViewCell *cell = (SHGConnectionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
    }
    BasePeopleObject *buddy = [self.dataArr objectAtIndex:indexPath.row];
    cell.object = buddy;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BasePeopleObject *buddy = [self.dataArr  objectAtIndex:indexPath.row];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
