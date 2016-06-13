//
//  BRCommentView.h
//  DingDCommunity
//
//  Created by JianjiYuan on 14-4-9.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import "BasePopupView.h"

@class BRCommentView;

@protocol BRCommentViewDelegate <NSObject>

@optional
- (void)commentViewDidComment:(NSString *)comment rid:(NSString *)rid;
- (void)commentViewDidComment:(NSString *)comment reply:(NSString *) reply fid:(NSString *) fid rid:(NSString *)rid;
- (void)loadCommentBtnState;
@end

@interface BRCommentView : BasePopupView

@property (nonatomic, weak) id<BRCommentViewDelegate> delegate;
@property (nonatomic, strong) NSString *sendColor;
//comment 评论 ; reply 回复
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *rid;

@property (nonatomic, strong) NSString *replyName;


@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *memoryString;
@end