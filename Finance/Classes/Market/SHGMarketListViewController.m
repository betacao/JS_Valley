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
#import "SHGCategoryScrollView.h"
#import "SHGEmptyDataView.h"
#import "SHGMarketDetailViewController.h"
#import "SHGMarketSecondCategoryViewController.h"
#import "SHGPersonalViewController.h"
#import "SHGMarketSegmentViewController.h"
#import "SHGMarketSendViewController.h"
#import "VerifyIdentityViewController.h"

@interface SHGMarketListViewController ()<UITabBarDelegate, UITableViewDataSource, SHGCategoryScrollViewDelegate,SHGMarketSecondCategoryViewControllerDelegate, SHGMarketTableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) SHGCategoryScrollView *scrollView;
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
        weakSelf.scrollView.categoryArray = array;
        for (NSInteger i = 0; i < array.count; i++) {
            NSMutableArray *subArray = [NSMutableArray array];
            [weakSelf.dataArr addObject:subArray];
        }
        weakSelf.currentArray = [weakSelf.dataArr firstObject];
        [weakSelf loadMarketList:@"first" firstId:[weakSelf.scrollView marketFirstId] second:[weakSelf.scrollView marketSecondId] marketId:@"-1" modifyTime:@""];
    }];
}

- (NSMutableArray *)currentDataArray
{
    NSMutableArray *array = [NSMutableArray array];
    [self.dataArr enumerateObjectsUsingBlock:^(NSArray *subArray, NSUInteger idx, BOOL * _Nonnull stop) {
        [subArray enumerateObjectsUsingBlock:^(SHGMarketObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:obj];
        }];
    }];
    return array;
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)refreshData
{
    [self loadMarketList:@"first" firstId:[self.scrollView marketFirstId] second:[self.scrollView marketSecondId] marketId:@"-1" modifyTime:@""];
}

- (void)scrollToCategory:(SHGMarketFirstCategoryObject *)object
{
    NSInteger index = [self.scrollView.categoryArray indexOfObject:object];
    [self.scrollView moveToIndex:index];
}

