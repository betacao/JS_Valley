//
//  SHGNewsViewController.h
//  Finance
//
//  Created by changxicao on 15/11/4.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SHGNewsViewController : BaseTableViewController

- (UITableView *)currentTableView;

- (NSMutableArray *)currentDataArray;

- (void)refreshHeader;

- (void)refreshLoad;
@end
