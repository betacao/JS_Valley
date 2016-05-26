//
//  SHGDiscoverySearchViewController.m
//  Finance
//
//  Created by changxicao on 16/5/25.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGDiscoverySearchViewController.h"
#import "SHGDiscoveryDisplayViewController.h"
#import "SHGDiscoveryManager.h"
#import "EMSearchBar.h"

@interface SHGDiscoverySearchViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *middleImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) NSString *searchText;

@end

@implementation SHGDiscoverySearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"人脉搜索";
    [self initView];
    [self addAutoLayout];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (void)initView
{
    [self.view addSubview:self.searchBar];
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
    self.tableView.mj_footer.automaticallyHidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.middleImageView.image = [UIImage imageNamed:@"discovery_search"];
    self.searchText = @"";
}

- (void)addAutoLayout
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

    self.middleImageView.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.searchBar, MarginFactor(65.0f))
    .widthIs(self.middleImageView.image.size.width)
    .heightIs(self.middleImageView.image.size.height);
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

- (void)refreshFooter
{
    [self loadDataWithTarget:@"load"];
}

- (NSString *)minUserID
{
    NSString *maxUserID = [NSString stringWithFormat:@"%ld",NSIntegerMax];
    NSString *uid = maxUserID;
    for (SHGDiscoveryPeopleObject *object in self.dataArr) {
        NSString *userID = object.userID;
        if ([userID compare:uid options:NSNumericSearch] == NSOrderedAscending) {
            uid = userID;
        }
    }
    return [uid isEqualToString:maxUserID] ? @"-1" : uid;
}

- (void)loadDataWithTarget:(NSString *)target
{
    NSDictionary *param = @{@"target":target, @"indexCondition":self.searchText, @"userId":[target isEqualToString:@"first"] ? @"-1" : [self minUserID], @"pageSize":@"10"};
    __weak typeof(self)weakSelf = self;
    [SHGDiscoveryManager searchDiscovery:param block:^(NSArray *dataArray) {
        if ([target isEqualToString:@"first"]) {
            [weakSelf.dataArr removeAllObjects];
        }
        [weakSelf.dataArr addObjectsFromArray:dataArray];

        if (dataArray.count < 10) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        if (weakSelf.dataArr.count > 0) {
            weakSelf.middleImageView.hidden = YES;
        } else {
            weakSelf.middleImageView.image = [UIImage imageNamed:@"discovery_search_none"];
            weakSelf.middleImageView.hidden = NO;
        }

        [weakSelf.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        SHGDiscoveryPeopleObject *object = [self.dataArr objectAtIndex:indexPath.row];
        CGFloat height = [tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[SHGDiscoveryDisplayCell class] contentViewWidth:SCREENWIDTH];
        return height;
    }
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGDiscoveryDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHGDiscoveryDisplayCell"];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGDiscoveryDisplayCell" owner:self options:nil] lastObject];
    }
    cell.object = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
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
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.searchText = searchBar.text;
    [self loadDataWithTarget:@"first"];
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
