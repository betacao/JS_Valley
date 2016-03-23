//
//  SHGMarketViewController.m
//  Finance
//
//  Created by weiqiankun on 16/3/15.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMarketCollectionViewController.h"
#import "SHGMarketTableViewCell.h"
#import "SHGMarketManager.h"
#import "SHGMarketObject.h"
#import "SHGCategoryScrollView.h"
#import "SHGEmptyDataView.h"
#import "SHGMarketDetailViewController.h"
#import "SHGPersonalViewController.h"
#import "SHGMarketSegmentViewController.h"
@interface SHGMarketCollectionViewController ()<UITabBarDelegate, UITableViewDataSource, SHGMarketTableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;

@end

@implementation SHGMarketCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"业务收藏";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];
    [self requestMarketCollectWithTarget:@"first" time:@"0"];


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
    [self requestMarketCollectWithTarget:@"first" time:@"0"];
}

- (void)requestMarketCollectWithTarget:(NSString *)target time:(NSString *)time
{
    if ([target isEqualToString:@"first"])
    {
        [self.tableView.footer resetNoMoreData];
//        hasDataFinished = NO;
        
    }

    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [Hud showWait];
    NSDictionary *param = @{@"uid":uid,@"target":target,@"time":time,@"num":@"100"};
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"market",@"collection"] class:[SHGMarketObject class] parameters:param success:^(MOCHTTPResponse *response) {
        NSDictionary *dictionary = response.dataDictionary;
        NSArray * dataArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[dictionary objectForKey:@"datas"] class:[SHGMarketObject class]];

        if ([target isEqualToString:@"first"]) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:dataArray];
            [self.tableView reloadData];
        }
        if ([target isEqualToString:@"refresh"]) {
            if (dataArray.count > 0) {
                for (NSInteger i = dataArray.count-1; i >= 0; i --) {
                    SHGMarketObject *obj = dataArray[i];
                    [self.dataArr insertObject:obj atIndex:0];
                }
                [self.tableView reloadData];
            }
            
        }
        if ([target isEqualToString:@"load"]) {
            [self.dataArr addObjectsFromArray:dataArray];
            [self.tableView.footer endRefreshingWithNoMoreData];

        }
        [self reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.footer endRefreshing];
        [Hud hideHud];
        
    } failed:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.errorMessage);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.footer endRefreshing];
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
        [self requestMarketCollectWithTarget:@"refresh" time:@""];
    } else{
        [self requestMarketCollectWithTarget:@"first" time:@""];
    }
    
}

- (void)refreshFooter
{
    if (self.dataArr.count > 0) {
        [self requestMarketCollectWithTarget:@"load" time:@""];
        
    } else{
        [self requestMarketCollectWithTarget:@"first" time:@""];
    }
}

- (NSString *)maxMarketID
{
    return ((SHGMarketObject *)[self.dataArr firstObject]).marketId;
}

- (NSString *)minMarketID
{
    return ((SHGMarketObject *)[self.dataArr lastObject]).marketId;
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
        
        SHGMarketObject *object = [self.dataArr objectAtIndex:indexPath.row];
        CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[SHGMarketTableViewCell class] contentViewWidth:SCREENWIDTH];
        return height;
    } else{
        return CGRectGetHeight(self.view.frame);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"SHGMarketTableViewCell";
    if (self.dataArr.count > 0) {
        SHGMarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGMarketTableViewCell" owner:self options:nil] lastObject];
        }
        cell.delegate = self;
        cell.object = [self.dataArr objectAtIndex:indexPath.row];
        return cell;
    } else{
        return self.emptyCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        SHGMarketDetailViewController *controller = [[SHGMarketDetailViewController alloc] init];
        controller.controller = self;
        controller.object = [self.dataArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark ------SHGMarketTableViewCellDelegate
- (void)clickPrasiseButton:(SHGMarketObject *)object
{
    [[SHGMarketSegmentViewController sharedSegmentController] addOrDeletePraise:object block:^(BOOL success) {
        
    }];
}
- (void)clickCollectButton:(SHGMarketObject *)object state:(void (^)(BOOL))block
{
    [[SHGMarketSegmentViewController sharedSegmentController] addOrDeleteCollect:object state:^(BOOL state) {
        //        block(state);
    }];
}
- (void)clickCommentButton:(SHGMarketObject *)object
{
    SHGMarketDetailViewController *controller = [[SHGMarketDetailViewController alloc] init];
    controller.object = object;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickEditButton:(SHGMarketObject *)object
{
    SHGMarketSendViewController *controller = [[SHGMarketSendViewController alloc] init];
    controller.object = object;
    controller.delegate = [SHGMarketSegmentViewController sharedSegmentController];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickDeleteButton:(SHGMarketObject *)object
{
    [[SHGMarketSegmentViewController sharedSegmentController] deleteMarket:object];
}

- (void)changeMarketCollection
{
     [self requestMarketCollectWithTarget:@"first" time:@"-1"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
