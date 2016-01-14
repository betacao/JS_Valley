//
//  SHGFriendViewController.h
//  Finance
//
//  Created by changxicao on 16/1/13.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, SHGFriendType) {
    SHGFriendTypeFirst = 0,
    SHGFriendTypeSecond
};

@interface SHGConnectionsViewController : BaseTableViewController
@property (assign, nonatomic) SHGFriendType type;
@end
