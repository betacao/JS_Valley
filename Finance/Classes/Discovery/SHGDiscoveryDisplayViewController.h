//
//  SHGDiscoveryDisplayViewController.h
//  Finance
//
//  Created by changxicao on 16/5/25.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SHGDiscoveryObject.h"

@interface SHGDiscoveryDisplayViewController : BaseTableViewController

@property (strong, nonatomic) SHGDiscoveryObject *object;

@end

@interface SHGDiscoveryDisplayCell : UITableViewCell

@property (strong, nonatomic) NSObject *object;

@end

//本来可以用SHGDiscoveryDisplayViewController
//刷新的方式不同 无法复用
@interface SHGDiscoveryDisplayExpandViewController : BaseTableViewController

@property (strong, nonatomic) SHGDiscoveryIndustryObject *object;

@end