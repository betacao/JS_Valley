//
//  SHGDiscoveryGroupingViewController.h
//  Finance
//
//  Created by changxicao on 16/5/25.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGDiscoveryObject.h"

@interface SHGDiscoveryGroupingViewController : BaseViewController
@property (strong, nonatomic) SHGDiscoveryIndustryObject *object;
@end


@interface SHGDiscoveryGroupingCell : UITableViewCell

@property (strong, nonatomic) SHGDiscoveryIndustryObject *object;

@end