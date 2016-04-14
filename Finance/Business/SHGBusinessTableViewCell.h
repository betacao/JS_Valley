//
//  SHGBusinessTableViewCell.h
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGBusinessObject.h"

typedef NS_ENUM(NSInteger, SHGBusinessTableViewCellStyle)
{
    SHGBusinessTableViewCellStyleOther = 0,
    SHGBusinessTableViewCellStyleMine
};

@interface SHGBusinessTableViewCell : UITableViewCell
@property (strong, nonatomic) SHGBusinessObject *object;
@property (assign, nonatomic) SHGBusinessTableViewCellStyle style;
@end
