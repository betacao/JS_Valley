//
//  BaseTableViewController.h
//  Finance
//
//  Created by HuMin on 15/4/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;

-(void)addHeaderRefresh:(UITableView *)tableView headerRefesh:(BOOL)isHeaderFresh  andFooter:(BOOL)isFooterRefresh;


@end
