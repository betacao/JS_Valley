//
//  SHGActionManager.m
//  Finance
//
//  Created by changxicao on 15/11/19.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionManager.h"

@implementation SHGActionManager

+ (instancetype)shareActionManager
{
    static SHGActionManager *shareManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

//加载活动详情
- (void)loadActionDetail:(SHGActionObject *)object finishBlock:(void (^)(NSArray *))block
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/meetingactivity/getMeetingActivityById"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSDictionary *param = @{@"meetId":object.meetId, @"uid":uid};
    [MOCHTTPRequestOperationManager postWithURL:request class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSArray *array = [NSArray arrayWithObject:response.dataDictionary];
        array = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:array class:[SHGActionObject class]];
        if (block) {
            block(array);
        }
        [Hud hideHud];
    } failed:^(MOCHTTPResponse *response) {
        if (block) {
            block(nil);
        }
        [Hud hideHud];
        [Hud showMessageWithText:@"获取活动详情失败"];
    }];
}

- (void)loadUserPermissionState:(void (^)(NSString *))block
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/meetingactivity/isCreateMeetingActivity"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSDictionary *param = @{@"uid":uid};
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        NSString *state = [response.dataDictionary objectForKey:@"createflag"];
        if (block) {
            block(state);
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"获取用户权限失败"];
    }];
}
//新建活动
- (void)createNewAction:(NSDictionary *)param finishBlock:(void (^)(BOOL))block
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/meetingactivity/saveMeetingActivity"];
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud showMessageWithLongText:@"提交成功，大牛圈会在一个工作日内完成审核"];
        if (block) {
            block(YES);
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:@"提交失败"];
        if (block) {
            block(NO);
        }
    }];
}

//修改活动
- (void)modifyAction:(NSDictionary *)param finishBlock:(void (^)(BOOL))block
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/meetingactivity/editMeetingActivity"];
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud showMessageWithLongText:@"提交成功，大牛圈会在一个工作日内完成审核"];
        if (block) {
            block(YES);
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:@"提交失败"];
        if (block) {
            block(NO);
        }
    }];
}

//点赞
- (void)addPraiseWithObject:(SHGActionObject *)object finishBlock:(void (^)(BOOL))block
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/meetingactivity/praise/savePraise"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSDictionary *param = @{@"uid":uid, @"meetId":object.meetId};
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"点赞成功"];
        if (block) {
            object.praiseNum = [NSString stringWithFormat:@"%ld",(long)[object.praiseNum integerValue] + 1];
            object.isPraise = @"Y";
            praiseOBj *obj = [[praiseOBj alloc] init];
            obj.pnickname = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
            obj.ppotname = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_HEAD_IMAGE];
            obj.puserid =[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
            [object.praiseList addObject:obj];
            block(YES);
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"点赞失败"];
        if (block) {
            block(NO);
        }
    }];
}

//取消点赞
- (void)deletePraiseWithObject:(SHGActionObject *)object finishBlock:(void (^)(BOOL))block
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/meetingactivity/praise/deletePraise"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSDictionary *param = @{@"uid":uid, @"meetId":object.meetId};
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"取消点赞成功"];
        if (block) {
            object.praiseNum = [NSString stringWithFormat:@"%ld",(long)[object.praiseNum integerValue] - 1];
            object.isPraise = @"N";
            for (praiseOBj *obj in object.praiseList) {
                if ([obj.puserid isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID]]) {
                    [object.praiseList removeObject:obj];
                    break;
                }
            }
            block(YES);
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"取消点赞失败"];
        if (block) {
            block(NO);
        }
    }];
}

//评论
- (void)addCommentWithObject:(SHGActionObject *)object content:(NSString *)content toOther:(NSString *)otherId finishBlock:(void (^)(BOOL))block
{
    if (!otherId) {
        otherId = @"-1";
    }
    if (!content) {
        content = @"";
    }
    SHGActionCommentObject *targetCommentObject = nil;
    for (SHGActionCommentObject *obj in object.commentList) {
        if ([obj.commentUserId isEqualToString:otherId]) {
            targetCommentObject = obj;
            break;
        }
    }
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/meetingactivity/comment/saveComments"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
    NSDictionary *param = @{@"uid":uid, @"meetId":object.meetId, @"content":content, @"replyId":otherId};
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        SHGActionCommentObject *newObject = [[SHGActionCommentObject alloc] init];
        newObject.commentDetail = content;
        newObject.commentId = [response.dataDictionary objectForKey:@"commentid"];
        newObject.commentOtherName = targetCommentObject.commentUserName;
        newObject.commentUserId = uid;
        newObject.commentUserName = userName;
        [object.commentList addObject:newObject];
        [Hud showMessageWithText:@"评论成功"];
        if (block) {
            block(YES);
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"评论失败"];
        if (block) {
            block(NO);
        }
    }];
}

//删除评论
- (void)deleteCommentWithID:(NSString *)commentId finishBlock:(void (^)(BOOL))block
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/meetingactivity/comment/deleteComments"];
    NSDictionary *param = @{@"commentId":commentId};
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"删除评论成功"];
        if (block) {
            block(YES);
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"删除评论失败"];
        if (block) {
            block(NO);
        }
    }];
}

//参加活动
- (void)enterForActionObject:(SHGActionObject *)object finishBlock:(void (^)(BOOL))block
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/meetingactivity/attend/saveAttend"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSDictionary *param = @{@"meetId":object.meetId, @"uid":uid};
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"报名成功"];
        if (block) {
            block(YES);
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"报名失败"];
        if (block) {
            block(NO);
        }
    }];
}

//用户审核其他用户参与状态
- (void)userCheckOtherState:(SHGActionAttendObject *)object option:(NSString *)option reason:(NSString *)reason finishBlock:(void (^)(BOOL))block
{
    //没写完
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/meetingactivity/attend/auditMeeActAttend"];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary: @{@"meetAttendId":object.meetattendid, @"state":option}];
    if (reason) {
        [param setObject:reason forKey:@"reason"];
    }
    object.state = @"1";
    block(YES);
    return;
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"操作成功"];
        if (block) {
            object.state = @"1";
            block(YES);
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"操作失败"];
        if (block) {
            block(NO);
        }
    }];
}

//分享活动
- (void)shareAction:(SHGActionObject *)object finishBlock:(void (^)(BOOL))block
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/share/meetActDetail"];
    NSDictionary *param = @{@"rid":object.meetId};
    [MOCHTTPRequestOperationManager getWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"分享成功"];
        if (block) {
            block(YES);
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"分享失败"];
        if (block) {
            block(NO);
        }
    }];
}

@end
