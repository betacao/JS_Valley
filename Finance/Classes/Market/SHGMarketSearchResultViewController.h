//
//  SHGMarketSearchResultViewController.h
//  Finance
//
//  Created by changxicao on 16/2/16.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, SHGMarketSearchType)
{
    SHGMarketSearchTypeNormal = 0,
    SHGMarketSearchTypeAdvanced
};

@interface SHGMarketSearchResultViewController : BaseTableViewController

//普通搜索参数
@property (strong, nonatomic) NSDictionary *param;

//高级搜索参数
@property (strong, nonatomic) NSDictionary *advancedParam;

- (instancetype)initWithType:(SHGMarketSearchType)type;

@end

@interface SHGMarketSearchResultHeaderView : UIView

@property (strong, nonatomic) NSString *totalCount;

@property (assign, nonatomic) SHGMarketSearchType type;

@property (weak, nonatomic) UIViewController *parentController;

@end