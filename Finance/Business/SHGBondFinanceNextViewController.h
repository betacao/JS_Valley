//
//  SHGBondFinanceNextViewController.h
//  Finance
//
//  Created by weiqiankun on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGBusinessObject.h"
#import "SHGBondFinanceSendViewController.h"
#import "SHGBusinessDelegate.h"

@interface SHGBondFinanceNextViewController : BaseViewController
@property (strong, nonatomic) SHGBusinessObject *object;
@property (assign, nonatomic) id<SHGBusinessDelegate> delegate;
@property (weak, nonatomic) UIViewController *superController;

@end
