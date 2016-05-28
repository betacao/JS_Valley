//
//  SHGBusinessMineViewController.h
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SHGBusinessMineViewController : BaseTableViewController

@property(nonatomic, strong) NSString *userId;

- (void)deleteBusinessWithBusinessID:(NSString *)businessID;
- (void)didCreateOrModifyBusiness;

@end
