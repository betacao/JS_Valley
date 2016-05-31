//
//  SHGMyFansViewController.m
//  Finance
//
//  Created by weiqiankun on 16/5/30.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMyFansViewController.h"
#import "BasePeopleTableViewCell.h"
#import "BasePeopleObject.h"
#import "EMSearchBar.h"
#import "SHGPersonalViewController.h"
#import "SHGEmptyDataView.h"
#import "RealtimeSearchUtil.h"

@interface SHGMyFansViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) EMSearchBar *searchBar;

@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@end

@implementation SHGMyFansViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的粉丝";
    
    [self initView];
    [self addSdLayout];
    
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
}

- (void)initView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataSource = [[NSMutableArray alloc] init];
    [self.view insertSubview:self.searchBar belowSubview:self.tableView];
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self requestFansListWithTarget:@"first" time:@"-1"];
    [SHGGlobleOperation registerAttationClass:[self class] method:@selector(loadAttationState:attationState:)];
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
    if (self.dataSource.count > 0){
        BasePeopleObject *obj = self.dataSource[0];
        [self requestFansListWithTarget:@"refresh" time:obj.updateTime];
    }
}

-(void)refreshFooter
{
    if (self.dataSource.count > 0){
        BasePeopleObject *obj = [self.dataSource lastObject];
        [self requestFansListWithTarget:@"load" time:obj.updateTime];
    }
}


- (void)loadAttationState:(NSString *)targetUserID attationState:(BOOL)attationState
{
    [self.dataSource enumerateObjectsUsingBlock:^(BasePeopleObject *object, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([object.uid isEqualToString:targetUserID]) {
            if (object.followRelation == 0) {
                object.followRelation = 2;
            } else {
                object.followRelation = 0;
            }
            
        }
    }];
    [self.tableView reloadData];
}

-(void)requestFansListWithTarget:(NSString *)target time:(NSString *)time
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSDictionary *param = @{@"uid":uid, @"target":target, @"time":time, @"num":@"100"};
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"attention",@"myfanslist"] class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSLog(@"=data = %@",response.dataArray);
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in response.dataArray) {
            BasePeopleObject *obj = [[BasePeopleObject alloc] init];
            obj.name = [dic valueForKey:@"nickname"];
            obj.headImageUrl = [dic valueForKey:@"head_img"];
            obj.uid = [dic valueForKey:@"uid"];
            obj.updateTime = [dic valueForKey:@"time"];
            obj.followRelation = [[dic valueForKey:@"state"] integerValue];
            obj.userstatus = [dic objectForKey:@"userstatus"];
            if (![obj.uid isEqualToString:uid]) {
                [array addObject:obj];
                
            }
        }
        
        if ([target isEqualToString:@"first"]) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:array];
            
        }
        if ([target isEqualToString:@"refresh"]) {
            if (response.dataArray.count > 0) {
                for (NSInteger i = response.dataArray.count-1; i >= 0; i --) {
                    BasePeopleObject *obj = array[i];
                    [self.dataArr insertObject:obj atIndex:0];
                }
                
            } else{
                [self.tableView.mj_header endRefreshing];
            }
            
        }
        if ([target isEqualToString:@"load"]) {
            [self.dataSource addObjectsFromArray:array];
            if (self.dataSource > 0) {
                
            } else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.tableView.mj_footer endRefreshing];
        [Hud hideHud];
        [self.tableView reloadData];
    } failed:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.errorMessage);
        [self.tableView.mj_footer endRefreshing];
        [Hud hideHud];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count == 0 ? 1 : self.dataSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count > 0) {
        return MarginFactor(59.0f);
    }
    return CGRectGetHeight(tableView.frame);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count == 0) {
        return self.emptyCell;
    }
    NSString *identifier = @"BasePeopleTableViewCell";
    BasePeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BasePeopleTableViewCell" owner:self options:nil] lastObject];
        
        cell.backgroundColor = [UIColor whiteColor];
    }
    BasePeopleObject *obj = self.dataSource[indexPath.row];
    cell.object = obj;
   	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count > 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        BasePeopleObject *obj = self.dataSource[indexPath.row];
        SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
        controller.userId = obj.uid;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataSource searchText:(NSString *)searchText collationStringSelector:@selector(name) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:results];
                [self.tableView reloadData];
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
    [self requestFansListWithTarget:@"first" time:@"-1"];
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
