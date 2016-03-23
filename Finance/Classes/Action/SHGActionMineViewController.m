//
//  SHGActionMineViewController.m
//  Finance
//
//  Created by changxicao on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionMineViewController.h"
#import "SHGActionTableViewCell.h"
#import "SHGActionDetailViewController.h"
#import "SHGActionSendViewController.h"
#import "SHGActionSegmentViewController.h"
#import "SHGActionManager.h"
#import "SHGPersonalViewController.h"
#import "SHGEmptyDataView.h"

@interface SHGActionMineViewController ()<UITableViewDataSource, UITableViewDelegate, SHGActionTableViewDelegate>

;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@end

@implementation SHGActionMineViewController

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

- (void)refreshData
{
    [self loadDataWithType:@"first" meetID:@"-1"];
}

- (NSMutableArray *)currentDataArray
{
    return self.dataArr;
}

- (void)reloadData
{
    [self.listTable reloadData];
}

- (void)addNewAction:(UIButton *)button
{
    SHGActionSendViewController *controller = [[SHGActionSendViewController alloc] initWithNibName:@"SHGActionSendViewController" bundle:nil];
    controller.delegate = [SHGActionSegmentViewController sharedSegmentController];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)loadDataWithType:(NSString *)target meetID:(NSString *)meetID
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/meetingactivity/getMeetingActivityAll"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *pageSize = @"10";
    NSString *type = @"my";
    NSDictionary *dictionary = @{@"uid":uid, @"meetId":meetID, @"pageSize":pageSize, @"target":target, @"type":type};
    __weak typeof(self) weakSelf = self;
    [Hud showWait];
    [MOCHTTPRequestOperationManager postWithURL:request class:[SHGActionObject class] parameters:dictionary success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [weakSelf.listTable.mj_header endRefreshing];
        [weakSelf.listTable.footer endRefreshing];
        if ([target isEqualToString:@"first"]) {
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:response.dataArray];
            [weakSelf.listTable reloadData];
        } else if([target isEqualToString:@"refresh"]){
            [weakSelf.dataArr addObjectsFromArray:response.dataArray];
            [weakSelf.listTable reloadData];
        } else if([target isEqualToString:@"load"]){
            [weakSelf.dataArr addObjectsFromArray:response.dataArray];
            if (response.dataArray.count < 10) {
                [weakSelf.listTable.footer endRefreshingWithNoMoreData];
            }
            [weakSelf.listTable reloadData];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"网络连接失败"];
        [weakSelf.listTable.mj_header endRefreshing];
        [weakSelf.listTable.footer endRefreshing];
    }];
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
    if (self.dataArr.count > 0) {
        return ((SHGActionObject *)[self.dataArr firstObject]).meetId;
    } else{
        return @"-1";
    }
}

- (NSString *)minMeetID
{
    if (self.dataArr.count > 0) {
        return ((SHGActionObject *)[self.dataArr lastObject]).meetId;
    } else{
        return @"-1";
    }
}
#pragma mark ------tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count > 0) {
        NSInteger count = self.dataArr.count;
        return count;
    } else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        NSString *cellIdentifier = @"SHGActionTableViewCell";
        SHGActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGActionTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        SHGActionObject *object = [self.dataArr objectAtIndex:indexPath.row];
        [cell loadDataWithObject:object index:indexPath.row];
        return cell;
    } else{
        return self.emptyCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        SHGActionDetailViewController *controller = [[SHGActionDetailViewController alloc] init];
        SHGActionObject *object = [self.dataArr objectAtIndex:indexPath.row];
        controller.object = object;
        controller.delegate = [SHGActionSegmentViewController sharedSegmentController];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        return kActionCellHeight;
    } else{
        return CGRectGetHeight(self.view.frame);
    }
}

#pragma mark ------cell代理
- (void)clickPrasiseButton:(SHGActionObject *)object
{
    [[SHGActionSegmentViewController sharedSegmentController] addOrDeletePraise:object block:^(BOOL success) {

    }];
}

- (void)clickCommentButton:(SHGActionObject *)object
{
    SHGActionDetailViewController *controller = [[SHGActionDetailViewController alloc] init];
    controller.object = object;
    controller.delegate = [SHGActionSegmentViewController sharedSegmentController];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickEditButton:(SHGActionObject *)object
{
    [self loadUserPermissionStatefinishBlock:^(BOOL success) {
        if (success) {
            SHGActionSendViewController *controller = [[SHGActionSendViewController alloc] initWithNibName:@"SHGActionSendViewController" bundle:nil];
            controller.object = object;
            controller.delegate = [SHGActionSegmentViewController sharedSegmentController];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];

}

- (void)loadUserPermissionStatefinishBlock:(void (^)(BOOL))block
{
    [[SHGActionManager shareActionManager] loadUserPermissionState:^(NSString *state) {
        if ([state isEqualToString:@"0"]) {
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"您当前有活动正在审核中，请等待审核后再提交，谢谢。" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
            block(NO);
        } else if ([state isEqualToString:@"2"]){
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"您当前有活动申请被驳回，请至我的活动查看。" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
            block(NO);
        } else{
            block(YES);
        }
    }];
}

- (void)dealloc
{
    self.listTable.delegate = nil;
    self.listTable.dataSource = nil;
    [self.listTable removeFromSuperview];
    self.listTable = nil;
}

@end
