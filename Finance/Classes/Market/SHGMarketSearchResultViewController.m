//
//  SHGMarketSearchResultViewController.m
//  Finance
//
//  Created by changxicao on 16/2/16.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMarketSearchResultViewController.h"
#import "SHGMarketManager.h"
#import "SHGMarketTableViewCell.h"
#import "SHGMarketSegmentViewController.h"

@interface SHGMarketSearchResultViewController ()<UITableViewDataSource, UITableViewDelegate, SHGMarketTableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) SHGMarketSearchType searchType;

@end

@implementation SHGMarketSearchResultViewController

- (instancetype)initWithType:(SHGMarketSearchType)type
{
    self = [super init];
    if (self) {
        self.searchType = type;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"搜索结果";
    
    [self initView];
    [self addAutoLayout];

    if (self.searchType == SHGMarketSearchTypeNormal) {
        [self searchNormalMarketList:@"first" marketId:@"-1"];
    } else{

    }
}

- (void)initView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
}

- (void)addAutoLayout
{
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f));
}

- (void)refreshFooter
{
    if (self.dataArr.count > 0) {
        if (self.searchType == SHGMarketSearchTypeNormal) {
            [self searchNormalMarketList:@"load" marketId:[self minMarketID]];
        } else{

        }

    } else{
        if (self.searchType == SHGMarketSearchTypeNormal) {
            [self searchNormalMarketList:@"first" marketId:@"-1"];
        } else{
            
        }
    }
}

- (NSString *)minMarketID
{
    NSString *marketID = @"";
    for (SHGMarketObject *object in self.dataArr) {
        if ([object.marketId compare:marketID options:NSNumericSearch] == NSOrderedAscending || [marketID isEqualToString:@""]) {
            marketID = object.marketId;
        }
    }
    return marketID;
}

- (void)searchNormalMarketList:(NSString *)target marketId:(NSString *)marketId
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.param];
    [dictionary setObject:target forKey:@"target"];
    [dictionary setObject:marketId forKey:@"marketId"];

    [SHGMarketManager searchMarketList:dictionary block:^(NSArray *array) {
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

#pragma mark ------tableview 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGMarketObject *object = [self.dataArr objectAtIndex:indexPath.row];
    CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[SHGMarketTableViewCell class] contentViewWidth:SCREENWIDTH];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"SHGMarketTableViewCell";
    SHGMarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGMarketTableViewCell" owner:self options:nil] lastObject];
        cell.delegate = self;
    }
    cell.object = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark ------ tableViewCellDelegate

- (void)clickCollectButton:(SHGMarketObject *)object state:(void (^)(BOOL))block
{
    [[SHGMarketSegmentViewController sharedSegmentController] addOrDeleteCollect:object state:^(BOOL state) {
        block(state);
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
