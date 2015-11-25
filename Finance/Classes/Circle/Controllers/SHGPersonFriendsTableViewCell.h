//
//  SHGPersonFriendsTableViewCell.h
//  Finance
//
//  Created by 魏虔坤 on 15/11/22.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePeopleObject.h"
@protocol SHGPersonFriendsDelegate<NSObject>
- (void)tapUserHeaderImageView:(NSString *)uid;
@end
@interface SHGPersonFriendsTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *uid;
@property (assign, nonatomic) id<SHGPersonFriendsDelegate> delegate;
- (void)loadDatasWithObj:(BasePeopleObject *)obj;
@end
