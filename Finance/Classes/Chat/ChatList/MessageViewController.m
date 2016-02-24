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
#import "SHGActionDetailViewController.h"
#import "LinkViewController.h"
#import "SHGMarketSegmentViewController.h"

@interface MessageViewController ()
{
    BOOL hasDataFinished;
    BOOL hasRequestFailed;
    NSString *_target;
}

@property (strong, nonatomic) UITableView *tableView;
@property(nonatomic,strong)MessageTableViewCell *prototypeCell;
@end

@implementation MessageViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"MessageViewController" label:@"onClick"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"通知";
    UINib *cellNib = [UINib nibWithNibName:@"MessageTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    self.prototypeCell  = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    [self.view addSubview:self.tableView];
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:NOTIFI_SENDPOST object:nil];
    [self requestDataWithTarget:@"first" time:@"-1"];
    [self.tableView reloadData];
}

- (void)refreshData
{
    [self requestDataWithTarget:@"first" time:@"-1"];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    return _tableView;
}
-(void)requestDataWithTarget:(NSString *)target time:(NSString *)time
{
    [Hud showLoadingWithMessage:@"加载中"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    
    NSDictionary *param;
    if([@"-1" isEqualToString:time]){
        param= @{@"uid":uid, @"target":target, @"num":rRequestNum};
    } else{
        param= @{@"uid":uid, @"target":target, @"time":time, @"num":rRequestNum};
    }

    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpUser,@"notice"] class:[MessageObj class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        NSLog(@"=data = %@",response.dataArray);
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
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        self.tableView.footer.hidden = NO;
        [self.tableView reloadData];
        
    } failed:^(MOCHTTPResponse *response) {
        self.tableView.footer.hidden = NO;
        [Hud showMessageWithText:response.errorMessage];
        NSLog(@"%@",response.errorMessage);
        [self.tableView.header endRefreshing];
        [self performSelector:@selector(endrefresh) withObject:nil afterDelay:0.5];
        [Hud hideHud];

        
    }];
}

-(void)endrefresh
{
    [self.tableView.footer endRefreshing];

}

-(void)refreshHeader
{
    NSLog(@"refreshHeader");
    _target = @"refresh";
    if (self.dataArr.count > 0)
    {
        MessageObj *obj = self.dataArr[0];
        [self requestDataWithTarget:@"refresh" time:obj.time];
    }
    else
    {
        [self requestDataWithTarget:@"first" time:@"-1"];
    }
}
-(void)chageValue
{
    hasRequestFailed = NO;
}

-(void)refreshFooter
{
    if (hasDataFinished){
        [self.tableView.footer endRefreshingWithNoMoreData];
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
    
    return  [obj heightForCell];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"messageTableViewCellIdentifier";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadDatasWithObj:self.dataArr[indexPath.row]];
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
        VerifyIdentityViewController *vc = [[VerifyIdentityViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        UINavigationController *nav = (UINavigationController *)[AppDelegate currentAppdelegate].window.rootViewController;
        [nav pushViewController:vc animated:YES];
    } else if ([obj.code isEqualToString:@"1010"] || [obj.code isEqualToString:@"1011"]){
        SHGActionDetailViewController *controller = [[SHGActionDetailViewController alloc] init];
        SHGActionObject *object = [[SHGActionObject alloc] init];
        object.meetId = obj.oid;
        controller.object = object;
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([obj.code isEqualToString:@"1013"]){
        //feed流
        CircleListObj *object = [[CircleListObj alloc] init];
        object.feedhtml = obj.feedHtml;
        LinkViewController *controller = [[LinkViewController alloc] init];
        controller.url = object.feedhtml;
        controller.object = object;
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([obj.code isEqualToString:@"3000"]){
        SHGMarketDetailViewController *controller = [[SHGMarketDetailViewController alloc] init];
        SHGMarketObject *object = [[SHGMarketObject alloc] init];
        object.marketId = obj.oid;
        controller.object = object;
        [self.navigationController pushViewController:controller animated:YES];
    } else{
        //进入帖子详情
        CircleDetailViewController *vc = [[CircleDetailViewController alloc] initWithNibName:@"CircleDetailViewController" bundle:nil];
        MessageObj *obj = self.dataArr[indexPath.row];
        vc.rid = obj.oid;
        [self.navigationController pushViewController:vc animated:YES];
    }
                                                     
    NSLog(@"You Click At Section: %ld Row: %ld",(long)indexPath.section,(long)indexPath.row);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
