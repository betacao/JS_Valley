//
//  DiscoverViewController.h
//  Finance
//
//  Created by HuMin on 15/5/21.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "DiscoveryTableViewCell.h"
#import "ProductListViewController.h"
#import "DiscovFirstFriendViewController.h"
#import "DiscovSecondFriendViewController.h"
#import "ChatListViewController.h"
@interface DiscoverViewController : BaseTableViewController
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@end
