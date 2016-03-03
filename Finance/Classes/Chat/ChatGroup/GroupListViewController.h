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

@interface GroupListViewController : BaseTableViewController

@property (weak, nonatomic) UIViewController *parnetVC;

- (void)reloadDataSource;

@end

@interface SHGGroupObject : NSObject
@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) BOOL imageViewHidden;
@property (assign, nonatomic) BOOL rightViewHidden;
@property (assign, nonatomic) BOOL lineViewHidden;
@end

@interface SHGGroupTableViewCell : UITableViewCell

@property (strong, nonatomic) SHGGroupObject *object;

@end



@interface SHGGroupHeaderObject : NSObject

@property (assign, nonatomic) NSInteger count;

@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) NSString *text;

@end

@interface SHGGroupHeaderView : UIView

@property (strong, nonatomic) SHGGroupHeaderObject *object;

@end

