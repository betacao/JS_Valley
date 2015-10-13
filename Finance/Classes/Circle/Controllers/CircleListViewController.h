//
//  CircleListViewController.h
//  Finance
//
//  Created by HuMin on 15/4/10.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "CircleListTableViewCell.h"
#import "CircleDetailViewController.h"
#import "CircleSomeOneViewController.h"
@interface CircleListViewController : BaseTableViewController<CircleListDelegate,BRCommentViewDelegate,CircleActionDelegate,MWPhotoBrowserDelegate>

@property (strong ,nonatomic, readonly) UIView *titleView;
@property (strong ,nonatomic, readonly) UIBarButtonItem *rightBarButtonItem;
@property (strong ,nonatomic, readonly) UIBarButtonItem *leftBarButtonItem;

@end
