//
//  SHGHomeViewController.h
//  Finance
//
//  Created by HuMin on 15/4/10.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
@interface SHGHomeViewController : BaseTableViewController

- (UITableView *)currentTableView;
- (NSMutableArray *) currentDataArray;
- (NSMutableArray *) currentListArray;
- (void)refreshHeader;

@end

@interface SHGHomeTagsView : UIView

- (void)updateSelectedArray;

- (NSArray *)userSelectedTags;

@end