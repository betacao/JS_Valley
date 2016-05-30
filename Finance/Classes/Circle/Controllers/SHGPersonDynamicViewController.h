//
//  SHGPersonDynamicViewController.h
//  Finance
//
//  Created by changxicao on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SHGPersonDynamicViewController : BaseTableViewController

@property (strong, nonatomic) NSString *userId;
@property (nonatomic, weak) id<CircleActionDelegate> delegate;

@end