- (void)loadMarketList:(NSString *)target firstId:(NSString *)firstId second:(NSString *)secondId marketId:(NSString *)marketId modifyTime:(NSString *)modifyTime
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"marketId":marketId ,@"uid":uid ,@"type":@"all" ,@"target":target ,@"pageSize":@"10" ,@"firstCatalog":firstId ,@"secondCatalog":secondId, @"modifyTime":modifyTime};
    [SHGMarketManager loadMarketList:param block:^(NSArray *array) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        if ([target isEqualToString:@"first"]) {
            [weakSelf.currentArray removeAllObjects];
            [weakSelf.currentArray addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
        } else if([target isEqualToString:@"refresh"]){
            for (NSInteger i = array.count - 1; i >= 0; i--){
                SHGMarketObject *obj = [array objectAtIndex:i];
                [weakSelf.currentArray insertObject:obj atIndex:0];
            }
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


- (SHGCategoryScrollView *)scrollView
{
    if (!_scrollView) {
//        UIImage *image = [UIImage imageNamed:@"more_CategoryButton"];
        _scrollView = [[SHGCategoryScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, kCategoryScrollViewHeight)];
        _scrollView.categoryDelegate = self;
    }
    return _scrollView;
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
        [self loadMarketList:@"refresh" firstId:[self.scrollView marketFirstId] second:[self.scrollView marketSecondId] marketId:[self maxMarketID] modifyTime:[self maxModifyTime]];
    } else{
        [self loadMarketList:@"first" firstId:[self.scrollView marketFirstId] second:[self.scrollView marketSecondId] marketId:@"-1" modifyTime:@""];
    }
}


- (void)refreshFooter
{
    if (self.currentArray.count > 0) {
        [self loadMarketList:@"load" firstId:[self.scrollView marketFirstId] second:[self.scrollView marketSecondId] marketId:[self minMarketID] modifyTime:@""];
    } else{
        [self loadMarketList:@"first" firstId:[self.scrollView marketFirstId] second:[self.scrollView marketSecondId] marketId:@"-1" modifyTime:@""];
    }
}

- (NSString *)maxMarketID
{
    NSString *marketID = @"";
    for (SHGMarketObject *object in self.currentArray) {
        if ([object.marketId compare:marketID options:NSNumericSearch] == NSOrderedDescending) {
            marketID = object.marketId;
        }
    }
    return marketID;
}

- (NSString *)minMarketID
{
    SHGMarketObject *object = [self.currentArray firstObject];
    NSString *marketID = object.marketId;
    for (SHGMarketObject *object in self.currentArray) {
        if ([object.marketId compare:marketID options:NSNumericSearch] == NSOrderedAscending) {
            marketID = object.marketId;
        }
    }
    return marketID;
}

- (NSString *)maxModifyTime
{
    NSString *modifyTime = @"";
    for (SHGMarketObject *object in self.currentArray) {
        if ([object.modifyTime compare:modifyTime options:NSNumericSearch] == NSOrderedDescending) {
            modifyTime = object.modifyTime;
        }
    }
    return modifyTime;
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
        cell.delegate = self;
        SHGMarketFirstCategoryObject  *obj  = [self.scrollView.categoryArray objectAtIndex:[self.scrollView currentIndex]];
         if (obj.secondCataLogs.count == 0 && [self.scrollView currentIndex] != 0) {
            [cell loadNewUi];
        } else{
            [cell loadDataWithObject:[self.currentArray objectAtIndex:indexPath.row] type:SHGMarketTableViewCellTypeAll];
        }
        return cell;
    } else{
        return self.emptyCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentArray.count > 0) {
        SHGMarketDetailViewController *controller = [[SHGMarketDetailViewController alloc]init];
        controller.object = [self.currentArray objectAtIndex:indexPath.row];
        controller.delegate = [SHGMarketSegmentViewController sharedSegmentController];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.headerView) {
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, CGRectGetHeight(self.scrollView.frame))];
        [self.headerView addSubview:self.scrollView];
        //添加右面...按钮
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreButton setBackgroundImage:[UIImage imageNamed:@"more_CategoryButton"] forState:UIControlStateNormal];
        [moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        [moreButton sizeToFit];
        CGRect frame = moreButton.frame;
        frame.origin.x = SCREENWIDTH - CGRectGetWidth(frame);
        moreButton.frame = frame;
//        [self.headerView addSubview:moreButton];

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, kCategoryScrollViewHeight, SCREENWIDTH, 0.5f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"d9dadb"];
        [self.headerView addSubview:lineView];
    }
    return self.headerView;
}
#pragma mark -----二级分类返回代理
- (void)backFromSecondChangeToIndex:(NSInteger)index
{
    [self.scrollView moveToIndex:index];
}

#pragma mark ------切换分类代理
- (void)didChangeToIndex:(NSInteger)index firstId:(NSString *)firstId secondId:(NSString *)secondId
{
    NSMutableArray *subArray = [self.dataArr objectAtIndex:index];
    if (!subArray || subArray.count == 0) {
        self.currentArray = subArray;
        [self loadMarketList:@"first" firstId:firstId second:secondId marketId:@"-1" modifyTime:@""];
    } else{
        self.currentArray = subArray;
        [self.tableView reloadData];
    }
}

#pragma mark ------点击更多按钮

- (void)clickMoreButton:(UIButton *)button
{
    SHGMarketSecondCategoryViewController *controller = [[SHGMarketSecondCategoryViewController alloc] init];
    [controller getArr:self.scrollView.categoryArray];
    controller.secondCategoryDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark ------SHGMarketTableViewDelegate
- (void)clickPrasiseButton:(SHGMarketObject *)object
{
    [[SHGMarketSegmentViewController sharedSegmentController] addOrDeletePraise:object block:^(BOOL success) {

    }];
}

- (void)clickCommentButton:(SHGMarketObject *)object
{
    SHGMarketDetailViewController *controller = [[SHGMarketDetailViewController alloc] init];
    controller.object = object;
    controller.delegate = [SHGMarketSegmentViewController sharedSegmentController];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickEditButton:(SHGMarketObject *)object
{
    SHGMarketSendViewController *controller = [[SHGMarketSendViewController alloc] init];
    controller.object = object;
    controller.delegate = [SHGMarketSegmentViewController sharedSegmentController];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)tapUserHeaderImageView:(NSString *)uid
{
    __weak typeof(self) weakSelf = self;
    SHGPersonalViewController * vc = [[SHGPersonalViewController alloc]init ];
    vc.userId = uid;
    [weakSelf.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
