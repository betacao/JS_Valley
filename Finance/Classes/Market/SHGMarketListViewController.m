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
#import "SHGMomentCityViewController.h"
#import "SHGMarketNoticeTableViewCell.h"

@interface SHGMarketListViewController ()<UITabBarDelegate, UITableViewDataSource, SHGCategoryScrollViewDelegate,SHGMarketSecondCategoryViewControllerDelegate, SHGMarketTableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) SHGCategoryScrollView *scrollView;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;

@property (strong, nonatomic) SHGMarketNoticeTableViewCell *noticeCell;
@property (strong, nonatomic) SHGMarketNoticeObject *otherObject;

@property (strong, nonatomic) NSMutableArray *currentArray;
@property (strong, nonatomic) NSString *tipUrl;
@property (strong, nonatomic) NSString *position;
@property (strong, nonatomic) NSArray *selectedArray;

@property (assign, nonatomic) CGFloat noticeHeight;
@end

@implementation SHGMarketListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];
    [self loadData];
}

- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [[SHGMarketManager shareManager] userTotalArray:^(NSArray *array) {
        weakSelf.scrollView.categoryArray = [NSMutableArray arrayWithArray:array];
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
    [self loadData];
}

- (void)scrollToCategory:(SHGMarketFirstCategoryObject *)object
{
    NSInteger index = [self.scrollView.categoryArray indexOfObject:object];
    [self.scrollView moveToIndex:index];
}

- (void)loadMarketList:(NSString *)target firstId:(NSString *)firstId second:(NSString *)secondId marketId:(NSString *)marketId modifyTime:(NSString *)modifyTime
{
    __weak typeof(self) weakSelf = self;
    NSString *area = [SHGMarketManager shareManager].cityName;

    NSString *redirect = [self.position isEqualToString:@"0"] ? @"1" : @"0";

    NSDictionary *param = @{@"marketId":marketId ,@"uid":UID ,@"type":@"all" ,@"target":target ,@"pageSize":@"10" ,@"firstCatalog":firstId ,@"secondCatalog":secondId, @"modifyTime":modifyTime, @"city":area, @"redirect":redirect};

    [SHGMarketManager loadTotalMarketList:param block:^(NSArray *dataArray, NSString *position, NSString *total, NSString *tipUrl) {

        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        if ([target isEqualToString:@"first"]) {
            [weakSelf.currentArray removeAllObjects];
            [weakSelf.currentArray addObjectsFromArray:dataArray];
        } else if([target isEqualToString:@"refresh"]){
            for (NSInteger i = dataArray.count - 1; i >= 0; i--){
                SHGMarketObject *obj = [dataArray objectAtIndex:i];
                [weakSelf.currentArray insertUniqueObject:obj atIndex:0];
            }
        } else if([target isEqualToString:@"load"]){
            [weakSelf.currentArray addObjectsFromArray:dataArray];
        }
        weakSelf.position = position;
        weakSelf.tipUrl = tipUrl;

        [weakSelf.tableView reloadData];
    }];
}


- (SHGCategoryScrollView *)scrollView
{
    if (!_scrollView) {
        UIImage *image = [UIImage imageNamed:@"more_CategoryButton"];
        _scrollView = [[SHGCategoryScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH - image.size.width, kCategoryScrollViewHeight)];
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
        __weak typeof(self) weakSelf = self;
        _emptyView.block = ^(NSDictionary *dictionary){
            SHGMarketSecondCategoryViewController *controller = [[SHGMarketSecondCategoryViewController alloc] init];
            controller.delegate = weakSelf;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        };
    }
    return _emptyView;
}

- (SHGMarketNoticeTableViewCell *)noticeCell
{
    if (!_noticeCell) {
        _noticeCell = [[SHGMarketNoticeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHGMarketNoticeTableViewCell"];
        _noticeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _noticeCell.controller = self;
    }
    return _noticeCell;
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
    NSString *marketID = @"-1";
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

- (SHGMarketNoticeObject *)otherObject
{
    if (!_otherObject) {
        _otherObject = [[SHGMarketNoticeObject alloc] init];
    }
    _otherObject.tipUrl = self.tipUrl;
    if ([_position isEqualToString:@"0"]) {
        _otherObject.type = SHGMarketNoticeTypePositionTop;
    } else if ([_position integerValue] > 0){
        _otherObject.type = SHGMarketNoticeTypePositionAny;
    }
    return _otherObject;
}

- (void)setPosition:(NSString *)position
{
    _position = position;
    if ([self.currentArray indexOfObject:self.otherObject] != NSNotFound) {
        [self.currentArray removeObject:self.otherObject];
    }
    if (![position isEqualToString:@"-1"]){
        [self.currentArray insertUniqueObject:self.otherObject atIndex:[position integerValue]];
    }
}

#pragma mark ------tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.currentArray.count;
    return count > 0 ? count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentArray.count > 0) {
        SHGMarketObject *object = [self.currentArray objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[SHGMarketNoticeObject class]]) {
            return self.noticeHeight;
        } else{
            CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[SHGMarketTableViewCell class] contentViewWidth:SCREENWIDTH];
            return height;
        }
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
    if (self.currentArray.count == 0) {
        self.emptyView.type = SHGEmptyDateTypeNormal;
        return self.emptyCell;
    }
    SHGMarketObject *object = [self.currentArray objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[SHGMarketNoticeObject class]]) {

        self.noticeCell.object = (SHGMarketNoticeObject *)object;
        return self.noticeCell;

    } else{
        NSString *identifier = @"SHGMarketTableViewCell";
        SHGMarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGMarketTableViewCell" owner:self options:nil] lastObject];
            cell.delegate = self;
        }

        cell.object = [self.currentArray objectAtIndex:indexPath.row];
        [cell loadNewUiFortype:SHGMarketTableViewCellTypeAll];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGMarketObject *object = [self.currentArray objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[SHGMarketNoticeObject class]]) {
        SHGMomentCityViewController *controller = [[SHGMomentCityViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else{
        SHGMarketDetailViewController *controller = [[SHGMarketDetailViewController alloc]init];
        controller.object = object;
        controller.delegate = [SHGMarketSegmentViewController sharedSegmentController];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.headerView) {
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, CGRectGetHeight(self.scrollView.frame))];
        self.headerView.clipsToBounds = YES;
        [self.headerView addSubview:self.scrollView];

        UIImage *addImage = [UIImage imageNamed:@"more_CategoryButton"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:addImage forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(modifyUserSelectedTags:) forControlEvents:UIControlEventTouchUpInside];
        button.center = self.scrollView.center;

        CGRect frame = button.frame;
        frame.origin.x = CGRectGetMaxX(self.scrollView.frame);
        button.frame = frame;
        [self.headerView addSubview:button];

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, kCategoryScrollViewHeight, SCREENWIDTH, 0.5f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"d9dadb"];
        [self.headerView addSubview:lineView];
    }
    return self.headerView;
}

