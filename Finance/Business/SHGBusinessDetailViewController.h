//
//  SHGBusinessDetailViewController.h
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGBusinessObject.h"
#import "SHGBusinessCollectionListViewController.h"
#import "SHGBusinessMineViewController.h"
@interface SHGBusinessDetailViewController : BaseTableViewController
@property (strong, nonatomic) SHGBusinessObject *object;
- (void)didCreateOrModifyBusiness;

@end