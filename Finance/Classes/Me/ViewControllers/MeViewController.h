//
//  MeViewController.h
//  Finance
//
//  Created by HuMin on 15/4/10.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MeTableViewCell.h"
@interface MeViewController : BaseTableViewController<UIScrollViewDelegate>

@property (strong ,nonatomic, readonly) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic ,strong)    UILabel *titleLabel;

@end