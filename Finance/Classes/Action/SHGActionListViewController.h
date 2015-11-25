//
//  SHGActionViewController.h
//  Finance
//
//  Created by 魏虔坤 on 15/11/12.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SHGActionListViewController : BaseTableViewController
- (NSMutableArray *) currentDataArray;
- (void)refreshData;
- (void)reloadData;
@end
