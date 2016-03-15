//
//  SHGHomeViewController.h
//  Finance
//
//  Created by HuMin on 15/4/10.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
@interface SHGHomeViewController : BaseTableViewController
+ (instancetype)sharedController;
- (UITableView *)currentTableView;
- (NSMutableArray *) currentDataArray;
- (NSMutableArray *) currentListArray;
- (void)deleteCellAtIndexPath:(NSArray *)paths;
- (void)refreshHeader;
@end