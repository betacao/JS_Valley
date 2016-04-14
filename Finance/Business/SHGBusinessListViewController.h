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

@property (weak, nonatomic) IBOutlet UIButton *addBusinessButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) loadViewFinishBlock block;
@property (strong, nonatomic) UIBarButtonItem *leftBarButtonItem;
@property (strong, nonatomic) NSString *cityName;
- (void)setFilterTitleArray:(NSArray *)array;
- (NSArray *)getFilterTitleArray;

- (void)deleteBusinessWithBusinessID:(NSString *)businessID;
@end
