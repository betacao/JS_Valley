//
//  SHGBusinessCollectionViewController.h
//  Finance
//
//  Created by changxicao on 16/8/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"

@interface SHGBusinessCollectionViewController : BaseViewController

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;
- (void)didCreateOrModifyBusiness;
@end
