//
//  MessageViewController.m
//  Finance
//
//  Created by haibo li on 15/5/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "SHGPersonalViewController.h"
#import "LinkViewController.h"
#import "SHGBusinessObject.h"
#import "SHGBusinessNewDetailViewController.h"
#import "SHGBusinessRecommendViewController.h"
#import "SHGEquityInvestSendViewController.h"
#import "SHGBondInvestSendViewController.h"
#import "SHGBondFinanceSendViewController.h"
#import "SHGEquityFinanceSendViewController.h"
#import "SHGSameAndCommixtureSendViewController.h"
#import "SHGBusinessMineViewController.h"

@interface MessageViewController ()
{
    BOOL hasDataFinished;
    BOOL hasRequestFailed;
    NSString *_target;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"MessageViewController" label:@"onClick"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"通知";
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:NOTIFI_SENDPOST object:nil];
    [self refreshData];
}

- (void)refreshData
{
    [self requestDataWithTarget:@"first" time:@"-1"];
}

- (void)requestDataWithTarget:(NSString *)target time:(NSString *)time
{
    NSDictionary *param = nil;
    if([@"-1" isEqualToString:time]){
        param= @{@"uid":UID, @"target":target, @"num":rRequestNum};
    } else{
        param= @{@"uid":UID, @"target":target, @"time":time, @"num":rRequestNum};
    }

    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpUser,@"notice"] class:[MessageObj class] parameters:param success:^(MOCHTTPResponse *response) {
        if ([target isEqualToString:@"first"]){
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:response.dataArray];
        }

        if ([target isEqualToString:@"refresh"]){
            if (response.dataArray.count > 0) {
                for (NSInteger i = response.dataArray.count-1; i >= 0; i --) {
                    MessageObj *obj = response.dataArray[i];
                    [self.dataArr insertObject:obj atIndex:0];
                }
            }
        }

        if ([target isEqualToString:@"load"]) {
            [self.dataArr addObjectsFromArray:response.dataArray];
        }

        if (IsArrEmpty(response.dataArray)){
            hasDataFinished = YES;
        } else{
            hasDataFinished = NO;
        }

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden = NO;
        [self.tableView reloadData];

    } failed:^(MOCHTTPResponse *response) {
        self.tableView.mj_footer.hidden = NO;
        [Hud showMessageWithText:response.errorMessage];
        NSLog(@"%@",response.errorMessage);
        [self.tableView.mj_header endRefreshing];
        [self performSelector:@selector(endrefresh) withObject:nil afterDelay:0.5];
    }];
}

- (void)endrefresh
{
    [self.tableView.mj_footer endRefreshing];
}

- (void)refreshHeader
{
    NSLog(@"refreshHeader");
    _target = @"refresh";
    if (self.dataArr.count > 0){
        MessageObj *obj = self.dataArr[0];
        [self requestDataWithTarget:@"refresh" time:obj.time];
    } else{
        [self requestDataWithTarget:@"first" time:@"-1"];
    }
}

-(void)chageValue
{
    hasRequestFailed = NO;
}

- (void)refreshFooter
{
    if (hasDataFinished){
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    _target = @"load";
    NSLog(@"refreshFooter");
    if (self.dataArr.count > 0){
        MessageObj *obj = [self.dataArr lastObject];
        [self requestDataWithTarget:@"load" time:obj.time];
    }
}

#pragma mark =============  UITableView DataSource  =============
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageObj *obj = self.dataArr[indexPath.row];
    CGFloat height = [tableView cellHeightForIndexPath:indexPath model:obj keyPath:@"object" cellClass:[MessageTableViewCell class] contentViewWidth:SCREENWIDTH];
    return  height;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MessageTableViewCell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:self options:nil] lastObject];
    }
    cell.object = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}



#pragma mark =============  UITableView Delegate  =============

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageObj *obj = self.dataArr[indexPath.row];
    if ([obj.code isEqualToString:@"1001"])
    {
        //进入通知

    } else if ([obj.code isEqualToString:@"1004"]){
        //进入关注人个人主页
        //进入帖子详情
        MessageObj *obj = self.dataArr[indexPath.row];
        SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
        controller.userId = obj.oid;
        [self.navigationController pushViewController:controller animated:YES];

    } else if ([obj.code isEqualToString:@"1005"] || [obj.code isEqualToString:@"1006"]){
        //进入认证页面
        SHGAuthenticationViewController *controller = [[SHGAuthenticationViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        UINavigationController *nav = (UINavigationController *)[AppDelegate currentAppdelegate].window.rootViewController;
        [nav pushViewController:controller animated:YES];
    } else if ([obj.code isEqualToString:@"1010"] || [obj.code isEqualToString:@"1011"]){
        //之前的活动
    } else if ([obj.code isEqualToString:@"1013"]){
        //feed流
        CircleListObj *object = [[CircleListObj alloc] init];
        object.feedhtml = obj.feedHtml;
        LinkViewController *controller = [[LinkViewController alloc] init];
        controller.url = object.feedhtml;
        controller.object = object;
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([obj.code isEqualToString:@"3000"]){
        //之前的业务详情
    } else if ([obj.code isEqualToString:@"1014"]){
        //新版业务的推送
        NSString *businessId = obj.oid;
        NSString *businessType = obj.unionID;
        SHGBusinessNewDetailViewController *controller = [[SHGBusinessNewDetailViewController alloc] init];
        SHGBusinessObject *object = [[SHGBusinessObject alloc] init];
        object.businessID = businessId;
        object.type = businessType;
        controller.object = object;
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([obj.code isEqualToString:@"1015"]){
        NSString *businessId = obj.oid;
        NSString *type = obj.unionID;
        SHGBusinessObject *object = [[SHGBusinessObject alloc] init];
        object.businessID = businessId;
        object.type = type;
        SHGBusinessNewDetailViewController *controller = [[SHGBusinessNewDetailViewController alloc] init];
        controller.object = object;
        [self.navigationController pushViewController:controller animated:YES];
        
    } else if ([obj.code isEqualToString:@"1016"]){
        //新版业务的推送
        NSString *businessId = obj.oid;
        NSString *businessType = obj.unionID;
        SHGBusinessRecommendViewController *controller = [[SHGBusinessRecommendViewController alloc] init];
        SHGBusinessObject *object = [[SHGBusinessObject alloc] init];
        object.businessID = businessId;
        object.type = businessType;
        controller.object = object;
        controller.time = [[obj.time componentsSeparatedByString:@" "] firstObject];
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([obj.code isEqualToString:@"1017"]){
        SHGBusinessMineViewController *controller = [[SHGBusinessMineViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([obj.code isEqualToString:@"1002"] || [obj.code isEqualToString:@"1003"] || [obj.code isEqualToString:@"1007"] || [obj.code isEqualToString:@"1008"]){
        //进入帖子详情
        CircleDetailViewController *vc = [[CircleDetailViewController alloc] initWithNibName:@"CircleDetailViewController" bundle:nil];
        MessageObj *obj = self.dataArr[indexPath.row];
        vc.rid = obj.oid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
