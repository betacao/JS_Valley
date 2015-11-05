//
//  CircleDetailViewController.h
//  Finance
//
//  Created by HuMin on 15/4/20.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "AppDelegate.h"
#import "CircleListObj.h"
#import "CircleSomeOneViewController.h"
#import "SHGHomeViewController.h"
#import "ReplyTableViewCell.h"

#define kShareNum       @"shareNum"
#define kCommentNum     @"commentNum"
#define kPraiseNum      @"praiseNum"

@interface CircleDetailViewController : BaseTableViewController<BRCommentViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,ReplyDelegate,CircleActionDelegate>
@property (weak, nonatomic)     id<CircleActionDelegate> delegate;
@property (strong, nonatomic)   NSString *rid;
@property (strong, nonatomic)   CircleListObj *obj;
@property (strong, nonatomic)   NSDictionary *itemInfoDictionary;

- (void)smsShareSuccess:(NSNotification *)noti;

@end
