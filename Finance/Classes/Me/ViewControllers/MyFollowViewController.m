//
//  MyFollowViewController.m
//  Finance
//
//  Created by Okay Hoo on 15/4/27.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MyFollowViewController.h"
#import "BasePeopleTableViewCell.h"
#import "BasePeopleObject.h"
#import "EMSearchDisplayController.h"
#import "EMSearchBar.h"
#import "RealtimeSearchUtil.h"
#import "SHGPersonalViewController.h"

@interface MyFollowViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate,BasePeopleTableViewCellDelegate>
@property (nonatomic, strong) IBOutlet	UITableView *tableView;
//关注
@property (nonatomic, strong) NSMutableArray *followArray;
//粉丝
@property (nonatomic, strong) NSMutableArray *fansArray;
//互相关注
@property (nonatomic, strong) NSMutableArray *followAndFansArray;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) EMSearchDisplayController *searchController;
@property (strong, nonatomic) EMSearchBar *searchBar;

@property (nonatomic, assign) BOOL hasMoreData;
@property (nonatomic, assign) BOOL searchBarIsEdite;
@end

@implementation MyFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Hud showWait];
	[self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];
    self.dataSource = [[NSMutableArray alloc] init];
    [self requestData];
	
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.tableFooterView = [[UIView alloc] init];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attentionChanged:) name:NOTIFI_COLLECT_COLLECT_CLIC object:nil];
	[self searchController];
}

- (void)requestData
{
    if (self.relationShip == 1) {
        [self requestFollowListWithTarget:@"first" time:@"-1"];
        self.title = @"我的关注";
    } else if (self.relationShip == 2){
        [self requestFansListWithTarget:@"first" time:@"-1"];
        self.title = @"我的粉丝";
    }
}

- (void)detailAttentionWithRid:(NSString *)rid attention:(NSString *)atten
{
    [self requestData];
}

-(void)attentionChanged:(NSNotification *)noti
{
    CircleListObj *obj = noti.object;
    [self detailAttentionWithRid:obj.userid attention:obj.isattention];
}

-(void)refreshHeader
{
    if (self.dataSource.count > 0){
        [Hud showWait];
        BasePeopleObject *obj = self.dataSource[0];
        if (self.relationShip == 1) {
            [self requestFollowListWithTarget:@"refresh" time:obj.updateTime];
        }else if (self.relationShip == 2){
            [self requestFansListWithTarget:@"refresh" time:obj.updateTime];
        }
    }
}

-(void)refreshFooter
{
	if (!self.hasMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
		return;
	}
	if (self.dataSource.count > 0){
        [Hud showWait];

		BasePeopleObject *obj = [self.dataSource lastObject];
		if (self.relationShip == 1) {
			[self requestFollowListWithTarget:@"load" time:obj.updateTime];
		}else if (self.relationShip == 2){
			[self requestFansListWithTarget:@"load" time:obj.updateTime];
		}
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)requestFollowListWithTarget:(NSString *)target time:(NSString *)time
{
	NSDictionary *param = @{@"uid":UID, @"target":target, @"time":time, @"num":@"100"};
	[MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"attention",@"myattentionlist"] class:[BasePeopleObject class] parameters:param success:^(MOCHTTPResponse *response) {

		NSLog(@"=data = %@",response.dataArray);
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
        if ([target isEqualToString:@"refresh"]) {
            if (response.dataArray.count > 0) {
                for (NSInteger i = array.count-1; i >= 0; i --) {
                    BasePeopleObject *obj = array[i];
                    [self.dataSource insertObject:obj atIndex:0];
                }
            }
        }
        if ([target isEqualToString:@"load"]) {
            if (array.count == 0) {
                self.hasMoreData = NO;
            }
            else
            {
                [self.dataSource addObjectsFromArray:array];
            }
        }

		[self.tableView.mj_header endRefreshing];
		[self.tableView.mj_footer endRefreshing];
        [Hud hideHud];
		[self.tableView reloadData];
	} failed:^(MOCHTTPResponse *response) {
		NSLog(@"%@",response.errorMessage);
        [Hud hideHud];
		[self.tableView.mj_header endRefreshing];
		[self.tableView.mj_footer endRefreshing];
		
	}];
}

-(void)requestFansListWithTarget:(NSString *)target time:(NSString *)time
{
	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
	NSDictionary *param = @{@"uid":uid, @"target":target,
							@"time":time,
							@"num":@"100"};
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
                
            }
            
        }
        if ([target isEqualToString:@"load"]) {
            if (array.count == 0) {
                self.hasMoreData = NO;
            }
            
            [self.dataSource addObjectsFromArray:array];
            
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Hud hideHud];
		[self.tableView reloadData];
	} failed:^(MOCHTTPResponse *response) {
		NSLog(@"%@",response.errorMessage);
		[self.tableView.mj_header endRefreshing];
		[self.tableView.mj_footer endRefreshing];
        [Hud hideHud];
	}];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return MarginFactor(55.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"BasePeopleTableViewCell";
    BasePeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BasePeopleTableViewCell" owner:self options:nil] lastObject];
        cell.delegate = self;
    }
    BasePeopleObject *obj = self.dataSource[indexPath.row];
    obj.followRelationHiden = NO;
    cell.object = obj;
   	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    BasePeopleObject *obj = self.dataSource[indexPath.row];
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
    controller.userId = obj.uid;
    [self.navigationController pushViewController:controller animated:YES];
}

