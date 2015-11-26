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
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/meetingactivity/saveMeetingActivity"];
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithLongText:@"提交成功，大牛圈会在一个工作日内完成审核！"];
        if (block) {
            block(YES);
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
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
        if ([[response.dataDictionary objectForKey:@"result"] isEqualToString:@"-2"]) {
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"您当前有活动正在审核中，请等待审核后再提交，谢谢。" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
        } else{
            [Hud showMessageWithLongText:@"提交成功，大牛圈会在一个工作日内完成审核！"];
            if (block) {
                block(YES);
            }
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
- (void)enterForActionObject:(SHGActionObject *)object reason:(NSString *)reason finishBlock:(void (^)(BOOL))block
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/meetingactivity/attend/saveAttend"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSDictionary *param = @{@"meetId":object.meetId, @"uid":uid, @"detail":reason};
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"报名成功，请等待审核"];
        if (block) {
//            SHGActionAttendObject *obj = [[[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:@[response.dataDictionary] class:[SHGActionAttendObject class]] firstObject];
//            [object.attendList addObject:obj];
//            object.attendNum = [NSString stringWithFormat:@"%ld",(long)[object.attendNum integerValue] + 1];
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
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"已同意"];
        if (block) {
            if ([option isEqualToString:@"0"]) {
                //驳回
                object.state = @"2";
            } else{
                //同意
                object.state = @"1";
            }
            block(YES);
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"已驳回"];
        if (block) {
            block(NO);
        }
    }];
}

//分享活动
- (void)shareAction:(SHGActionObject *)object baseController:(UIViewController *)controller finishBlock:(void (^)(BOOL))block
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *request = [rBaseAddressForHttp stringByAppendingFormat:@"/share/meetActDetail?rid=%@&uid=%@",object.meetId, uid];
    UIImage *png = [UIImage imageNamed:@"80.png"];
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:png];
    NSString *theme = object.theme;
    if (theme.length > 15) {
        theme = [NSString stringWithFormat:@"%@…",[object.theme substringToIndex:15]];
    }
    NSString *postContent = [NSString stringWithFormat:@"【活动】%@", theme];
    NSString *shareContent = [NSString stringWithFormat:@"【活动】%@", theme];
    NSString *friendContent = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我看到了一个非常棒的活动,关于",theme,@"，赶快去活动版块查看吧！",request];

    NSString *messageContent = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我在金融大牛圈上看到了一个非常棒的活动,关于",theme,@"，赶快下载大牛圈查看吧！",@"https://itunes.apple.com/cn/app/da-niu-quan-jin-rong-zheng/id984379568?mt=8"];
    id<ISSShareActionSheetItem> item0 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友" icon:[UIImage imageNamed:@"sns_icon_22"] clickHandler:^{
        [[AppDelegate currentAppdelegate] shareActionToWeChat:0 content:postContent url:request];
    }];
    id<ISSShareActionSheetItem> item1 = [ShareSDK shareActionSheetItemWithTitle:@"朋友圈" icon:[UIImage imageNamed:@"sns_icon_23"] clickHandler:^{
        [[AppDelegate currentAppdelegate] shareActionToWeChat:1 content:postContent url:request];
    }];
    id<ISSShareActionSheetItem> item2 = [ShareSDK shareActionSheetItemWithTitle:@"短信" icon:[UIImage imageNamed:@"sns_icon_19"] clickHandler:^{
        [[AppDelegate currentAppdelegate] shareActionToSMS:messageContent];
    }];
    id<ISSShareActionSheetItem> item3 = [ShareSDK shareActionSheetItemWithTitle:@"圈内好友" icon:[UIImage imageNamed:@"圈内好友图标"] clickHandler:^{
        [self shareToFriendController:controller content:friendContent];
    }];
    NSArray *shareArray = nil;
    if ([WXApi isWXAppSupportApi]) {
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: item0, item1, SHARE_TYPE_NUMBER(ShareTypeQQ), item2, item3, nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item0, item1, item2, item3, nil];
        }
    } else{
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: SHARE_TYPE_NUMBER(ShareTypeQQ), item2, item3, nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item2, item3, nil];
        }
    }
    NSString *shareUrl = request;

    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareContent defaultContent:shareContent image:image title:SHARE_TITLE url:shareUrl description:shareContent mediaType:SHARE_TYPE];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:controller.view arrowDirect:UIPopoverArrowDirectionUp];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:shareArray content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess){
            [Hud showMessageWithText:@"分享成功"];
        } else if (state == SSResponseStateFail){
            [Hud showMessageWithText:@"分享失败"];
        }
    }];
}

//分享给好友
- (void)shareToFriendController:(UIViewController *)controller content:(NSString *)content
{
    FriendsListViewController *vc = [[FriendsListViewController alloc] init];
    vc.isShare = YES;
    vc.shareContent = content;
    [controller.navigationController pushViewController:vc animated:YES];
}

@end
