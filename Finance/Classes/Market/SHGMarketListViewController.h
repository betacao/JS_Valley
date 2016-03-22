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
- (void)tableViewReloadData;
//拉取当前分类下的
- (void)reloadData;
//全部重新拉取
- (void)refreshData;
- (void)clearAndReloadData;
//移动到某个分类
- (void)scrollToCategory:(SHGMarketFirstCategoryObject *)object;
- (void)deleteMarketByMarketId:(NSString *)marketId;
@end
