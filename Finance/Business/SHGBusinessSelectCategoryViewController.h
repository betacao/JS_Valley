//
//  SHGBusinessSelectCategoryViewController.h
//  Finance
//
//  Created by changxicao on 16/4/7.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^SHGBusinessSelectCategoryBlock)(NSDictionary *param);

@interface SHGBusinessSelectCategoryViewController : BaseViewController
@property (copy, nonatomic) SHGBusinessSelectCategoryBlock selectedBlock;
@end
