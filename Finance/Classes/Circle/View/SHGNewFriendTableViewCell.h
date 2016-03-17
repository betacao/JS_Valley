//
//  SHGNewFriendTableViewCell.h
//  Finance
//
//  Created by changxicao on 16/3/16.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHGNewFriendObject : MTLModel<MTLJSONSerializing>
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *realName;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *picName;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *position;
@property (strong, nonatomic) NSString *commonFriendCount;
@property (strong, nonatomic) NSArray *commonFriendList;

@end

@interface SHGNewFriendTableViewCell : UITableViewCell

@property (strong, nonatomic) SHGNewFriendObject *object;

@end