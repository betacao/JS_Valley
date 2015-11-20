//
//  SHGActionViewController.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/12.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionListViewController.h"
#import "SHGActionTableViewCell.h"
#import "SHGActionObject.h"
#import "SHGActionDetailViewController.h"
#import "SHGActionSendViewController.h"
#import "SHGActionManager.h"

@interface SHGActionListViewController ()<UITableViewDataSource, UITableViewDelegate, SHGActionTableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTable;

@end

@implementation SHGActionListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){

    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listTable.delegate = self;
    self.listTable.dataSource = self;
    [self addHeaderRefresh:self.listTable headerRefesh:YES andFooter:YES];
    [self loadDataWithType:@"first" meetID:@"-1"];
}

- (void)addNewAction:(UIButton *)button
{
    SHGActionSendViewController *controller = [[SHGActionSendViewController alloc] initWithNibName:@"SHGActionSendViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)loadDataWithType:(NSString *)target meetID:(NSString *)meetID
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/meetingactivity/getMeetingActivityAll"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *pageSize = @"10";
    NSString *type = @"all";
    NSDictionary *dictionary = @{@"uid":uid, @"meetId":meetID, @"pageSize":pageSize, @"target":target, @"type":type};
    __weak typeof(self) weakSelf = self;
    [Hud showLoadingWithMessage:@"请稍等..."];
    [MOCHTTPRequestOperationManager postWithURL:request class:[SHGActionObject class] parameters:dictionary success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        if ([target isEqualToString:@"first"]) {
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:response.dataArray];
        } else if([target isEqualToString:@"refresh"]){
            for (NSInteger i = response.dataArray.count - 1; i >= 0; i--){
                CircleListObj *obj = [response.dataArray objectAtIndex:i];
                [weakSelf.dataArr insertObject:obj atIndex:0];
            }
        } else{
            [weakSelf.dataArr addObjectsFromArray:response.dataArray];
        }
        [weakSelf.listTable reloadData];
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"网络连接失败"];
    }];
    [self.listTable.header endRefreshing];
    [self.listTable.footer endRefreshing];
}

- (void)refreshHeader
{
    [self loadDataWithType:@"refresh" meetID:[self maxMeetID]];
}


- (void)refreshFooter
{
    [self loadDataWithType:@"load" meetID:[self minMeetID]];
}

- (NSString *)maxMeetID
{
    return ((SHGActionObject *)[self.dataArr firstObject]).meetId;
}

- (NSString *)minMeetID
{
    return ((SHGActionObject *)[self.dataArr lastObject]).meetId;
}
#pragma mark ------tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SHGActionTableViewCell";
    SHGActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGActionTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    SHGActionObject *object = [self.dataArr objectAtIndex:indexPath.row];
    [cell loadDataWithObject:object];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGActionDetailViewController *controller = [[SHGActionDetailViewController alloc] init];
    SHGActionObject *object = [self.dataArr objectAtIndex:indexPath.row];
    controller.object = object;
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kActionCellHeight;
}

#pragma mark ------cell代理
- (void)clickPrasiseButton:(SHGActionObject *)object
{
    __weak typeof(self)weakSelf = self;
    if ([object.isPraise isEqualToString:@"N"]) {
        [[SHGActionManager shareActionManager] addPraiseWithObject:object finishBlock:^(BOOL success) {
            if (success) {
                [weakSelf.listTable reloadData];
            }
        }];
    } else{
        [[SHGActionManager shareActionManager] deletePraiseWithObject:object finishBlock:^(BOOL success) {
            if (success) {
                [weakSelf.listTable reloadData];
            }
        }];
    }
}

- (void)clickCommentButton:(SHGActionObject *)object
{
    SHGActionDetailViewController *controller = [[SHGActionDetailViewController alloc] init];
    controller.object = object;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickEditButton:(SHGActionObject *)object
{
    SHGActionSendViewController *controller = [[SHGActionSendViewController alloc] initWithNibName:@"SHGActionSendViewController" bundle:nil];
    controller.object = object;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
