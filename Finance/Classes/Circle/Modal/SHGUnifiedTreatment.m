//
//  SHGUnifiedTreatment.m
//  Finance
//
//  Created by changxicao on 15/11/4.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGUnifiedTreatment.h"
#import "LinkViewController.h"
#import "SHGSegmentController.h"
#import "RecmdFriendObj.h"
#import "SHGNewsViewController.h"
#import "SHGPersonalViewController.h"

@implementation SHGUnifiedTreatment


+ (instancetype)sharedTreatment
{
    static SHGUnifiedTreatment *sharedGlobleInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGlobleInstance = [[self alloc] init];
    });
    return sharedGlobleInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smsShareSuccess:) name:NOTIFI_CHANGE_SHARE_TO_SMSSUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smsShareSuccess:) name:NOTIFI_CHANGE_SHARE_TO_FRIENDSUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attentionChanged:) name:NOTIFI_COLLECT_COLLECT_CLIC object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentsChanged:) name:NOTIFI_COLLECT_COMMENT_CLIC object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseChanged:) name:NOTIFI_COLLECT_PRAISE_CLICK object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareChanged:) name:NOTIFI_COLLECT_SHARE_CLIC object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteChanged:) name:NOTIFI_COLLECT_DELETE_CLICK object:nil];
    }
    return self;
}

#pragma mark -删除
- (void)deleteClicked:(CircleListObj *)obj
{
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"确认删除吗?" leftButtonTitle:@"取消" rightButtonTitle:@"删除"];
    __weak typeof(self)weakSelf = self;
    alert.rightBlock = ^{
        [weakSelf deletepostWithObj:obj];
    };
    [alert show];
}

- (void)deletepostWithObj:(CircleListObj *)obj
{
    __weak typeof(self)weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"circle"];
    NSDictionary *dic = @{@"rid":obj.rid, @"uid":obj.userid};
    [[AFHTTPRequestOperationManager manager] DELETE:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"%@",responseObject);
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"]){
            [MobClick event:@"ActionDeletepost" label:@"onClick"];
            [weakSelf detailDeleteWithRid:obj.rid];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         [Hud showMessageWithText:error.domain];
     }];
}

#pragma mark -点击查看更多
- (void)moreMessageClicked:(CircleListObj *)obj
{
    if([obj.postType isEqualToString:@"pc"]){
        NSLog(@"1111");
        LinkViewController *controller = [[LinkViewController alloc] init];
        controller.url = obj.pcurl;
        [[SHGSegmentController sharedSegmentController].selectedViewController.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark -点赞
- (void)praiseClicked:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"praisesend"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],@"rid":obj.rid};
    if (![obj.ispraise isEqualToString:@"Y"]){
        [Hud showLoadingWithMessage:@"正在点赞"];
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response){
            NSLog(@"%@",response.data);
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                NSArray *array = [[SHGSegmentController sharedSegmentController] targetObjectsByRid:obj.rid];
                for (CircleListObj *object in array) {
                    object.ispraise = @"Y";
                    object.praisenum = [NSString stringWithFormat:@"%ld",(long)([object.praisenum integerValue] + 1)];
                }
                [Hud showMessageWithText:@"赞成功"];
            }
            [MobClick event:@"ActionPraiseClicked_On" label:@"onClick"];
            [[SHGSegmentController sharedSegmentController] reloadData];
            [Hud hideHud];
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
    } else{
        [Hud showLoadingWithMessage:@"正在取消点赞"];
        [[AFHTTPRequestOperationManager manager] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                NSArray *array = [[SHGSegmentController sharedSegmentController] targetObjectsByRid:obj.rid];
                for (CircleListObj *object in array) {
                    object.ispraise = @"N";
                    object.praisenum = [NSString stringWithFormat:@"%ld",(long)([object.praisenum integerValue] - 1)];
                }
                [Hud showMessageWithText:@"取消点赞"];
            }
            [MobClick event:@"ActionPraiseClicked_Off" label:@"onClick"];
            [[SHGSegmentController sharedSegmentController] reloadData];
            [Hud hideHud];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Hud showMessageWithText:error.domain];
            [Hud hideHud];
        }];
    }

}

