//
//  SHGMarketListViewController.m
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketListViewController.h"
#import "SHGMarketTableViewCell.h"
#import "SHGMarketManager.h"
#import "SHGMarketObject.h"
#import "SHGCategoryScrollView.h"
#import "SHGEmptyDataView.h"

@interface SHGMarketListViewController ()<UITabBarDelegate, UITableViewDataSource, SHGCategoryScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SHGCategoryScrollView *sectionHeaderView;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@property (strong, nonatomic) NSMutableArray *currentArray;
@end

@implementation SHGMarketListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];
    __weak typeof(self) weakSelf = self;
    [[SHGMarketManager shareManager] loadMarketCategoryBlock:^(NSArray *array) {
        weakSelf.sectionHeaderView.categoryArray = array;
        for (NSInteger i = 0; i < array.count; i++) {
            NSMutableArray *subArray = [NSMutableArray array];
            [weakSelf.dataArr addObject:subArray];
        }
        weakSelf.currentArray = [weakSelf.dataArr firstObject];
        [weakSelf loadMarketList:@"first" firstId:[weakSelf.sectionHeaderView marketFirstId] second:[weakSelf.sectionHeaderView marketSecondId] marketId:@"-1"];
    }];
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
            [weakSelf.currentArray removeAllObjects];
            [weakSelf.currentArray addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
        } else if([target isEqualToString:@"refresh"]){
            [weakSelf.currentArray addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
        } else if([target isEqualToString:@"load"]){
            [weakSelf.currentArray addObjectsFromArray:array];
            if (array.count < 10) {
                [weakSelf.tableView.footer endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}


- (SHGCategoryScrollView *)sectionHeaderView
{
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[SHGCategoryScrollView alloc] initWithFrame:CGRectZero];
        _sectionHeaderView.delegate = self;
    }
    return _sectionHeaderView;
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
    if (self.currentArray.count > 0) {
        [self loadMarketList:@"refresh" firstId:[self.sectionHeaderView marketFirstId] second:[self.sectionHeaderView marketSecondId] marketId:[self maxMarketID]];
    } else{
        [self loadMarketList:@"first" firstId:[self.sectionHeaderView marketFirstId] second:[self.sectionHeaderView marketSecondId] marketId:@"-1"];
    }
}


- (void)refreshFooter
{
    if (self.currentArray.count > 0) {
        [self loadMarketList:@"load" firstId:[self.sectionHeaderView marketFirstId] second:[self.sectionHeaderView marketSecondId] marketId:[self minMarketID]];
    } else{
        [self loadMarketList:@"first" firstId:[self.sectionHeaderView marketFirstId] second:[self.sectionHeaderView marketSecondId] marketId:@"-1"];
    }
}

- (NSString *)maxMarketID
{
    return ((SHGMarketObject *)[self.currentArray firstObject]).marketId;
}

- (NSString *)minMarketID
{
    return ((SHGMarketObject *)[self.currentArray lastObject]).marketId;
}

#pragma mark ------tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentArray.count > 0) {
        NSInteger count = self.currentArray.count;
        return count;
    } else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentArray.count > 0) {
        return kMarketCellHeight;
    } else{
        return CGRectGetHeight(self.view.frame);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kCategoryScrollViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"SHGMarketTableViewCell";
    if (self.currentArray.count > 0) {
        SHGMarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGMarketTableViewCell" owner:self options:nil] lastObject];
        }
        return cell;
    } else{
        return self.emptyCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentArray.count > 0) {

    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionHeaderView;
}

#pragma mark ------切换分类代理
- (void)didChangeToIndex:(NSInteger)index firstId:(NSString *)firstId secondId:(NSString *)secondId
{
    NSMutableArray *subArray = [self.dataArr objectAtIndex:index];
    if (!subArray || subArray.count == 0) {
        self.currentArray = subArray;
        [self loadMarketList:@"first" firstId:firstId second:secondId marketId:@"-1"];
    } else{
        self.currentArray = subArray;
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
