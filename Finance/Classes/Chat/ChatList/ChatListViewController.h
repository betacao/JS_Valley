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
#import "BaseTableViewController.h"
#import "TwainContactInfo.h"
typedef NS_ENUM(NSInteger, ChatListViewType)
{
	ChatListView = 0,//消息列表
	ContactListView = 1,//联系人列表
    ContactTwainListView = 2,//联系人列表

};

@interface ChatListViewController : BaseTableViewController<UINavigationControllerDelegate>

+ (instancetype)sharedController;

@property (nonatomic,assign) BOOL isResfresh;
@property (strong ,nonatomic, readonly) UIView *titleView;
@property (strong ,nonatomic, readonly) UIBarButtonItem *rightBarButtonItem;
@property (strong ,nonatomic, readonly) UIBarButtonItem *leftBarButtonItem;
@property (strong, nonatomic) NSMutableArray *contactsSource;

@property (nonatomic, strong)NSMutableArray *arrCityCode;
//好友请求变化时，更新好友请求未处理的个数
- (void)reloadApplyView;

//群组变化时，更新群组页面
- (void)reloadGroupView;

//好友个数变化时，重新获取数据
- (void)reloadDataSource;

//添加好友的操作被触发
//- (void)addFriendAction;

@end
