//
//  SHGDiscoveryGroupingViewController.h
//  Finance
//
//  Created by changxicao on 16/5/25.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGDiscoveryObject.h"

typedef NS_ENUM(NSInteger, SHGDiscoveryGroupingType) {
    SHGDiscoveryGroupingTypeIndustry,
    SHGDiscoveryGroupingTypePosition
};

@interface SHGDiscoveryGroupingViewController : BaseViewController

@property (assign, nonatomic) SHGDiscoveryGroupingType type;

@end


@interface SHGDiscoveryGroupingCell : UITableViewCell

@property (strong, nonatomic) SHGDiscoveryIndustryObject *object;

@end