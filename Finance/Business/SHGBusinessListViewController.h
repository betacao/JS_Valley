//
//  SHGBusinessListViewController.h
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SHGBusinessObject.h"

typedef void(^loadViewFinishBlock)(UIView *view);

@interface SHGBusinessListViewController : BaseTableViewController

+ (instancetype)sharedController;

@property (weak, nonatomic) IBOutlet UIButton *addBusinessButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) loadViewFinishBlock block;
@property (strong, nonatomic) UIBarButtonItem *leftBarButtonItem;
@property (strong, nonatomic) NSString *cityName;
//切换账号标识
@property (assign, nonatomic) BOOL needReloadData;

- (void)loadFilterTitleAndParam:(void(^)(NSArray *array, NSDictionary *param, NSArray *selectedArray))block;

- (void)deleteBusinessWithBusinessID:(NSString *)businessID;

- (void)didCreateOrModifyBusiness:(SHGBusinessObject *)object;
- (void)clearCache;
@end