#pragma mark -点击个人头像
- (void)headTap:(NSInteger)index
{
    CircleListObj *obj = [[SHGSegmentController sharedSegmentController] targetObjectByIndex:index];
    [self gotoSomeOne:obj.userid name:obj.nickname];
}

#pragma mark -评论
- (void)clicked:(NSInteger )index;
{
    CircleDetailViewController *vc = [[CircleDetailViewController alloc] initWithNibName:@"CircleDetailViewController" bundle:nil];
    CircleListObj *obj = [[SHGSegmentController sharedSegmentController] targetObjectByIndex:index];
    vc.hidesBottomBarWhenPushed = YES;
    vc.rid = obj.rid;
    vc.delegate = self;
    [[SHGSegmentController sharedSegmentController].selectedViewController.navigationController pushViewController:vc animated:YES];
}



#pragma mark -分享
- (void)shareClicked:(CircleListObj *)obj
{
    UIImage *png = [UIImage imageNamed:@"80.png"];
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:png];
    NSString *postContent;
    NSString *shareContent;

    NSString *shareTitle ;
    if (IsStrEmpty(obj.detail)) {
        postContent = SHARE_CONTENT;
        shareTitle = SHARE_TITLE;
        shareContent = SHARE_CONTENT;
    } else{
        postContent = obj.detail;
        shareTitle = obj.detail;
        shareContent = obj.detail;
    }
    if (obj.detail.length > 15){
        postContent = [NSString stringWithFormat:@"%@…",[obj.detail substringToIndex:15]];
    }
    if (obj.detail.length > 15){
        shareTitle = [obj.detail substringToIndex:15];
        shareContent = [NSString stringWithFormat:@"%@…",[obj.detail substringToIndex:15]];
    }
    NSString *content = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我在金融大牛圈上看到了一个非常棒的帖子,关于",postContent,@"，赶快下载大牛圈查看吧！",[NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,obj.rid]];

    id<ISSShareActionSheetItem> item1 = [ShareSDK shareActionSheetItemWithTitle:@"动态" icon:[UIImage imageNamed:@"圈子图标"] clickHandler:^{
        [self circleShareWithObj:obj];
    }];

    id<ISSShareActionSheetItem> item2 = [ShareSDK shareActionSheetItemWithTitle:@"圈内好友" icon:[UIImage imageNamed:@"圈内好友图标"] clickHandler:^{
        [self shareToFriendWithObj:obj];
    }];

    id<ISSShareActionSheetItem> item3 = [ShareSDK shareActionSheetItemWithTitle:@"短信" icon:[UIImage imageNamed:@"sns_icon_19"] clickHandler:^{
        [self shareToSMS:content rid:obj.rid];
    }];

    id<ISSShareActionSheetItem> item4 = [ShareSDK shareActionSheetItemWithTitle:@"朋友圈" icon:[UIImage imageNamed:@"sns_icon_23"] clickHandler:^{
        [[AppDelegate currentAppdelegate]wechatShare:obj shareType:1];
    }];
    id<ISSShareActionSheetItem> item5 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友" icon:[UIImage imageNamed:@"sns_icon_22"] clickHandler:^{
        [[AppDelegate currentAppdelegate]wechatShare:obj shareType:0];
    }];
    NSArray *shareArray = nil;
    if ([WXApi isWXAppSupportApi]) {
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: item3, item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), item1,item2,nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item3, item5, item4, item1,item2,nil];
        }
    } else{
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: item3, SHARE_TYPE_NUMBER(ShareTypeQQ), item1,item2,nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item3, item1,item2,nil];
        }
    }
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,obj.rid];

    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareContent defaultContent:shareContent image:image title:SHARE_TITLE url:shareUrl description:shareContent mediaType:SHARE_TYPE];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:[SHGSegmentController sharedSegmentController].selectedViewController.view arrowDirect:UIPopoverArrowDirectionUp];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:shareArray content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess){
            [self otherShareWithObj:obj];
            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
        } else if (state == SSResponseStateFail){
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
        }
    }];

}

