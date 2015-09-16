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
#import "DXMessageToolBar.h"

@interface ChatViewController : BaseViewController
@property (strong, nonatomic) DXMessageToolBar *chatToolBar;
@property (nonatomic,assign)BOOL isShare;
@property (nonatomic, strong)NSString *shareRid;
@property (nonatomic, strong)NSString *shareContent;

- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup;
- (void)reloadData;
@end
