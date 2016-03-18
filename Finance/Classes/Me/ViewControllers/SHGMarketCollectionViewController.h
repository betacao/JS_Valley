//
//  SHGMarketViewController.h
//  Finance
//
//  Created by weiqiankun on 16/3/15.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SHGMarketCollectionViewController : BaseTableViewController
- (NSMutableArray *) currentDataArray;
- (void)reloadData;
- (void)refreshData;
- (void)changeMarketCollection;
@end
