//
//  FriendsListViewController.h
//  Finance
//
//  Created by haibo li on 15/5/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"

@interface FriendsListViewController : BaseTableViewController

@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, strong) NSString *shareContent;
@property (nonatomic, strong) NSString *shareRid;
- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;

@end
