//
//  SHGBusinessMineViewController.m
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessMineViewController.h"
#import "SHGBusinessManager.h"
#import "SHGBusinessObject.h"
#import "SHGNoticeView.h"
#import "SHGBusinessTableViewCell.h"
#import "SHGEmptyDataView.h"
#import "SHGBusinessNewDetailViewController.h"
#import "SHGBusinessMyTableViewCell.h"
#import "SHGBondInvestSendViewController.h"
#import "SHGEquityInvestSendViewController.h"
#import "SHGBondFinanceSendViewController.h"
#import "SHGEquityFinanceSendViewController.h"
#import "SHGSameAndCommixtureSendViewController.h"
@interface SHGBusinessMineViewController ()<UITableViewDelegate, UITableViewDataSource,SHGBusinessMyTableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL refreshing;
@property (strong, nonatomic) SHGNoticeView *noticeView;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@end

@implementation SHGBusinessMineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.userId.length == 0) {
        self.title = @"我的业务";
    } else{
        self.title = @"TA的业务";
    }
    [Hud showWait];
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
    self.tableView.backgroundColor = Color(@"f7f7f7");
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    [self loadDataWithTarget:@"first"];
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

- (SHGNoticeView *)noticeView
{
    if (!_noticeView) {
        _noticeView = [[SHGNoticeView alloc] initWithFrame:CGRectZero type:SHGNoticeTypeNewMessage];
        _noticeView.superView = self.view;
    }
    return _noticeView;
}
- (void)didCreateOrModifyBusiness
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadDataWithTarget:@"first"];
    });

}
#pragma mark ------刷新用到的
- (void)refreshHeader
{
    if (self.dataArr.count == 0) {
        [self loadDataWithTarget:@"first"];
    } else {
        [self loadDataWithTarget:@"refresh"];
    }
}

- (void)refreshFooter
{
    if (self.dataArr.count == 0) {
        [self loadDataWithTarget:@"first"];
    } else {
        [self loadDataWithTarget:@"load"];
    }
}

- (NSString *)maxBusinessID
{
    NSString *businessID = @"";
    for (SHGBusinessObject *object in self.dataArr) {
        if ([object.businessID compare:businessID options:NSNumericSearch] == NSOrderedDescending && ![object.businessID isEqualToString:[NSString stringWithFormat:@"%ld",NSIntegerMax]]) {
            businessID = object.businessID;
        }
    }
    return businessID;
}

- (NSString *)minBusinessID
{
    NSString *businessID = [NSString stringWithFormat:@"%ld",NSIntegerMax];
    for (SHGBusinessObject *object in self.dataArr) {
        NSString *objectMarketId = object.businessID;
        if ([objectMarketId compare:businessID options:NSNumericSearch] == NSOrderedAscending) {
            businessID = object.businessID;
        }
    }
    return businessID;
}

- (NSString *)maxModifyTime
{
    NSString *modifyTime = @"";
    for (SHGBusinessObject *object in self.dataArr) {
        if ([object.modifyTime compare:modifyTime options:NSNumericSearch] == NSOrderedDescending && ![object.modifyTime isEqualToString:[NSString stringWithFormat:@"%ld",NSIntegerMax]]) {
            modifyTime = object.modifyTime;
        }
    }
    return [modifyTime isEqualToString:@""] ? @"" : modifyTime;
}

- (NSString *)minModifyTime
{
    NSString *maxModifyTime = [NSString stringWithFormat:@"%ld",NSIntegerMax];
    NSString *modifyTime = maxModifyTime;
    for (SHGBusinessObject *object in self.dataArr) {
        NSString *objectModifyTime = object.modifyTime;
        if ([objectModifyTime compare:modifyTime options:NSNumericSearch] == NSOrderedAscending) {
            modifyTime = object.modifyTime;
        }
    }
    return [modifyTime isEqualToString:maxModifyTime] ? @"" : modifyTime;
}

#pragma mark ------网络请求部分

