//
//  SHGBusinessCollectionListViewController.m
//  Finance
//
//  Created by weiqiankun on 16/4/13.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessCollectionListViewController.h"
#import "SHGEmptyDataView.h"
#import "SHGBusinessManager.h"
#import "SHGBusinessObject.h"
#import "SHGBusinessTableViewCell.h"
@interface SHGBusinessCollectionListViewController ()<UITabBarDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@end

@implementation SHGBusinessCollectionListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"业务收藏";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"efeeef"];
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];
    [self requestBusinessCollectWithTarget:@"first" modifyTime:@""];
}

- (NSMutableArray *)currentDataArray
{
    return self.dataArr;
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)refreshData
{
    [self requestBusinessCollectWithTarget:@"first" modifyTime:@""];
}
- (void)requestBusinessCollectWithTarget:(NSString *)target modifyTime:(NSString *)modifyTime
{
    if ([target isEqualToString:@"first"])
    {
        [self.tableView.mj_footer resetNoMoreData];
        
    }
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [Hud showWait];
    NSDictionary *param = @{@"uid":uid,@"target":target,@"modifyTime":modifyTime,@"pageSize":@"100"};
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@/%@/%@",rBaseAddressForHttp,@"business",@"collection",@"myCollectBusiness"] class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSDictionary *dictionary = response.dataDictionary;
        NSArray * dataArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[dictionary objectForKey:@"businesslist"] class:[SHGBusinessObject class]];
        NSLog(@"%@",dataArray);
        if ([target isEqualToString:@"first"]) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:dataArray];
            [self.tableView reloadData];
        }
        if ([target isEqualToString:@"refresh"]) {
            if (dataArray.count > 0) {
                for (NSInteger i = dataArray.count-1; i >= 0; i --) {
                    SHGBusinessObject *obj = dataArray[i];
                    [self.dataArr insertObject:obj atIndex:0];
                }
                [self.tableView reloadData];
            }
            
        }
        if ([target isEqualToString:@"load"]) {
            [self.dataArr addObjectsFromArray:dataArray];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        [self reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Hud hideHud];
        
    } failed:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.errorMessage);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Hud hideHud];
        
    }];
    
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


- (void)refreshHeader
{
    if (self.dataArr.count > 0) {
        [self requestBusinessCollectWithTarget:@"refresh" modifyTime:@""];
    } else{
        [self requestBusinessCollectWithTarget:@"first" modifyTime:@""];
    }
    
}

- (void)refreshFooter
{
    if (self.dataArr.count > 0) {
        [self requestBusinessCollectWithTarget:@"load" modifyTime:@""];
        
    } else{
        [self requestBusinessCollectWithTarget:@"first" modifyTime:@""];
    }
}

- (NSString *)maxBusinessID
{
    return ((SHGBusinessObject *)[self.dataArr firstObject]).businessID;
}

- (NSString *)minBusinessID
{
    return ((SHGBusinessObject *)[self.dataArr lastObject]).businessID;
}

#pragma mark ------tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count > 0) {
        NSInteger count = self.dataArr.count;
        return count;
    } else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        SHGBusinessObject *object = [self.dataArr objectAtIndex:indexPath.row];
        CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[SHGBusinessTableViewCell class] contentViewWidth:SCREENWIDTH];
        return height;
        
    } else{
        return CGRectGetHeight(self.view.frame);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count == 0) {
        return self.emptyCell;
    } else {
        SHGBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHGBusinessTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGBusinessTableViewCell" owner:self options:nil] lastObject];
        }
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        cell.object = [self.dataArr objectAtIndex:indexPath.row];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
//        SHGMarketDetailViewController *controller = [[SHGMarketDetailViewController alloc] init];
//        controller.controller = self;
//        controller.object = [self.dataArr objectAtIndex:indexPath.row];
//        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



@end
