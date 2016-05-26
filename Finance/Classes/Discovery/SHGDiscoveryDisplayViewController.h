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

@property (strong, nonatomic) NSObject *object;

@end



@interface SHGDiscoveryDisplayCell : UITableViewCell

@property (strong, nonatomic) NSObject *object;

@end