//
//  MyCollectionViewController.h
//  Finance
//
//  Created by Okay Hoo on 15/4/29.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "CircleListObj.h"
#import "ProdListObj.h"
#import "ProdConfigViewController.h"
#import "CircleDetailViewController.h"
@interface MyCollectionViewController : BaseTableViewController<MWPhotoBrowserDelegate,CircleListDelegate,circleActionDelegate,UIAlertViewDelegate>

- (void)smsShareSuccess:(NSNotification *)noti;

@end
