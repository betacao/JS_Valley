//
//  AppDelegate.h
//  Finance
//
//  Created by HuMin on 15/4/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LoginViewController.h"
#import "TabBarViewController.h"
#import "RootViewController.h"
#import "MOCNetworkReachabilityManager.h"
#import "WeiboSDK.h"
#import "CircleListObj.h"
#import "WXApi.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,IChatManagerDelegate,MFMessageComposeViewControllerDelegate,WeiboSDKDelegate,UIAlertViewDelegate,WXApiDelegate>{
    EMConnectionState _connectionState;
}

+ (AppDelegate *)currentAppdelegate;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BaseNavigationController *nav;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)exitApplication;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)sendSmsWithText:(NSString *)text rid:(NSString *)rid;
- (void)sendmessageToShareWithObjContent:(NSString *)content rid:(NSString *)rid;
- (void)wechatShare:(CircleListObj *)obj shareType:(NSInteger)scene;
- (void)wechatShareWithText:(NSString *)text shareUrl:(NSString *)shareUrl shareType:(NSInteger)scene;
- (void)shareActionToSMS:(NSString *)content;
- (void)shareActionToWeChat:(NSInteger)type content:(NSString *)content url:(NSString *)url;
@end

