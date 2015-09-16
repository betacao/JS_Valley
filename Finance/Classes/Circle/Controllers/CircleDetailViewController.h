//
//  CircleDetailViewController.h
//  Finance
//
//  Created by HuMin on 15/4/20.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

@protocol circleActionDelegate <NSObject>
@optional
-(void)detailPraiseWithRid:(NSString *)rid praiseNum:(NSString*)num isPraised:(NSString *)isPrased;
-(void)detailCommentWithRid:(NSString *)rid commentNum:(NSString *)num comments:(NSMutableArray *)comments;
-(void)detailShareWithRid:(NSString *)rid shareNum:(NSString*)num;
-(void)detailAttentionWithRid:(NSString *)rid attention:(NSString *)atten;
-(void)detailDeleteWithRid:(NSString *)rid ;
-(void)detailCollectionWithRid:(NSString *)rid collected:(NSString *)isColle;

@end
#import "BaseTableViewController.h"
#import "AppDelegate.h"
#import "CircleListObj.h"
#import "CircleSomeOneViewController.h"
#import "CircleListViewController.h"
#import "ReplyTableViewCell.h"

@interface CircleDetailViewController : BaseTableViewController<MWPhotoBrowserDelegate,BRCommentViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,ReplyDelegate,circleActionDelegate>
@property (nonatomic, weak)id<circleActionDelegate> delegate;
@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong)CircleListObj *obj;

@end
