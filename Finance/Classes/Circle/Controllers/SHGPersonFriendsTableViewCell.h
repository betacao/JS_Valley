//
//  SHGPersonFriendsTableViewCell.h
//  Finance
//
//  Created by 魏虔坤 on 15/11/22.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePeopleObject.h"
@interface SHGPersonFriendsTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *uid;
@property (strong,nonatomic) BasePeopleObject * obj;
@end
