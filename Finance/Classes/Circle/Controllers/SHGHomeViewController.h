//
//  SHGHomeViewController.h
//  Finance
//
//  Created by HuMin on 15/4/10.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
@interface SHGHomeViewController : BaseTableViewController

@property (assign, nonatomic) BOOL needShowNewFriend;
@property (assign, nonatomic) BOOL needRefreshTableView;

+ (instancetype)sharedController;
- (NSMutableArray *) currentDataArray;
- (NSMutableArray *) currentListArray;
- (void)refreshHeader;
- (void)requestRecommendFriends;
- (void)loadRegisterPushFriend;
@end