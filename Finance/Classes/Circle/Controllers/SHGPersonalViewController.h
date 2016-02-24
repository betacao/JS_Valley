//
//  SHGPersonalViewController.h
//  Finance
//
//  Created by changxicao on 15/11/11.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "MyCollectionViewController.h"
@interface SHGPersonalViewController : BaseTableViewController

@property (strong, nonatomic) NSString *userId;
@property (weak, nonatomic) MyCollectionViewController * controller;
@property (strong, nonatomic) id<CircleActionDelegate> delegate;
@end