- (void)modifyUserSelectedTags:(UIButton *)button
{
    SHGMarketSecondCategoryViewController *controller = [[SHGMarketSecondCategoryViewController alloc] init];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clearAndReloadData
{
    if (self.dataArr.count > 0) {

        [self.dataArr enumerateObjectsUsingBlock:^(NSMutableArray *array, NSUInteger idx, BOOL * _Nonnull stop) {
            [array removeAllObjects];
        }];
        NSMutableArray *subArray = [self.dataArr objectAtIndex:[self.scrollView currentIndex]];
        if (!subArray || subArray.count == 0) {
            self.currentArray = subArray;
            [self loadMarketList:@"first" firstId:[self.scrollView marketFirstId] second:[self.scrollView marketSecondId] marketId:@"-1" modifyTime:@""];
        }
    }
}

- (void)reloadDataWithHeight:(CGFloat)height
{
    self.noticeHeight = height;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
#pragma mark -----二级分类返回代理
- (void)didUploadUserCategoryTags:(NSArray *)array
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *objectArray = [[SHGMarketManager shareManager] searchObjectWithCatalogIds:array];
    [[SHGMarketManager shareManager] modifyUserTotalArray:objectArray];

    [[SHGMarketManager shareManager] userSelectedArray:^(NSArray *array) {
        weakSelf.selectedArray = [NSArray arrayWithArray:array];
    }];

    [[SHGMarketManager shareManager] userTotalArray:^(NSArray *totalArray) {
        weakSelf.scrollView.categoryArray = [NSMutableArray arrayWithArray:totalArray];

        [weakSelf.dataArr removeObjectsInRange:NSMakeRange(1, weakSelf.selectedArray.count)];
        
        for (NSInteger i = 0; i < array.count; i++) {
            NSMutableArray *subArray = [NSMutableArray array];
            [weakSelf.dataArr insertObject:subArray atIndex:i+1];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [weakSelf.scrollView moveToIndex:1];
        });
    }];


    [[SHGMarketManager shareManager] modifyUserSelectedArray:array];

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

#pragma mark ------SHGMarketTableViewCellDelegate
- (void)clickPrasiseButton:(SHGMarketObject *)object
{
    [[SHGMarketSegmentViewController sharedSegmentController] addOrDeletePraise:object block:^(BOOL success) {

    }];
}

- (void)clickCollectButton:(SHGMarketObject *)object state:(void (^)(BOOL))block
{
    [[SHGMarketSegmentViewController sharedSegmentController] addOrDeleteCollect:object state:^(BOOL state) {
        block(state);
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
