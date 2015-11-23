//
//  SHGActionTotalInViewController.h
//  Finance
//
//  Created by changxicao on 15/11/19.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGActionObject.h"
typedef void (^OperationBlock)(void);
@interface SHGActionTotalInViewController : BaseViewController

@property (strong, nonatomic) NSArray *attendList;
@property (copy, nonatomic) OperationBlock block;
@end
