//
//  SHGUnifiedTreatment.m
//  Finance
//
//  Created by changxicao on 15/11/4.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGUnifiedTreatment.h"
#import "SHGLinkViewController.h"
#import "SHGSegmentController.h"
#import "RecmdFriendObj.h"
#import "SHGPersonalViewController.h"
#import "CCLocationManager.h"
#import "SHGHomeCategoryView.h"

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentsChanged:) name:NOTIFI_COLLECT_COMMENT_CLIC object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareChanged:) name:NOTIFI_COLLECT_SHARE_CLIC object:nil];
    }
    return self;
}

#pragma mark -点击查看更多
- (void)moreMessageClicked:(CircleListObj *)obj
{
    if([obj.postType isEqualToString:@"pc"]){
        NSLog(@"1111");
        SHGLinkViewController *controller = [[SHGLinkViewController alloc] init];
        controller.url = obj.pcurl;
        [[SHGSegmentController sharedSegmentController].selectedViewController.navigationController pushViewController:controller animated:YES];
    }
}


#pragma mark -分享
- (void)shareClicked:(CircleListObj *)obj
{
    UIImage *png = [UIImage imageNamed:@"80.png"];
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:png];
    NSString *postContent = @"";
    NSString *shareContent = @"";
    NSString *title = @" ";
    if (obj.groupPostTitle.length > 0) {
        title = obj.groupPostTitle;
    } else{
        title = SHARE_TITLE;
    }
    
    if(IsStrEmpty(obj.detail)){
        postContent = SHARE_CONTENT;
        shareContent = SHARE_CONTENT;
    } else{
        if(obj.detail.length > 15){
            postContent = [NSString stringWithFormat:@"%@...",[obj.detail substringToIndex:15]];
            shareContent = [NSString stringWithFormat:@"%@...",[obj.detail substringToIndex:15]];
        } else{
            postContent = obj.detail;
            shareContent = obj.detail;
        }
        
    }
    NSString *content = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我在金融大牛圈上看到了一个非常棒的帖子,关于",postContent,@"，赶快下载大牛圈查看吧！",[NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,obj.rid]];

    id<ISSShareActionSheetItem> item1 = [ShareSDK shareActionSheetItemWithTitle:@"动态" icon:[UIImage imageNamed:@"圈子图标"] clickHandler:^{
        [[SHGGloble sharedGloble] recordUserAction:obj.rid type:@"dynamic_shareDynamic"];
        [self circleShareWithObj:obj];
    }];

    id<ISSShareActionSheetItem> item2 = [ShareSDK shareActionSheetItemWithTitle:@"圈内好友" icon:[UIImage imageNamed:@"圈内好友图标"] clickHandler:^{
        [[SHGGloble sharedGloble] recordUserAction:obj.rid type:@"dynamic_shareSystemUser"];
        [self shareToFriendWithObj:obj];
    }];

    id<ISSShareActionSheetItem> item3 = [ShareSDK shareActionSheetItemWithTitle:@"短信" icon:[UIImage imageNamed:@"sns_icon_19"] clickHandler:^{
        [self shareToSMS:content rid:obj.rid];
    }];

    id<ISSShareActionSheetItem> item4 = [ShareSDK shareActionSheetItemWithTitle:@"朋友圈" icon:[UIImage imageNamed:@"sns_icon_23"] clickHandler:^{
        [[SHGGloble sharedGloble] recordUserAction:obj.rid type:@"dynamic_shareMicroCircle"];
        [[AppDelegate currentAppdelegate]wechatShare:obj shareType:1];
    }];
    id<ISSShareActionSheetItem> item5 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友" icon:[UIImage imageNamed:@"sns_icon_22"] clickHandler:^{
         [[SHGGloble sharedGloble] recordUserAction:obj.rid type:@"dynamic_shareMicroFriend"];
        [[AppDelegate currentAppdelegate]wechatShare:obj shareType:0];
    }];
    NSArray *shareArray = nil;
    if ([WXApi isWXAppSupportApi]) {
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), item3, item1,item2,nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item5, item4, item3, item1,item2,nil];
        }
    } else{
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: SHARE_TYPE_NUMBER(ShareTypeQQ), item3, item1,item2,nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item3, item1,item2,nil];
        }
    }
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,obj.rid];

    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareContent defaultContent:shareContent image:image title:title url:shareUrl description:shareContent mediaType:SHARE_TYPE];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:[SHGSegmentController sharedSegmentController].selectedViewController.view arrowDirect:UIPopoverArrowDirectionUp];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:shareArray content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess){
            [self otherShareWithObj:obj];
            [[SHGGloble sharedGloble] recordUserAction:obj.rid type:@"dynamic_shareQQ"];
            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
        } else if (state == SSResponseStateFail){
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
        }
    }];

}

