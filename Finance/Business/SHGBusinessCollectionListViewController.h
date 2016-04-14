//
//  SHGBusinessCollectionListViewController.h
//  Finance
//
//  Created by weiqiankun on 16/4/13.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SHGBusinessCollectionListViewController : BaseTableViewController
- (NSMutableArray *) currentDataArray;
- (void)reloadData;
- (void)refreshData;
@end
