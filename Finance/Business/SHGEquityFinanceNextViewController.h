//
//  SHGEquityFinanceNextViewController.h
//  Finance
//
//  Created by weiqiankun on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGBusinessObject.h"
#import "SHGEquityFinanceSendViewController.h"

@interface SHGEquityFinanceNextViewController : BaseViewController
@property (strong, nonatomic) SHGBusinessObject *object;
@property (weak, nonatomic) UIViewController *superController;
@end
