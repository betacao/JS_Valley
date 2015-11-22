//
//  SHGActionManager.h
//  Finance
//
//  Created by changxicao on 15/11/19.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHGActionObject.h"

@interface SHGActionManager : NSObject

+ (instancetype)shareActionManager;
//获取活动详情
- (void)loadActionDetail:(SHGActionObject *)object finishBlock:(void (^)(NSArray *))block;
//获取用户发活动的权限
- (void)loadUserPermissionState:(void (^)(NSString *))block;
//新建活动
- (void)createNewAction:(NSDictionary *)param finishBlock:(void (^)(BOOL))block;
//修改活动
- (void)modifyAction:(NSDictionary *)param finishBlock:(void (^)(BOOL))block;
//点赞
- (void)addPraiseWithObject:(SHGActionObject *)object finishBlock:(void (^)(BOOL))block;
//取消点赞
- (void)deletePraiseWithObject:(SHGActionObject *)object finishBlock:(void (^)(BOOL))block;
//评论
- (void)addCommentWithObject:(SHGActionObject *)object content:(NSString *)content toOther:(NSString *)otherId finishBlock:(void (^)(BOOL))block;
//删除评论
- (void)deleteCommentWithID:(NSString *)commentId finishBlock:(void (^)(BOOL))block;
//参加活动
- (void)enterForActionObject:(SHGActionObject *)object finishBlock:(void (^)(BOOL))block;
//用户审核其他用户参与状态
- (void)userCheckOtherState:(NSString *)meetAttendId option:(NSString *)option reason:(NSString *)reason finishBlock:(void (^)(BOOL))block;
//分享活动
- (void)shareAction:(SHGActionObject *)object finishBlock:(void (^)(BOOL))block;
@end
