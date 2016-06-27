//
//  SHGUserCenterViewController.h
//  Finance
//
//  Created by changxicao on 16/1/28.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SHGAuthenticationView.h"

@interface SHGUserCenterViewController : BaseTableViewController

+ (instancetype)sharedController;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;

@property (strong, nonatomic) SHGAuthenticationView *authenticationView;

@end


@interface SHGUserCenterAuthTipView : UIView

@property (assign, nonatomic) CGFloat pointX;

@property (strong, nonatomic) UIView *contentView;

@end