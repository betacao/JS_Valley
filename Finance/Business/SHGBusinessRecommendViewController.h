//
//  SHGBusinessRecommendViewController.h
//  Finance
//
//  Created by changxicao on 16/7/15.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGBusinessObject.h"

@interface SHGBusinessRecommendViewController : BaseViewController

@end


@interface SHGBusinessRecommendTableViewCell : UITableViewCell

@property (strong, nonatomic) SHGBusinessObject *object;

@end