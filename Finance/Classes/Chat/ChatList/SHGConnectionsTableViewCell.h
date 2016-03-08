//
//  SHGConnectionsTableViewCell.h
//  Finance
//
//  Created by changxicao on 16/3/7.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePeopleObject.h"

typedef NS_ENUM(NSInteger, SHGContactType)
{
    SHGContactTypeFirst = 0,//好友列表
    SHGContactTypeSecond = 1,//好友的好友列表

};
@interface SHGConnectionsTableViewCell : UITableViewCell

@property (strong, nonatomic) id object;
@property (assign, nonatomic) SHGContactType type;
@end
