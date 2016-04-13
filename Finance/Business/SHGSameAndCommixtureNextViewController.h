//
//  SHGSameAndCommixtureNextViewController.h
//  Finance
//
//  Created by weiqiankun on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGBusinessObject.h"
#import "SHGSameAndCommixtureSendViewController.h"
#import "SHGBusinessDelegate.h"

@interface SHGSameAndCommixtureNextViewController : BaseViewController
@property (strong, nonatomic) SHGBusinessObject *object;
@property (assign, nonatomic) id<SHGBusinessDelegate> delegate;
@property (weak, nonatomic) UIViewController *superController;
@end
