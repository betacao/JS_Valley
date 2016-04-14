//
//  SHGBusinessSearchResultViewController.h
//  Finance
//
//  Created by changxicao on 16/4/14.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, SHGBusinessSearchType)
{
    SHGBusinessSearchTypeNormal = 0,
    SHGBusinessSearchTypeAdvanced
};

@interface SHGBusinessSearchResultViewController : BaseTableViewController

//普通搜索参数
@property (strong, nonatomic) NSDictionary *param;

//高级搜索参数
@property (strong, nonatomic) NSDictionary *advancedParam;

- (instancetype)initWithType:(SHGBusinessSearchType)type;

- (void)tableViewReloadData;
@end

@interface SHGBusinssSearchResultHeaderView : UIView

@property (strong, nonatomic) NSString *totalCount;

@property (assign, nonatomic) SHGBusinessSearchType type;

@property (weak, nonatomic) UIViewController *parentController;

@end