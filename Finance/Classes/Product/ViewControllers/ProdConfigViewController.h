//
//  ProdConfigViewController.h
//  Finance
//
//  Created by HuMin on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ProdListObj.h"
#import "SubDetailViewController.h"
#import "ProdConsulutionViewController.h"
#import "CinfigView.h"
@interface ProdConfigViewController : BaseTableViewController<UIActionSheetDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) ProdListObj *obj;
@property (nonatomic, strong) NSString *type;
@end
