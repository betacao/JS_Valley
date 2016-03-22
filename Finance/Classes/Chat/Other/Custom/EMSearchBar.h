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

@interface EMSearchBar : UISearchBar
@property (assign, nonatomic) BOOL needLineView;
@property (strong, nonatomic) UIColor *cancelButtonTitleColor;
@property (strong, nonatomic) UIColor *backgroundImageColor;
@end
