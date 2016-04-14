//
//  SHGBusinessDetailViewController.h
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGBusinessObject.h"
#import "SHGMarketCollectionViewController.h"

@interface SHGBusinessDetailViewController : BaseTableViewController
@property (strong, nonatomic) SHGBusinessObject *object;
@property (weak, nonatomic) SHGMarketCollectionViewController *controller;
- (void)editBusiness;
@end