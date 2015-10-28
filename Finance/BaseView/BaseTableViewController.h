//
//  BaseTableViewController.h
//  Finance
//
//  Created by HuMin on 15/4/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MWPhotoBrowserDelegate>

@property (strong, nonatomic) NSMutableArray *dataArr;

//列表数据
@property (strong, nonatomic) NSMutableArray *listArray;
//推广数据
@property (strong, nonatomic) NSMutableArray *adArray;

- (void)addHeaderRefresh:(UITableView *)tableView headerRefesh:(BOOL)isHeaderFresh  andFooter:(BOOL)isFooterRefresh;
- (void)addHeaderRefresh:(UITableView *)tableView headerRefesh:(BOOL)isHeaderFresh headerTitle:(NSDictionary *)headerTitle andFooter:(BOOL)isFooterRefresh footerTitle:(NSDictionary *)footerTitle;


@end
