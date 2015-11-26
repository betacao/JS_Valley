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
@protocol SHGActionAddCommentDelegate <NSObject>

- (void)didCommentAction:(SHGActionObject *)object;

@end
@interface SHGActionDetailViewController : BaseTableViewController
@property (strong, nonatomic) SHGActionObject *object;
@property (weak, nonatomic) id<SHGActionAddCommentDelegate> delegate;
@end
