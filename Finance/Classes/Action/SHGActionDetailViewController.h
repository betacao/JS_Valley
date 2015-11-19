//
//  SHGActionDetailViewController.h
//  Finance
//
//  Created by 魏虔坤 on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "AppDelegate.h"
#import "SHGActionObject.h"

@interface SHGActionDetailViewController : BaseTableViewController<BRCommentViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,ReplyDelegate,CircleActionDelegate>
@property (strong, nonatomic) SHGActionObject *object;
@end
