//
//  SHGCardCollectionViewController.h
//  Finance
//
//  Created by weiqiankun on 16/3/16.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SHGCardCollectionViewController : BaseTableViewController
- (NSMutableArray *) currentDataArray;
- (void)reloadData;
- (void)refreshData;
- (void)changeCardCollection;
@end