- (void)shareFeedhtmlString:(NSString *)url
{
    UIImage *png = [UIImage imageNamed:@"80.png"];
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:png];
//    NSString *shareTitle = SHARE_TITLE;

    id<ISSShareActionSheetItem> item4 = [ShareSDK shareActionSheetItemWithTitle:@"朋友圈" icon:[UIImage imageNamed:@"sns_icon_23"] clickHandler:^{
        [[AppDelegate currentAppdelegate] wechatShareWithText:@"大牛圈推广" shareUrl:url shareType:1];
    }];
    id<ISSShareActionSheetItem> item5 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友" icon:[UIImage imageNamed:@"sns_icon_22"] clickHandler:^{
         [[AppDelegate currentAppdelegate] wechatShareWithText:@"大牛圈推广" shareUrl:url shareType:0];
    }];
    NSArray *shareArray = nil;
    if ([WXApi isWXAppSupportApi]) {
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item5, item4, nil];
        }
    } else{
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: SHARE_TYPE_NUMBER(ShareTypeQQ), nil];
        }
    }
    if (!shareArray) {
        return;
    }
    NSString *shareUrl = url;

    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"大牛圈推广" defaultContent:@"大牛圈推广" image:image title:SHARE_TITLE url:shareUrl description:@"大牛圈推广" mediaType:SHARE_TYPE];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:[SHGSegmentController sharedSegmentController].selectedViewController.view arrowDirect:UIPopoverArrowDirectionUp];

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
- (void)shareToFriendWithObj:(CircleListObj *)obj
{
    NSString *shareText = [NSString stringWithFormat:@"转自:%@的帖子：%@",obj.nickname,obj.detail];
    FriendsListViewController *vc=[[FriendsListViewController alloc] init];
    vc.isShare = YES;
    vc.shareRid = obj.rid;
    vc.shareContent = shareText;
    [[SHGSegmentController sharedSegmentController].selectedViewController.navigationController pushViewController:vc animated:YES];
}
//动态分享
- (void)circleShareWithObj:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *cityName = [SHGGloble sharedGloble].cityName;
    if(!cityName){
        cityName = @"";
    }
    NSDictionary *param = @{@"uid":uid,@"currCity":cityName};

    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response){
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]){
            NSArray *array = [[SHGSegmentController sharedSegmentController] targetObjectsByRid:obj.rid];
            for (CircleListObj *object in array){
                object.sharenum = [NSString stringWithFormat:@"%ld",(long)([object.sharenum integerValue] + 1)];
            }
            [[SHGSegmentController sharedSegmentController] refreshHomeView];
            [[SHGSegmentController sharedSegmentController] reloadData];
            [Hud showMessageWithText:@"分享成功"];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
}

//圈内好友分享
- (void)otherShareWithObj:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [[AFHTTPRequestOperationManager manager] PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            NSArray *array = [[SHGSegmentController sharedSegmentController] targetObjectsByRid:obj.rid];
            for (CircleListObj *object in array){
                object.sharenum = [NSString stringWithFormat:@"%ld",(long)([object.sharenum integerValue] + 1)];
            }
            [[SHGSegmentController sharedSegmentController] reloadData];
            [MobClick event:@"ActionShareClicked" label:@"onClick"];
            [Hud showMessageWithText:@"分享成功"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Hud showMessageWithText:error.domain];

    }];
}

//短信分享
- (void)shareToSMS:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendSmsWithText:text rid:rid];
}

//微博分享
- (void)shareToWeibo:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendmessageToShareWithObjContent:text rid:rid];
}

- (void)smsShareSuccess:(NSNotification *)noti
{
    NSInteger count = [[SHGSegmentController sharedSegmentController].selectedViewController.navigationController viewControllers].count;
    for (NSInteger index = count - 1; index >= 0; index--){
        UIViewController *controller = [[[SHGSegmentController sharedSegmentController].selectedViewController.navigationController viewControllers] objectAtIndex:index];
        if([controller respondsToSelector:@selector(smsShareSuccess:)]){
            [controller performSelector:@selector(smsShareSuccess:) withObject:noti];
            return;
        }
    }
    id obj = noti.object;
    if ([obj isKindOfClass:[NSString class]]){
        NSString *rid = obj;
        NSArray *array = [[SHGSegmentController sharedSegmentController] targetObjectsByRid:rid];
        //这边只调用一次 下面的方法中会分开处理
        [self otherShareWithObj:[array firstObject]];
    }
}

