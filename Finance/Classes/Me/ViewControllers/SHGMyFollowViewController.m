//
//  SHGMyFollowViewController.m
//  Finance
//
//  Created by weiqiankun on 16/5/30.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMyFollowViewController.h"
#import "BasePeopleTableViewCell.h"
#import "BasePeopleObject.h"
#import "EMSearchBar.h"
#import "SHGPersonalViewController.h"
#import "SHGEmptyDataView.h"
#import "RealtimeSearchUtil.h"
@interface SHGMyFollowViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) EMSearchBar *searchBar;

@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;

@end

@implementation SHGMyFollowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的关注";
    [Hud showWait];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    self.dataSource = [[NSMutableArray alloc] init];
    [self.view insertSubview:self.searchBar belowSubview:self.tableView];
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
    self.tableView.mj_footer.automaticallyHidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self requestFollowListWithTarget:@"first" time:@"-1"];
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

-(void)refreshFooter
{
    if (self.dataSource.count > 0){
    BasePeopleObject *obj = [self.dataSource lastObject];
    [self requestFollowListWithTarget:@"load" time:obj.updateTime];
    }
}


- (void)loadAttationState:(NSString *)targetUserID attationState:(BOOL)attationState
{
    [self.dataSource enumerateObjectsUsingBlock:^(BasePeopleObject *object, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([object.uid isEqualToString:targetUserID]) {
            [self.dataSource removeObject:object];
            
        }
    }];

    [self.tableView reloadData];
}

- (void)requestFollowListWithTarget:(NSString *)target time:(NSString *)time
{
    NSDictionary *param = @{@"uid":UID, @"target":target, @"time":time, @"num":@"100"};
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"attention",@"myattentionlist"] class:[BasePeopleObject class] parameters:param success:^(MOCHTTPResponse *response) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i<response.dataArray.count; i++) {
            NSDictionary *dic = response.dataArray[i];
            BasePeopleObject *obj = [[BasePeopleObject alloc] init];
            obj.name = [dic valueForKey:@"nickname"];
            obj.headImageUrl = [dic valueForKey:@"head_img"];
            obj.uid = [dic valueForKey:@"uid"];
            obj.updateTime = [dic valueForKey:@"time"];
            obj.followRelation = [[dic valueForKey:@"state"] integerValue];
            obj.userstatus = [dic objectForKey:@"userstatus"];
            if (![obj.uid isEqualToString:UID]) {
                [array addObject:obj];
            }
        }
        
        if ([target isEqualToString:@"first"]) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:array];
            
        }

        if ([target isEqualToString:@"load"]) {
            
            [self.dataSource addObjectsFromArray:array];
            
        }
        [self.tableView.mj_footer endRefreshing];
        [Hud hideHud];
        [self.tableView reloadData];
    } failed:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.errorMessage);
        [Hud hideHud];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    BasePeopleObject *obj = self.dataSource[indexPath.row];
    obj.followRelationHiden = NO;
    cell.object = obj;
   	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
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
    [self requestFollowListWithTarget:@"first" time:@"-1"];
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
