//
//  SHGHomeViewController.h
//  Finance
//
//  Created by HuMin on 15/4/10.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SHGHomeTableViewCell.h"
#import "CircleDetailViewController.h"
#import "CircleSomeOneViewController.h"
@interface SHGHomeViewController : BaseTableViewController<CircleListDelegate,BRCommentViewDelegate,CircleActionDelegate>

@property (strong ,nonatomic, readonly) UIView *titleView;
@property (strong ,nonatomic, readonly) UIBarButtonItem *rightBarButtonItem;

@end
