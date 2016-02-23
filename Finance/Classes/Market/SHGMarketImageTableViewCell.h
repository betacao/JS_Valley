//
//  SHGMarketNoticeTableViewCell.h
//  Finance
//
//  Created by changxicao on 16/1/22.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGMarketObject.h"

@interface SHGMarketImageTableViewCell : UITableViewCell

@property (strong ,nonatomic) SHGMarketNoticeObject *object;

@property (weak, nonatomic) UIViewController *controller;

@end


@interface SHGMarketLabelTableViewCell : UITableViewCell

@property (strong ,nonatomic) SHGMarketNoticeObject *object;

@property (weak, nonatomic) UIViewController *controller;

@end