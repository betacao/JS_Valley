//
//  SHGBusinessMineViewController.h
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SHGBusinessMineViewController : BaseTableViewController
- (void)deleteBusinessWithBusinessID:(NSString *)businessID;
@property(nonatomic, strong) NSString *userId;
@end
