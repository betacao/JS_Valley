//
//  SHGEquityInvestNextViewController.h
//  Finance
//
//  Created by weiqiankun on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGBusinessObject.h"
#import "SHGEquityInvestSendViewController.h"


@interface SHGEquityInvestNextViewController : BaseViewController
@property (strong, nonatomic) SHGBusinessObject *object;
@property (weak, nonatomic) UIViewController *superController;
@end
