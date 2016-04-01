//
//  SHGBusinessListViewController.h
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
typedef void(^loadViewFinishBlock)(UIView *view);
@interface SHGBusinessListViewController : BaseTableViewController
+ (instancetype)sharedController;
@property (nonatomic, copy) loadViewFinishBlock block;
@property (strong, nonatomic) UIBarButtonItem *leftBarButtonItem;

@end
