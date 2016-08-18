//
//  BaseTableViewController.m
//  Finance
//
//  Created by HuMin on 15/4/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SHGGifHeader.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableArray *)adArray
{
    if (!_adArray) {
        _adArray = [NSMutableArray array];
    }
    return _adArray;
}

- (void)addHeaderRefresh:(UITableView *)tableView headerRefesh:(BOOL)isHeaderFresh  andFooter:(BOOL)isFooterRefresh
{
    [self addHeaderRefresh:tableView headerRefesh:isHeaderFresh headerTitle:nil andFooter:isFooterRefresh footerTitle:nil];
}

- (void)addHeaderRefresh:(UITableView *)tableView headerRefesh:(BOOL)isHeaderFresh headerTitle:(NSDictionary *)headerTitle andFooter:(BOOL)isFooterRefresh footerTitle:(NSDictionary *)footerTitle
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (isHeaderFresh){
        SHGGifHeader *header = [SHGGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
        header.backgroundColor = [UIColor clearColor];
        tableView.mj_header = header;
    }
    if (isFooterRefresh){
        MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
        footer.stateLabel.textColor = [UIColor colorWithHexString:@"606060"];
        footer.stateLabel.font = [UIFont systemFontOfSize:12.0f];
        tableView.mj_footer = footer;
        [footer setTitle:[footerTitle objectForKey:@(MJRefreshStateIdle)] forState:MJRefreshStateIdle];
        [footerTitle enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSString *obj, BOOL * _Nonnull stop) {
            [footer setTitle:obj forState:key.integerValue];
        }];
    }

}


- (void)refreshHeader
{
//子类实现
}

- (void)refreshFooter
{
    //
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark =============  UITableView DataSource  =============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

#pragma mark =============  UITableView Delegate  =============

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You Click At Section: %ld Row: %ld",(long)indexPath.section,(long)indexPath.row);
}

@end
