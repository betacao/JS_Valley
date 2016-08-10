//
//  SHGMyComplainViewController.m
//  Finance
//
//  Created by weiqiankun on 16/8/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMyComplainViewController.h"
#import "SHGMyComplainTableViewCell.h"
#import "SHGMyComplianObject.h"
#import "SHGEmptyDataView.h"
#import "SHGMyComplainDetailViewController.h"

@interface SHGMyComplainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;

@end

@implementation SHGMyComplainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的投诉";
    self.tableView.backgroundColor = Color(@"f7f7f7");
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    WEAK(self, weakSelf);
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"complain/business/myComplain"] parameters:@{@"uid":UID,@"pageSize":@"10",@"target":@"first"} success:^(MOCHTTPResponse *response) {
        NSArray *array = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[response.dataDictionary objectForKey:@"list"] class:[SHGMyComplianObject class]];
        [weakSelf.dataArray addObjectsFromArray:array];
        [weakSelf.tableView reloadData];
    } failed:^(MOCHTTPResponse *response) {
         
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark --tableView--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count > 0) {
        return self.dataArray.count;
    } else{
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        SHGMyComplianObject *object = [self.dataArray objectAtIndex:indexPath.row];
        CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[SHGMyComplainTableViewCell class] contentViewWidth:SCREENWIDTH];
        return height;
    } else{
        return CGRectGetHeight(self.view.frame);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        NSString *cellIdentifier =@"SHGMyComplainTableViewCell";
        SHGMyComplainTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGMyComplainTableViewCell" owner:self options:nil] lastObject];
        }
        if (indexPath.row == 0) {
            cell.firstTopLine = YES;
        } else{
            cell.firstTopLine = NO;
        }
        if (indexPath.row == self.dataArray.count - 1) {
            cell.lastBottomLine = YES;
        } else{
            cell.lastBottomLine = NO;
        }
        cell.object = [self.dataArray objectAtIndex:indexPath.row];
        return cell;
    } else{
        self.emptyView.type = SHGEmptyDateNormal;
        return self.emptyCell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGMyComplianObject *object = [self.dataArray objectAtIndex:indexPath.row];
    SHGMyComplainDetailViewController *viewController = [[SHGMyComplainDetailViewController alloc] init];
    viewController.complainId = object.complainid;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



@end
