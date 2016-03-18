//
//  SHGCircleViewController.h
//  Finance
//
//  Created by weiqiankun on 16/3/17.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SHGCircleCollectionViewController : BaseTableViewController
- (NSMutableArray *) currentDataArray;
- (void)smsShareSuccess:(NSNotification *)noti;
- (void)reloadData;
- (void)refreshData;
- (void)changeCardCollection;
@end
