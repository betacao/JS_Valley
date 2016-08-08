//
//  SHGMyFollowViewController.m
//  Finance
//
//  Created by weiqiankun on 16/5/30.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMyFollowViewController.h"
#import "EMSearchBar.h"
#import "SHGPersonalViewController.h"
#import "SHGEmptyDataView.h"
#import "RealtimeSearchUtil.h"
#import "SHGFollowAndFansTableViewCell.h"
#import "SHGFollowAndFansObject.h"
@interface SHGMyFollowViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *currentArray;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;

@end

@implementation SHGMyFollowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的关注";
    [Hud showWait];
    [self initView];
    [self addSdLayout];
    [self requestFollowListWithTarget:@"first" time:@"-1"];
}

- (void)addSdLayout
{
    self.searchBar.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f);
    
    self.tableView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.searchBar, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);
    
    self.emptyView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.searchBar, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);
}

- (void)initView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view insertSubview:self.searchBar belowSubview:self.tableView];
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
    self.tableView.mj_footer.automaticallyHidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [SHGGlobleOperation registerAttationClass:[self class] method:@selector(loadAttationState:attationState:)];
}

- (NSMutableArray *)currentArray{
    if (!_currentArray) {
        _currentArray = [[NSMutableArray alloc] init];
    }
    return _currentArray;
}

- (EMSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入姓名/公司名";
    }
    return _searchBar;
}

- (SHGEmptyDataView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SHGEmptyDataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
        _emptyView.hidden = YES;
        [self.view addSubview:_emptyView];
    }
    return _emptyView;
}

-(void)refreshFooter
{
    if (self.dataArr.count > 0){
        SHGFollowAndFansObject *obj = [self.dataArr lastObject];
        [self requestFollowListWithTarget:@"load" time:obj.updateTime];
    } else{
        [self requestFollowListWithTarget:@"load" time:@"-1"];
    }
}


- (void)loadAttationState:(NSString *)targetUserID attationState:(BOOL)attationState
{
    [self.dataArr enumerateObjectsUsingBlock:^(SHGFollowAndFansObject *object, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([object.uid isEqualToString:targetUserID]) {
            [self.dataArr removeObject:object];
            
        }
    }];
    [self.tableView reloadData];
}

- (void)requestFollowListWithTarget:(NSString *)target time:(NSString *)time
{
    NSDictionary *param = @{@"uid":UID, @"target":target, @"time":time, @"num":@"100"};
    WEAK(self, weakSelf);
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"attention",@"myattentionlist"] class:[SHGFollowAndFansObject class] parameters:param success:^(MOCHTTPResponse *response) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:response.dataArray];
        [array enumerateObjectsUsingBlock:^(SHGFollowAndFansObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.uid isEqualToString:UID]) {
                [array removeObject:obj];
            }
        }];
        if ([target isEqualToString:@"first"]) {
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:array];
            [weakSelf.currentArray removeAllObjects];
            [weakSelf.currentArray addObjectsFromArray:array];
        }
        if ([target isEqualToString:@"load"]) {
            [weakSelf.dataArr addObjectsFromArray:array];
            [weakSelf.currentArray addObjectsFromArray:array];
        }
        if (array.count == 0) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf.tableView reloadData];
        [Hud hideHud];
    } failed:^(MOCHTTPResponse *response) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [Hud hideHud];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count == 0) {
        self.emptyView.hidden = NO;
    } else{
        self.emptyView.hidden = YES;
    }
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(59.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"SHGFollowAndFansTableViewCell";
    SHGFollowAndFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGFollowAndFansTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    SHGFollowAndFansObject *obj = [self.dataArr objectAtIndex:indexPath.row];
    cell.object = obj;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGFollowAndFansObject *obj = self.dataArr[indexPath.row];
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
    controller.userId = obj.uid;
    [self.navigationController pushViewController:controller animated:YES];

}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    WEAK(self, weakSelf);
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:weakSelf.currentArray searchText:(NSString *)searchText collationStringSelector:@selector(name) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.dataArr removeAllObjects];
                [weakSelf.dataArr addObjectsFromArray:results];
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
