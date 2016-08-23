//
//  SHGBusinessCollectionListViewController.m
//  Finance
//
//  Created by weiqiankun on 16/4/13.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessCollectionListViewController.h"
#import "SHGEmptyDataView.h"
#import "SHGBusinessManager.h"
#import "SHGBusinessObject.h"
#import "SHGBusinessTableViewCell.h"
#import "SHGBusinessNewDetailViewController.h"
#import "SHGNoticeView.h"
#import "SHGBusinessMyTableViewCell.h"
@interface SHGBusinessCollectionListViewController ()<UITabBarDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@property (strong, nonatomic) SHGNoticeView *noticeView;
@end

@implementation SHGBusinessCollectionListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"业务收藏";
    [Hud showWait];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"efeeef"];
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];
    [self requestBusinessCollectWithTarget:@"first" ];
}

- (NSMutableArray *)currentDataArray
{
    return self.dataArr;
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)refreshData
{
    [self requestBusinessCollectWithTarget:@"first" ];
}
- (void)requestBusinessCollectWithTarget:(NSString *)target
{
    if ([target isEqualToString:@"first"])
    {
        [self.tableView.mj_footer resetNoMoreData];
        
    }
    
    NSString *businessId = [target isEqualToString:@"refresh"] ? [self maxBusinessID] : [self minBusinessID];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSDictionary *param = @{@"uid":uid, @"target":target, @"businessId":businessId, @"pageSize":@"10", @"version":[SHGGloble sharedGloble].currentVersion};
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@/%@/%@",rBaseAddressForHttp,@"business",@"collection",@"myCollectBusiness"] class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSDictionary *dictionary = response.dataDictionary;
        NSArray * dataArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[dictionary objectForKey:@"businesslist"] class:[SHGBusinessObject class]];
        NSLog(@"%@",dataArray);
        if ([target isEqualToString:@"first"]) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:dataArray];
             [self.noticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新业务",(long)dataArray.count]];
            [self.tableView reloadData];
        }
        if ([target isEqualToString:@"refresh"]) {
            
            if (dataArray.count > 0) {
                for (NSInteger i = dataArray.count-1; i >= 0; i --) {
                    SHGBusinessObject *obj = dataArray[i];
                    [self.dataArr insertObject:obj atIndex:0];
                    [self.noticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新业务",(long)dataArray.count]];
                }
                [self.tableView reloadData];
            } else{
                [self.noticeView showWithText:@"暂无新业务，休息一会儿"];
            }
            
        }
        if ([target isEqualToString:@"load"]) {
            [self.dataArr addObjectsFromArray:dataArray];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        [self reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Hud hideHud];
        
    } failed:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.errorMessage);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Hud hideHud];
        
    }];
    
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

- (SHGNoticeView *)noticeView
{
    if (!_noticeView) {
        _noticeView = [[SHGNoticeView alloc] initWithFrame:CGRectZero type:SHGNoticeTypeNewMessage];
        _noticeView.superView = self.view;
    }
    return _noticeView;
}

- (void)refreshHeader
{
    if (self.dataArr.count > 0) {
        [self requestBusinessCollectWithTarget:@"refresh" ];
    } else{
        [self requestBusinessCollectWithTarget:@"first" ];
    }
    
}

- (void)refreshFooter
{
    if (self.dataArr.count > 0) {
        [self requestBusinessCollectWithTarget:@"load" ];
        
    } else{
        [self requestBusinessCollectWithTarget:@"first" ];
    }
}

- (NSString *)maxBusinessID
{
    NSString *businessID = @"";
    for (SHGBusinessObject *object in self.dataArr) {
        if ([object.businessID compare:businessID options:NSNumericSearch] == NSOrderedDescending && ![object.businessID isEqualToString:[NSString stringWithFormat:@"%ld",NSIntegerMax]]) {
            businessID = object.businessID;
        }
    }
    return businessID;
}

- (NSString *)minBusinessID
{
    NSString *businessID = [NSString stringWithFormat:@"%ld",NSIntegerMax];
    for (SHGBusinessObject *object in self.dataArr) {
        NSString *objectMarketId = object.businessID;
        if ([objectMarketId compare:businessID options:NSNumericSearch] == NSOrderedAscending) {
            businessID = object.businessID;
        }
    }
    return businessID;
}

- (void)changeBusinessCollection
{
    [self requestBusinessCollectWithTarget:@"first" ];
}
#pragma mark ------tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count > 0) {
        NSInteger count = self.dataArr.count;
        return count;
    } else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        SHGBusinessObject *object = [self.dataArr objectAtIndex:indexPath.row];
        NSArray *array = @[object,@"other"];
        CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:array keyPath:@"array" cellClass:[SHGBusinessMyTableViewCell class] contentViewWidth:SCREENWIDTH];
        return height;
        
    } else{
        return CGRectGetHeight(self.view.frame);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count == 0) {
        return self.emptyCell;
    } else {
        SHGBusinessMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHGBusinessMyTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGBusinessMyTableViewCell" owner:self options:nil] lastObject];
        }
        cell.array = @[[self.dataArr objectAtIndex:indexPath.row],@"other"];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        SHGBusinessObject *object = [self.dataArr objectAtIndex:indexPath.row];
        SHGBusinessNewDetailViewController *controller = [[SHGBusinessNewDetailViewController alloc] init];
        object.auditState = @"0";
        controller.object = object;
        controller.collectionController = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



@end