- (void)loadDataWithTarget:(NSString *)target
{
    WEAK(self, weakSelf);
    if (self.refreshing) {
        return;
    }
    NSString *uid = @"";
    if (self.userId) {
        uid = self.userId;
    } else{
        uid = UID;
    }
    NSString *businessId = [target isEqualToString:@"refresh"] ? [self maxBusinessID] : [self minBusinessID];

    NSString *modifyTime = [target isEqualToString:@"refresh"] ? [self maxModifyTime] : [self minModifyTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"businessId":businessId, @"modifyTime":modifyTime, @"uid":uid, @"type":@"my", @"target":target, @"pageSize":@"10" }];

    self.refreshing = YES;
    [SHGBusinessManager getMyorSearchDataWithParam:param block:^(NSArray *dataArray, NSString *total) {
        weakSelf.refreshing = NO;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (dataArray) {
            if ([target isEqualToString:@"first"]) {
                [weakSelf.dataArr removeAllObjects];
                [weakSelf.dataArr addObjectsFromArray:dataArray];

                [weakSelf.tableView setContentOffset:CGPointZero];
                [weakSelf.noticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新业务",(long)dataArray.count]];
            } else if([target isEqualToString:@"refresh"]){
                for (NSInteger i = dataArray.count - 1; i >= 0; i--){
                    SHGBusinessObject *obj = [dataArray objectAtIndex:i];
                    [weakSelf.dataArr insertUniqueObject:obj atIndex:0];
                }
                if (dataArray.count > 0) {
                    [weakSelf.noticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新业务",(long)dataArray.count]];
                } else{
                    [weakSelf.noticeView showWithText:@"暂无新业务，休息一会儿"];
                }
            } else if([target isEqualToString:@"load"]){
                [weakSelf.dataArr addObjectsFromArray:dataArray];
                if (dataArray.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }

            [weakSelf.tableView reloadData];
            [Hud hideHud];
        }
    }];
}

#pragma mark ------其他函数部分
- (void)deleteBusinessWithBusinessID:(NSString *)businessID
{
    [self.dataArr enumerateObjectsUsingBlock:^(SHGBusinessObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.businessID isEqualToString:businessID]) {
            [self.dataArr removeObject:obj];
        }
    }];
    [self.tableView reloadData];
}


#pragma mark ------tableview代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count == 0) {
        self.emptyView.type = SHGEmptyDataNormal;
        return self.emptyCell;
    } else{
        if (self.userId) {
            NSString *identifier = @"SHGBusinessTableViewCell";
            SHGBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] lastObject];
            }
            cell.style = SHGBusinessTableViewCellStyleOther;
            cell.object = [self.dataArr objectAtIndex:indexPath.row];
            cell.object.auditState = @"0";
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            return cell;
        } else{
            NSString *identifier = @"SHGBusinessMyTableViewCell";
            SHGBusinessMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] lastObject];
            }
            cell.delegate = self;
            cell.array = @[[self.dataArr objectAtIndex:indexPath.row],@"mine"];
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            return cell;
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count == 0) {
        return 1;
    } else {
        return self.dataArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        if (self.userId) {
            SHGBusinessObject *object = [self.dataArr objectAtIndex:indexPath.row];
            CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[SHGBusinessTableViewCell class] contentViewWidth:SCREENWIDTH];
            return height;
        } else{
            SHGBusinessObject *object = [self.dataArr objectAtIndex:indexPath.row];
            NSArray *array = @[object,@"mine"];
            CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:array keyPath:@"array" cellClass:[SHGBusinessMyTableViewCell class] contentViewWidth:SCREENWIDTH];
            return height;
        }

    } else{
        return CGRectGetHeight(self.view.frame);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        SHGBusinessObject *object = [self.dataArr objectAtIndex:indexPath.row];
        SHGBusinessNewDetailViewController *controller = [[SHGBusinessNewDetailViewController alloc]init];
        controller.object = object;
        [self.navigationController pushViewController:controller animated:YES];

        [[SHGGloble sharedGloble] recordUserAction:[NSString stringWithFormat:@"%@#%@", object.businessID, object.type] type:@"business_detail"];
    }
}

- (void)goToEditBusiness:(SHGBusinessObject *)object
{
    if ([object.type isEqualToString:@"moneyside"]) {
        if ([object.moneysideType isEqualToString:@"equityInvest"]) {
            SHGEquityInvestSendViewController *viewController = [[SHGEquityInvestSendViewController alloc] init];
            viewController.object = object;
            [self.navigationController pushViewController:viewController animated:YES];
            
        } else if ([object.moneysideType isEqualToString:@"bondInvest"]){
            SHGBondInvestSendViewController *viewController = [[SHGBondInvestSendViewController alloc] init];
            viewController.object = object;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else if ([object.type isEqualToString:@"bondfinancing"]){
        SHGBondFinanceSendViewController *viewController = [[SHGBondFinanceSendViewController alloc] init];
        viewController.object = object;
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([object.type isEqualToString:@"equityfinancing"]){
        SHGEquityFinanceSendViewController *viewController = [[SHGEquityFinanceSendViewController alloc] init];
        viewController.object = object;
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([object.type isEqualToString:@"trademixed"]){
        SHGSameAndCommixtureSendViewController *viewController = [[SHGSameAndCommixtureSendViewController alloc] init];
        viewController.object = object;
        [self.navigationController pushViewController:viewController animated:YES];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
