//
//  SHGMarketListViewController.h
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGMarketObject.h"

@interface SHGMarketListViewController : BaseTableViewController
- (NSMutableArray *) currentDataArray;
- (void)reloadData;
- (void)refreshData;
//移动到某个分类
- (void)scrollToCategory:(SHGMarketFirstCategoryObject *)object;
@end