- (EMSearchBar *)searchBar
{
	if (!_searchBar) {
		_searchBar = [[EMSearchBar alloc] init];
		_searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.cancelButtonTitleColor = Color(@"bebebe");
	}
	
	return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
	if (_searchController == nil) {
		_searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
		_searchController.delegate = self;
		_searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		
		__weak MyFollowViewController *weakSelf = self;
		[_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
			static NSString *CellIdentifier = @"BasePeopleTableViewCell";
			BasePeopleTableViewCell *cell = (BasePeopleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
			}
			
			BasePeopleObject *obj = weakSelf.searchController.resultsSource[indexPath.row];
            obj.followRelationHiden = NO;
            cell.object = obj;
            cell.delegate = weakSelf;
			return cell;

		}];
		
		[_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
			return 60;
		}];
		
		[_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            BasePeopleObject *obj = weakSelf.searchController.resultsSource[indexPath.row];
            SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
            controller.userId = obj.uid;
            [weakSelf.navigationController pushViewController:controller animated:YES];
		}];
	}
	
	return _searchController;
}

#pragma mark - UISearchBarDelegate


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBarIsEdite = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searchBarIsEdite = NO;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:YES animated:YES];
	
	return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataSource searchText:(NSString *)searchText collationStringSelector:@selector(name) resultBlock:^(NSArray *results) {
		if (results) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.searchController.resultsSource removeAllObjects];
				[self.searchController.resultsSource addObjectsFromArray:results];
				[self.searchController.searchResultsTableView reloadData];
			});
		}
	}];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
	return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	searchBar.text = @"";
	[[RealtimeSearchUtil currentUtil] realtimeSearchStop];
	[searchBar resignFirstResponder];
	[searchBar setShowsCancelButton:NO animated:YES];
}

- (void)followButtonClicked:(BasePeopleObject *)obj
{

	NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends"];
	NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],
							@"oid":obj.uid};

    if (obj.followRelation == 0) {
        [Hud showWait];
		[MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            obj.followRelation = [response.dataDictionary[@"state"] integerValue];
			[self.tableView reloadData];
            if (self.searchBarIsEdite) {
                [self.searchController.searchResultsTableView reloadData];
            }
			[Hud showMessageWithText:@"关注成功"];
            CircleListObj *robj = [[CircleListObj alloc] init];
            robj.userid = obj.uid;
            robj.isattention = @"Y";
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:robj];
            [Hud hideHud];
            		} failed:^(MOCHTTPResponse *response) {
			[Hud showMessageWithText:response.errorMessage];
            [Hud hideHud];
		}];

    }else if (obj.followRelation == 1){
        [Hud showWait];

		[[AFHTTPSessionManager manager] DELETE:url parameters:param success:^(NSURLSessionDataTask *operation, id responseObject) {
			NSString *code = [responseObject valueForKey:@"code"];
			if ([code isEqualToString:@"000"])
			{
				[self.dataSource removeObject:obj];
				[self.tableView reloadData];
                if (self.searchBarIsEdite) {
                    [self.searchController.searchResultsTableView reloadData];
                }
				[Hud showMessageWithText:@"取消关注成功"];
                CircleListObj *robj = [[CircleListObj alloc] init];
                robj.userid = obj.uid;
                robj.isattention = @"N";
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:robj];

                
			}else{
				[Hud showMessageWithText:[responseObject valueForKey:@"msg"]];
			}
            [Hud hideHud];

			
		} failure:^(NSURLSessionDataTask *operation, NSError *error) {
			[Hud showMessageWithText:error.domain];
            [Hud hideHud];
		}];

    }else if (obj.followRelation == 2){
        [Hud showWait];

		[[AFHTTPSessionManager manager] DELETE:url parameters:param success:^(NSURLSessionDataTask *operation, id responseObject) {
			NSString *code = [responseObject valueForKey:@"code"];
			if ([code isEqualToString:@"000"])
			{
				if (self.relationShip == 1) {
					obj.followRelation = 0;
				}else if (self.relationShip == 2){
					obj.followRelation = 0;
				}
				
				[self.tableView reloadData];
                if (self.searchBarIsEdite) {
                    [self.searchController.searchResultsTableView reloadData];
                }
                CircleListObj *robj = [[CircleListObj alloc] init];
                robj.userid = obj.uid;
                robj.isattention = @"N";
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:robj];
				[Hud showMessageWithText:@"取消关注成功"];
			}else{
				[Hud showMessageWithText:[responseObject valueForKey:@"msg"]];
			}
            [Hud hideHud];
		} failure:^(NSURLSessionDataTask *operation, NSError *error) {
			[Hud showMessageWithText:error.domain];
            [Hud hideHud];
		}];
	}

}
@end
