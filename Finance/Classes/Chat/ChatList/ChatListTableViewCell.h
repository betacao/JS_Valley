//
//  ChatListTableViewCell.h
//  Finance
//
//  Created by HuMin on 15/6/6.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "BasePeopleObject.h"

typedef NS_ENUM(NSInteger, contactType)
{
    contactTypeFriend = 0,//好友列表
    contactTypeFriendTwain = 1,//好友的好友列表
    
};
@interface ChatListTableViewCell : UITableViewCell
@property (nonatomic, assign) contactType type;

- (void)loadDataWithobj:(BasePeopleObject *)obj;
- (void)loadDataWithObject:(SHGPeopleObject *)obj;
@end
