//
//  SHGBondFinancingSendNextViewController.h
//  Finance
//
//  Created by weiqiankun on 16/4/1.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGBondInvestSendViewController.h"
#import "SHGBusinessObject.h"

@interface SHGBondInvestNextViewController : BaseViewController
@property (strong, nonatomic) SHGBusinessObject *object;
@property (weak, nonatomic) UIViewController *superController;

@end
