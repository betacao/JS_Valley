//
//  SHGCardCollectionViewController.m
//  Finance
//
//  Created by weiqiankun on 16/3/16.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCardCollectionViewController.h"
#import "SHGCollectCardClass.h"
#import "SHGEmptyDataView.h"
#import "SHGPersonalViewController.h"
#import "SHGCardTableViewCell.h"
@interface SHGCardCollectionViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@end

@implementation SHGCardCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"名片收藏";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];
    [self requestCardListWithTarget:@"first" time:@"0"];
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
    [self requestCardListWithTarget:@"first" time:@"0"];
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


- (void)requestCardListWithTarget:(NSString *)target time:(NSString *)time
{
    if ([target isEqualToString:@"first"])
    {
        [self.tableView.mj_footer resetNoMoreData];
        
    }
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [Hud showWait];
    NSDictionary *param = @{@"uid":uid,
                            @"target":target,
                            @"time":time,
                            @"num":@"100"};
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"userCard",@"myCardlist"] class:[SHGCollectCardClass class] parameters:param success:^(MOCHTTPResponse *response) {
        NSLog(@"=========%@",response.dataArray);
        
        if ([target isEqualToString:@"first"]) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:response.dataArray];
            [self.tableView reloadData];
        }
        if ([target isEqualToString:@"refresh"]) {
             [self.dataArr removeAllObjects];
            if (response.dataArray.count > 0) {
                for (NSInteger i = response.dataArray.count-1; i >= 0; i --) {
                    SHGCollectCardClass *obj = response.dataArray[i];
                    [self.dataArr insertObject:obj atIndex:0];
                }
                [self.tableView reloadData];
            }
            
        }
        if ([target isEqualToString:@"load"]) {
            [self.dataArr addObjectsFromArray:response.dataArray];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
        }
        [self.tableView reloadData];
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
        [self requestCardListWithTarget:@"refresh" time:@""];
    } else{
        [self requestCardListWithTarget:@"first" time:@""];
    }

}

- (void)refreshFooter
{
    if (self.dataArr.count > 0) {
        [self requestCardListWithTarget:@"load" time:@""];
        
    } else{
        [self requestCardListWithTarget:@"first" time:@""];
    }


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
        return MarginFactor(90.0f);
    } else{
        return CGRectGetHeight(self.view.frame);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"SHGCardTableViewCell";
    if (self.dataArr.count > 0) {
        SHGCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGCardTableViewCell" owner:self options:nil] lastObject];
        }
        cell.object = [self.dataArr objectAtIndex:indexPath.row];
      //  [cell loadNewUiFortype:SHGMarketTableViewCellTypeAll];
        return cell;
    } else{
        return self.emptyCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        SHGCollectCardClass * obj = self.dataArr[indexPath.row];
        SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] init];
        controller.controller = self;
        controller.userId = obj.uid;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)changeCardCollection
{
    [self requestCardListWithTarget:@"first" time:@"-1"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
