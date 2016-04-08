//
//  SHGBusinessSelectCategoryViewController.h
//  Finance
//
//  Created by changxicao on 16/4/7.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"

@interface SHGBusinessSelectCategoryViewController : BaseViewController

@property (strong, nonatomic) NSArray *dataArray;

@end

@interface SHGBusinessCategoryContentView : UIView
@property (strong, nonatomic) NSMutableArray *buttonArray;
@end