#pragma mark -关注
- (void)attentionClicked:(CircleListObj *)obj
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    if([obj isKindOfClass:[CircleListObj class]]){
        //普通好友加关注的方法
        NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends"];
        NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID], @"oid":obj.userid};
        if (![obj.isattention isEqualToString:@"Y"]) {
            [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
                [Hud hideHud];
                NSString *code = [response.data valueForKey:@"code"];
                if ([code isEqualToString:@"000"]) {
                    NSArray *array = [[SHGSegmentController sharedSegmentController] targetObjectsByUserID:obj.userid];
                    for (CircleListObj *cobj in array) {
                        cobj.isattention = @"Y";
                    }
                    [[SHGSegmentController sharedSegmentController] refreshAttaionView];
                    [MobClick event:@"ActionAttentionClicked" label:@"onClick"];
                    [Hud showMessageWithText:@"关注成功"];
                } else{
                    [Hud showMessageWithText:@"关注失败"];
                }
                [[SHGSegmentController sharedSegmentController] reloadData];
            } failed:^(MOCHTTPResponse *response) {
                [Hud hideHud];
                [Hud showMessageWithText:response.errorMessage];
            }];
        } else{
            [[AFHTTPRequestOperationManager manager] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [Hud hideHud];
                NSString *code = [responseObject valueForKey:@"code"];
                if ([code isEqualToString:@"000"]) {
                    NSArray *array = [[SHGSegmentController sharedSegmentController] targetObjectsByUserID:obj.userid];
                    for (CircleListObj *cobj in array) {
                        cobj.isattention = @"N";
                    }

                    //在关注界面的时候要移除掉
                    NSMutableArray *removeArr = [NSMutableArray array];
                    for (CircleListObj *cobj in array) {
                        [removeArr addObject:cobj];
                    }
                    [[SHGSegmentController sharedSegmentController] removeObjects:removeArr];

                    [MobClick event:@"ActionAttentionClickedFalse" label:@"onClick"];
                    [Hud showMessageWithText:@"取消关注成功"];
                    [[SHGSegmentController sharedSegmentController] reloadData];
                } else{
                    [Hud showMessageWithText:@"取消关注失败"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Hud hideHud];
                [Hud showMessageWithText:error.domain];
            }];
        }
    } else{
        //这个是推荐栏目加关注的方法 因为不是同一个类 不得已多写一个else
        RecmdFriendObj *friend = (RecmdFriendObj *)obj;
        if(!friend.uid || friend.uid.length == 0){
            [Hud showMessageWithText:@"暂未获取到此用户的ID"];
            return;
        }
        NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends"];
        NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID], @"oid":friend.uid};
        if(!friend.isFocus){
            [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
                [Hud hideHud];
                NSString *code = [response.data valueForKey:@"code"];
                if ([code isEqualToString:@"000"]) {
                    friend.isFocus = YES;
                    [MobClick event:@"ActionAttentionClicked" label:@"onClick"];
                    [Hud showMessageWithText:@"关注成功"];
                } else{
                    [Hud showMessageWithText:@"关注失败"];
                }
                [[SHGSegmentController sharedSegmentController] reloadData];
            } failed:^(MOCHTTPResponse *response) {
                [Hud hideHud];
                [Hud showMessageWithText:response.errorMessage];
            }];
        } else{
            [[AFHTTPRequestOperationManager manager] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [Hud hideHud];
                NSString *code = [responseObject valueForKey:@"code"];
                if ([code isEqualToString:@"000"]) {
                    friend.isFocus = NO;
                    [MobClick event:@"ActionAttentionClickedFalse" label:@"onClick"];
                    [Hud showMessageWithText:@"取消关注成功"];
                    [[SHGSegmentController sharedSegmentController] reloadData];
                } else{
                    [Hud hideHud];
                    [Hud showMessageWithText:@"取消关注失败"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Hud showMessageWithText:error.domain];
            }];
        }
    }

}

#pragma mark -详情界面的代理
- (void)detailDeleteWithRid:(NSString *)rid
{
    NSArray *array = [[SHGSegmentController sharedSegmentController] targetObjectsByRid:rid];
    for (CircleListObj *obj in array){
        [[SHGSegmentController sharedSegmentController] removeObject:obj];
        [[SHGSegmentController sharedSegmentController] removeObject:obj];
        [[SHGSegmentController sharedSegmentController] reloadData];
    }
}

