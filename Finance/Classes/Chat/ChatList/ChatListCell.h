/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

@interface ChatListCell : UITableViewCell
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) UIImage *placeholderImage;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *detailMsg;
@property (strong, nonatomic) NSString *time;
@property (assign, nonatomic) NSInteger unreadCount;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIImageView * rightImage;
+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