- (void)shareFeedhtmlString:(CircleListObj *)object
{
    UIImage *png = [UIImage imageNamed:@"80.png"];
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:png];
    
    NSString *content = object.shareTitle;
    if (content.length == 0) {
        content = @"大牛圈推广";
    }
    id<ISSShareActionSheetItem> item4 = [ShareSDK shareActionSheetItemWithTitle:@"朋友圈" icon:[UIImage imageNamed:@"sns_icon_23"] clickHandler:^{
        [[AppDelegate currentAppdelegate] wechatShareWithText:content shareUrl:object.feedhtml shareType:1];
    }];
    id<ISSShareActionSheetItem> item5 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友" icon:[UIImage imageNamed:@"sns_icon_22"] clickHandler:^{
         [[AppDelegate currentAppdelegate] wechatShareWithText:content shareUrl:object.feedhtml shareType:0];
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
    NSString *shareUrl = object.feedhtml;
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content defaultContent:content image:image title:SHARE_TITLE url:shareUrl description:content mediaType:SHARE_TYPE];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:[SHGSegmentController sharedSegmentController].selectedViewController.view arrowDirect:UIPopoverArrowDirectionUp];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:shareArray content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess){
            [[SHGGloble sharedGloble] recordUserAction:object.rid type:@"dynamic_shareQQ"];
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
    if ([[SHGGloble sharedGloble].cityName isEqualToString:@""]) {
        [[CCLocationManager shareLocation] getCity:nil];
    }
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
            NSMutableArray *array = [NSMutableArray array];
            [array addObjectsFromArray:[[SHGSegmentController sharedSegmentController] targetObjectsByRid:obj.rid]];
            [array addObjectsFromArray:[[SHGHomeCategoryView sharedCategoryView] targetObjectsByRid:obj.rid]];
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
    NSDictionary *param = @{@"uid":UID};

    [MOCHTTPRequestOperationManager putWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            NSMutableArray *array = [NSMutableArray array];
            [array addObjectsFromArray:[[SHGSegmentController sharedSegmentController] targetObjectsByRid:obj.rid]];
            [array addObjectsFromArray:[[SHGHomeCategoryView sharedCategoryView] targetObjectsByRid:obj.rid]];
            for (CircleListObj *object in array){
                object.sharenum = [NSString stringWithFormat:@"%ld",(long)([object.sharenum integerValue] + 1)];
            }
            [[SHGSegmentController sharedSegmentController] reloadData];
            [MobClick event:@"ActionShareClicked" label:@"onClick"];
            [Hud showMessageWithText:@"分享成功"];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
}

//短信分享
- (void)shareToSMS:(NSString *)text rid:(NSString *)rid
{
     [[SHGGloble sharedGloble] recordUserAction:rid type:@"dynamic_shareSms"];
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
        NSMutableArray *array = [NSMutableArray array];
        [array addObjectsFromArray:[[SHGSegmentController sharedSegmentController] targetObjectsByRid:rid]];
        [array addObjectsFromArray:[[SHGHomeCategoryView sharedCategoryView] targetObjectsByRid:rid]];
        //这边只调用一次 下面的方法中会分开处理
        [self otherShareWithObj:[array firstObject]];
    }
}

- (void)detailShareWithRid:(NSString *)rid shareNum:(NSString *)num
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:[[SHGSegmentController sharedSegmentController] targetObjectsByRid:rid]];
    [array addObjectsFromArray:[[SHGHomeCategoryView sharedCategoryView] targetObjectsByRid:rid]];
    for (CircleListObj *obj in array){
        obj.sharenum = num;
    }
    [[SHGSegmentController sharedSegmentController] reloadData];
    [[SHGSegmentController sharedSegmentController] refreshHomeView];
}

- (void)detailCommentWithRid:(NSString *)rid commentNum:(NSString*)num comments:(NSMutableArray *)comments
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:[[SHGSegmentController sharedSegmentController] targetObjectsByRid:rid]];
    [array addObjectsFromArray:[[SHGHomeCategoryView sharedCategoryView] targetObjectsByRid:rid]];
    for (CircleListObj *obj in array){
        obj.cmmtnum = num;
        if (comments.count > 3) {
            obj.comments = [NSMutableArray arrayWithArray:[comments subarrayWithRange:NSMakeRange(0, 3)]];
        } else {
            obj.comments = comments;
        }
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

- (void)commentsChanged:(NSNotification *)noti
{
    CircleListObj *obj = noti.object;
    [self detailCommentWithRid:obj.rid commentNum:obj.cmmtnum comments:obj.comments];
}

- (void)shareChanged:(NSNotification *)noti
{
    CircleListObj *obj = noti.object;
    [self detailShareWithRid:obj.rid shareNum:obj.sharenum];
}

//获得详情后如果存在数据更新则在首页进行更新
- (void)detailHomeListShouldRefresh:(CircleListObj *)currentObj
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:[[SHGSegmentController sharedSegmentController] targetObjectsByRid:currentObj.rid]];
    [array addObjectsFromArray:[[SHGHomeCategoryView sharedCategoryView] targetObjectsByRid:currentObj.rid]];
    for(CircleListObj *obj in array){
        obj.sharenum = currentObj.sharenum;
        obj.cmmtnum = currentObj.cmmtnum;
        obj.praisenum = currentObj.praisenum;
        obj.comments = currentObj.comments;
    }
    [[SHGSegmentController sharedSegmentController] reloadData];
}

@end
