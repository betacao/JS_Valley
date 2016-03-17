//
//  Constant.h
//  Finance
//
//  Created by HuMin on 15/4/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//
#import "pathConstant.h"
#import "ipConstant.h"
#import "notificationConstant.h"

#ifndef Finance_Constant_h
#define Finance_Constant_h

#define rRequestNum     @10

#define labletextColor    [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]

#define kNavBarTitleFontSize    17

#define UID [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]

#define kStatusBarHeight CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)

#define kNavigationBarHeight CGRectGetHeight([TabBarViewController tabBar].navigationController.navigationBar.frame)

#define kTabBarHeight CGRectGetHeight([TabBarViewController tabBar].tabBar.frame)

#define CURRENT_VERSION [[UIDevice currentDevice].systemVersion floatValue]

#define LOCAL_Version       [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]

#define kIsScreen3_5Inch ([[UIScreen mainScreen] bounds].size.height == 480.0f) ? YES : NO

//屏幕尺寸
#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

#define XFACTOR SCREENWIDTH / 320.0f
#define YFACTOR SCREENHEIGHT / 568.0f

#define FontFactor(font)  [UIFont systemFontOfSize:(SCREENWIDTH >= 375.0f ? font : (font - 1.0f))]
#define MarginFactor(x) floorf(SCREENWIDTH / 375.0f * x)

#define Color(color) [UIColor colorWithHexString: color]
//计算颜色
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

//计算颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//Navigation背景颜色
#define NavRTitleColor  [UIColor whiteColor]
//主题色
#define COMMON_COLOR [UIColor colorWithRed:62.0/255.0 green:148.0/255.0 blue:218.0/255.0 alpha:1.0]

#define TEXT_COLOR [UIColor whiteColor]

#define CELL_PHOTO_SEP  6 * XFACTOR

#define CELLRIGHT_WIDTH  45
#define CELLRIGHT_COMMENT_WIDTH  7.0f * XFACTOR

#define BACK_COLOR  RGBA(247,247,247,1)

#define BTN_SELECT_BACK_COLOR  RGBA(236,241,247,1)


#ifndef judgeEmpty
#define judgeEmpty
///是否为空或是[NSNull null]
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
///字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
///数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

#endif

#define	__STRINGNOTNIL( __x )   (__x?__x:@"")
#define MontageStr(_a,_b)  [NSString stringWithFormat:@"%@/%@",_a,_b]

#define MOCLogDebug(_ref)  NSLog(@"%@ %@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd),_ref);


#if NS_BLOCKS_AVAILABLE
typedef void (^BBBasicBlock)(void);
#endif
//线程执行方法 GCD
#define PERFORMSEL_BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define PERFORMSEL_SYNC_BACK(block) dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define PERFORMSEL_MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#define SHARE_CONTENT   @"我正在使用大牛圈，点击来下载吧"
#define SHARE_TITLE   @"大牛圈"
#define SHARE_TITLE_INVITE   @"大牛圈"
#define SHARE_DEFAULT_CONTENT   @"我正在使用大牛圈，点击来下载吧"


#define SHARE_DESCRIPTION   @"我正在使用大牛圈，点击来下载吧"
#define SHARE_TYPE   SSPublishContentMediaTypeNews

#define SHARE_TO_FRIEND   @"a"
#define MANAGER_PHONE  @"4009609599"

#define TYPE_PHOTO   @"photo"
#define CHATID_MANAGER   @"-2"
#define CHAT_NAME_MANAGER @"大牛圈"

#define SHARE_CHAT_MESS    @"我正在使用大牛圈“"
#define DA_NIU_QIAM    @"我正在使用大牛圈"

//当前的版本号
#define kShowVersion @"showVersion"
#define kPathDocument               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kFilePath   [kPathDocument stringByAppendingPathComponent:@"%@"]

#define kRefreshStateIdle       @"stateIdle"
#define kRefreshStatePulling    @"statePulling"
#define kRefreshStateRefreshing @"stateRefreshing"
#endif
