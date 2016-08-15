//
//  SHGMyComplainViewController.h
//  Finance
//
//  Created by weiqiankun on 16/8/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SHGBusinessObject.h"
@interface SHGMyComplainViewController : BaseTableViewController
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) SHGBusinessObject *object;
@end
