//
//  CircleNewDetailViewController.h
//  Finance
//
//  Created by 魏虔坤 on 15/12/14.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "AppDelegate.h"
#import "CircleListObj.h"
#import "SHGHomeViewController.h"
#import "ReplyTableViewCell.h"

#define kShareNum       @"shareNum"
#define kCommentNum     @"commentNum"
#define kPraiseNum      @"praiseNum"
@interface CircleNewDetailViewController : BaseTableViewController<BRCommentViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,ReplyDelegate,CircleActionDelegate>
@property (weak, nonatomic)     id<CircleActionDelegate> delegate;
@property (strong, nonatomic)   NSString *rid;
@property (strong, nonatomic)   CircleListObj *obj;
@property (strong, nonatomic)   NSDictionary *itemInfoDictionary;

@end
