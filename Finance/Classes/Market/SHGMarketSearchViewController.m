//
//  SHGMarketSearchViewController.m
//  Finance
//
//  Created by changxicao on 15/12/28.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketSearchViewController.h"
#import "SHGMarketObject.h"
#import "RealtimeSearchUtil.h"
#import "SHGMarketManager.h"
#import "SHGEmptyDataView.h"
#import "SHGMarketSearchTableViewCell.h"
#import "SHGMarketDetailViewController.h"
#import "SHGMarketSegmentViewController.h"

@interface SHGMarketSearchViewController ()<UISearchBarDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *resultArray;
@property (strong, nonatomic) UIButton *backButton;
@property (assign, nonatomic) BOOL searchLocal;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;

@end

@implementation SHGMarketSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, 44.0f)];
    self.searchBar.delegate = self;
    self.searchBar.layer.masksToBounds = YES;
    self.searchBar.layer.cornerRadius = 3.0f;
    self.searchBar.showsCancelButton = YES;
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.searchBarStyle = UISearchBarStyleDefault;
    self.searchBar.placeholder = @"请输入业务名称/类型/地区关键字";
    [self.searchBar setImage:[UIImage imageNamed:@"market_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    UIView *view = [self.searchBar.subviews firstObject];
    for (id object in view.subviews) {
        if ([object isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            UITextField *textField = (UITextField *)object;
            textField.textColor = [UIColor whiteColor];
            [textField setValue:[UIColor colorWithHexString:@"F67070"] forKeyPath:@"_placeholderLabel.textColor"];
            textField.enablesReturnKeyAutomatically = NO;
        } else if ([object isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
        } else{
            UIButton *button = (UIButton *)object;
            self.backButton = button;
            [button setTitle:@"取消" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            button.enabled = YES;
        }
    }
    [self.searchBar setSearchFieldBackgroundImage:[[UIImage imageNamed:@"market_searchBorder"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self prepareListArray];

    self.searchLocal = YES;
}

- (void)prepareListArray
{
    [self.dataArr enumerateObjectsUsingBlock:^(NSArray *object, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.listArray appendUniqueObjectsFromArray:object];
    }];
    [self.listArray enumerateObjectsUsingBlock:^(SHGMarketObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tipUrl.length == 0) {
            [self.resultArray addObject:obj];
        }
    }];
}

- (NSMutableArray *)resultArray
{
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
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

- (void)refreshFooter
{
    if (self.resultArray.count > 0) {
        [self searchMarketList:@"load" searchText:self.searchBar.text marketId:[self minMarketID]];
    } else{
        [self searchMarketList:@"load" searchText:self.searchBar.text marketId:@"-1"];
    }
}

- (NSString *)minMarketID
{
    return ((SHGMarketObject *)[self.resultArray lastObject]).marketId;
}

#pragma mark ------搜索的代理
//退出
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [self.navigationController popViewControllerAnimated:YES];
}

//本地搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    if (self.searchLocal || searchText.length == 0) {
        self.tableView.footer = nil;
        self.searchLocal = YES;
        [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.listArray searchText:searchText collationStringSelector:@selector(marketName)resultBlock:^(NSArray *results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.resultArray removeAllObjects];
                [weakSelf.resultArray addObjectsFromArray:results];
                [weakSelf.tableView reloadData];
            });
        }];
    }
}

//网络搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    self.backButton.enabled = YES;
    if (searchBar.text.length > 0) {
        self.searchLocal = NO;
        [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
        [self searchMarketList:@"first" searchText:searchBar.text marketId:@"-1"];
    }
}

- (void)searchMarketList:(NSString *)target searchText:(NSString *)searchText marketId:(NSString *)marketId
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"marketId":marketId ,@"uid":uid ,@"type":@"searcher" ,@"target":target ,@"pageSize":@"10", @"marketName":searchText};
    [SHGMarketManager searchMarketList:param block:^(NSArray *array) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        if ([target isEqualToString:@"first"]) {
            [weakSelf.resultArray removeAllObjects];
            [weakSelf.resultArray addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
        } else if([target isEqualToString:@"refresh"]){
            [weakSelf.resultArray addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
        } else if([target isEqualToString:@"load"]){
            [weakSelf.resultArray addObjectsFromArray:array];
            if (array.count < 10) {
                [weakSelf.tableView.footer endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark ------tableview的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.resultArray.count > 0){
        return self.resultArray.count;
    } else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.resultArray.count > 0) {
        NSString *identifier = @"marketSearchCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGMarketSearchTableViewCell" owner:self options:nil]lastObject];
        }
        id object = [self.resultArray objectAtIndex:indexPath.row];
        SHGMarketObject *obj = (SHGMarketObject *)object;
        cell.textLabel.text = obj.marketName;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"3A3A3A"];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        return cell;
    } else{
        return self.emptyCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.resultArray.count > 0) {
        SHGMarketDetailViewController *controller = [[SHGMarketDetailViewController alloc] init];
        controller.delegate = [SHGMarketSegmentViewController sharedSegmentController];
        controller.object = [self.resultArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.resultArray.count > 0) {
        return 44.0f;
    } else{
        return CGRectGetHeight(self.view.frame);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchBar resignFirstResponder];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
