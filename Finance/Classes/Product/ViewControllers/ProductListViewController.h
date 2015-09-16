//
//  ProductListViewController.h
//  Finance
//
//  Created by HuMin on 15/4/20.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ProdConfigViewController.h"
#import "ProdSubViewController.h"
@interface ProductListViewController : BaseTableViewController<UIScrollViewDelegate,UISearchBarDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (strong ,nonatomic, readonly) UIView *titleView;
@property (nonatomic ,strong)    UILabel *titleLabel;
@property (strong ,nonatomic, readonly) UIBarButtonItem *rightBarButtonItem;
@property (strong ,nonatomic) NSArray *rightBarButtonItemArr;
@property (strong ,nonatomic, readonly) UIBarButtonItem *leftBarButtonItem;

@end