- (void)detailPraiseWithRid:(NSString *)rid praiseNum:(NSString *)num isPraised:(NSString *)isPrased
{
    NSArray *array = [[SHGSegmentController sharedSegmentController] targetObjectsByRid:rid];
    for (CircleListObj *obj in array){
        obj.praisenum = num;
        obj.ispraise = isPrased;

    }
    [[SHGSegmentController sharedSegmentController] reloadData];
}

- (void)detailShareWithRid:(NSString *)rid shareNum:(NSString *)num
{
    NSArray *array = [[SHGSegmentController sharedSegmentController] targetObjectsByRid:rid];
    for (CircleListObj *obj in array){
        obj.sharenum = num;
    }
    [[SHGSegmentController sharedSegmentController] reloadData];
    [[SHGSegmentController sharedSegmentController] refreshHomeView];
}

- (void)detailAttentionWithRid:(NSString *)rid attention:(NSString *)atten
{
    NSArray *array = [[SHGSegmentController sharedSegmentController] targetObjectsByUserID:rid];
    for (CircleListObj *obj in array){
        obj.isattention = atten;
    }
    [[SHGSegmentController sharedSegmentController] reloadData];
}

- (void)detailCommentWithRid:(NSString *)rid commentNum:(NSString*)num comments:(NSMutableArray *)comments
{
    NSArray *array = [[SHGSegmentController sharedSegmentController] targetObjectsByRid:rid];
    for (CircleListObj *obj in array){
        obj.cmmtnum = num;
        obj.comments = comments;
    }
    [[SHGSegmentController sharedSegmentController] reloadData];
}

- (void)gotoSomeOne:(NSString *)uid name:(NSString *)name
{
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    controller.userId = uid;
    controller.delegate = self;
    [[SHGSegmentController sharedSegmentController].selectedViewController.navigationController pushViewController:controller animated:YES];
}

- (void)cnickCLick:(NSString * )userId name:(NSString *)name
{
    [self gotoSomeOne:userId name:name];
}

- (void)attentionChanged:(NSNotification *)noti
{
    CircleListObj *obj = noti.object;
    [self detailAttentionWithRid:obj.userid attention:obj.isattention];
}

- (void)commentsChanged:(NSNotification *)noti
{
    CircleListObj *obj = noti.object;
    [self detailCommentWithRid:obj.rid commentNum:obj.cmmtnum comments:obj.comments];
}


- (void)praiseChanged:(NSNotification *)noti
{
    CircleListObj *obj = noti.object;
    [self detailPraiseWithRid:obj.rid praiseNum:obj.praisenum isPraised:obj.ispraise];
}

- (void)shareChanged:(NSNotification *)noti
{
    CircleListObj *obj = noti.object;
    [self detailShareWithRid:obj.rid shareNum:obj.sharenum];
}

- (void)deleteChanged:(NSNotification *)noti
{
    CircleListObj *obj = noti.object;
    [self detailDeleteWithRid:obj.rid];
}

//获得详情后如果存在数据更新则在首页进行更新
- (void)detailHomeListShouldRefresh:(CircleListObj *)currentObj
{
    NSArray *array = [[SHGSegmentController sharedSegmentController] targetObjectsByRid:currentObj.rid];
    NSArray *indexArray = [[SHGSegmentController sharedSegmentController] indexOfObjectByRid:currentObj.rid];
    if(array.count != indexArray.count){
        return;
    }
    NSMutableArray *pathArray = [NSMutableArray array];
    for(CircleListObj *obj in array){
        obj.sharenum = currentObj.sharenum;
        obj.cmmtnum = currentObj.cmmtnum;
        obj.praisenum = currentObj.praisenum;
        NSInteger index = [array indexOfObject:obj];
        NSIndexPath *path = [NSIndexPath indexPathForRow: [[indexArray objectAtIndex: index] integerValue] inSection:0];
        [pathArray addObject:path];
    }

    [[SHGSegmentController sharedSegmentController] reloadDataAtIndexPaths:pathArray];
}

@end
