//
//  SHGMarketSecondCategoryListTableViewController.m
//  Finance
//
//  Created by 魏虔坤 on 15/12/29.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketSecondCategoryListTableViewController.h"
#import "SHGMarketTableViewCell.h"
#import "SHGMarketManager.h"
#import "SHGMarketObject.h"
#import "SHGCategoryScrollView.h"
#import "SHGEmptyDataView.h"
#import "SHGMarketDetailViewController.h"
#import "SHGMarketSegmentViewController.h"

@interface SHGMarketSecondCategoryListTableViewController ()<UITabBarDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@property (strong, nonatomic) NSString * firstCategory;
@property (strong, nonatomic) NSString * seocndName;
@property (strong, nonatomic) NSString * secondId;
@end

@implementation SHGMarketSecondCategoryListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];
    [self loadMarketList:@"first" firstId:self.firstCategory second:self.secondId marketId:@"-1"];

}
- (void)fromSecondCategore: (NSString *)firstCategory seocndName:(NSString *)name secondId:(NSString * )secondId
{
    self.title = name;
    self.firstCategory = firstCategory;
    self.seocndName = name;
    self.secondId = secondId;
}
- (void)loadMarketList:(NSString *)target firstId:(NSString *)firstId second:(NSString *)secondId marketId:(NSString *)marketId
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"marketId":marketId ,@"uid":uid ,@"type":@"all" ,@"target":target ,@"pageSize":@"10" ,@"firstCatalog":firstId ,@"secondCatalog":secondId};
    [SHGMarketManager loadMarketList:param block:^(NSArray *array) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        if ([target isEqualToString:@"first"]) {
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
        } else if([target isEqualToString:@"refresh"]){
            [weakSelf.dataArr addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
        } else if([target isEqualToString:@"load"]){
            [weakSelf.dataArr addObjectsFromArray:array];
            if (array.count < 10) {
                [weakSelf.tableView.footer endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView reloadData];
        }
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
        [self loadMarketList:@"refresh" firstId:@"" second:@"" marketId:[self maxMarketID]];
    } else{
        [self loadMarketList:@"first" firstId:@"" second:@"" marketId:@"-1"];
    }
}


- (void)refreshFooter
{
    if (self.dataArr.count > 0) {
        [self loadMarketList:@"load" firstId:@"" second:@"" marketId:[self minMarketID]];
    } else{
        [self loadMarketList:@"first" firstId:@"" second:@"" marketId:@"-1"];
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
        return kMarketCellHeight;
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
        [cell loadDataWithObject:[self.dataArr objectAtIndex:indexPath.row] type:SHGMarketTableViewCellTypeOther];
        return cell;
    } else{
        return self.emptyCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        SHGMarketDetailViewController *controller = [[SHGMarketDetailViewController alloc] init];
        controller.object = [self.dataArr objectAtIndex:indexPath.row];
        controller.delegate = [SHGMarketSegmentViewController sharedSegmentController];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
