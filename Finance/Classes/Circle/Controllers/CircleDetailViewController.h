//
//  CircleDetailViewController.h
//  Finance
//
//  Created by HuMin on 15/4/20.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

@protocol CircleActionDelegate <NSObject>
@optional
- (void)detailPraiseWithRid:(NSString *)rid praiseNum:(NSString*)num isPraised:(NSString *)isPrased;
- (void)detailCommentWithRid:(NSString *)rid commentNum:(NSString *)num comments:(NSMutableArray *)comments;
- (void)detailShareWithRid:(NSString *)rid shareNum:(NSString*)num;
- (void)detailAttentionWithRid:(NSString *)rid attention:(NSString *)atten;
- (void)detailDeleteWithRid:(NSString *)rid ;
- (void)detailCollectionWithRid:(NSString *)rid collected:(NSString *)isColle;
- (void)homeListShouldRefresh:(CircleListObj *)currentObj;

@end
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
