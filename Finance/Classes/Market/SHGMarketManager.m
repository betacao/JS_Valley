//
//  SHGMarketManager.m
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketManager.h"
#import "SHGMarketObject.h"

@interface SHGMarketManager ()

@property (strong, nonatomic) NSArray *selecetedArray;
@property (strong, nonatomic) NSArray *listArray;
@property (strong, nonatomic) NSArray *totalArray;
@property (strong, nonatomic) NSArray *citysArray;

@end

@implementation SHGMarketManager

+ (instancetype)shareManager
{
    static SHGMarketManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
//大分类
- (void)loadMarketCategoryBlock:(void (^)(void))block
{
    if (!self.totalArray) {
        __weak typeof(self) weakSelf = self;
        NSDictionary *param = @{@"uid":UID};
        NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/getMarketCatalogByUid"];
        [MOCHTTPRequestOperationManager postWithURL:request class:nil parameters:param success:^(MOCHTTPResponse *response) {
            NSDictionary *dictionary = response.dataDictionary;

            weakSelf.listArray = [dictionary objectForKey:@"cataloglist"];
            NSMutableArray *temp = [NSMutableArray arrayWithArray:[dictionary objectForKey:@"definedcatalog"]];
            if (temp.count > 0) {
                [temp addObjectsFromArray:weakSelf.listArray];
                weakSelf.totalArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:temp class:[SHGMarketFirstCategoryObject class]];
            }
            weakSelf.selecetedArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[dictionary objectForKey:@"selectcatalog"] class:[SHGMarketFirstCategoryObject class]] ;
            weakSelf.listArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[dictionary objectForKey:@"cataloglist"] class:[SHGMarketFirstCategoryObject class]];
            block();
        } failed:^(MOCHTTPResponse *response) {
            [Hud showMessageWithText:@"获取业务分类错误"];
        }];
    } else{
        block();
    }
}

- (void)userListArray:(void (^)(NSArray *array))block
{
    [self loadMarketCategoryBlock:^{
        block(self.listArray);
    }];
}

- (void)userSelectedArray:(void (^)(NSArray *array))block
{
    [self loadMarketCategoryBlock:^{
        block(self.selecetedArray);
    }];
}

- (void)userTotalArray:(void (^)(NSArray *array))block
{
    [self loadMarketCategoryBlock:^{
        block(self.totalArray);
    }];
}

- (void)loadHotCitys:(void (^)(NSArray *))block
{
    if (!self.citysArray) {
        __weak typeof(self) weakSelf = self;
        NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/getMarketHotCity"];
        [MOCHTTPRequestOperationManager postWithURL:request class:nil parameters:nil success:^(MOCHTTPResponse *response) {
            NSDictionary *dictionary = response.dataDictionary;
            weakSelf.citysArray = [dictionary objectForKey:@"city"];
            weakSelf.citysArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.citysArray class:[SHGMarketCity class]];
            block(weakSelf.citysArray);
        } failed:^(MOCHTTPResponse *response) {
            [Hud showMessageWithText:@"获取业务分类错误"];
        }];
    } else{
        block(self.citysArray);
    }
}
//列表
+ (void)loadMarketList:(NSDictionary *)param block:(void (^)(NSArray *array))block
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/getMarketList"];
    [MOCHTTPRequestOperationManager postWithURL:request class:[SHGMarketObject class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        block(response.dataArray);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        block(nil);
        [Hud showMessageWithText:@"获取列表数据失败"];
    }];
}
//详情
+ (void)loadMarketDetail:(NSDictionary *)param block:(void (^)(SHGMarketObject *))block
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/getMarketById"];
    [MOCHTTPRequestOperationManager postWithURL:request class:nil parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        NSArray *array = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:@[response.dataDictionary] class:[SHGMarketObject class]];
        block([array firstObject]);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        block(nil);
        [Hud showMessageWithText:@"获取业务详情失败"];
    }];
}

//搜索
+ (void)searchMarketList:(NSDictionary *)param block:(void (^)(NSArray *array))block
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/getMarketList"];
    [MOCHTTPRequestOperationManager postWithURL:request class:[SHGMarketObject class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        block(response.dataArray);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        block(nil);
        [Hud showMessageWithText:@"搜索数据失败"];
    }];
}

//创建新业务
+ (void)createNewMarket:(NSDictionary *)param success:(void (^)(BOOL success))block
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/saveMarket"];
    [MOCHTTPRequestOperationManager postWithURL:request class:[SHGMarketFirstCategoryObject class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"创建业务成功"];
        block(YES);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"创建业务失败"];
    }];
}

//修改业务
+ (void)modifyMarket:(NSDictionary *)param success:(void (^)(BOOL success))block
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/editMarket"];
    [MOCHTTPRequestOperationManager postWithURL:request class:[SHGMarketFirstCategoryObject class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"修改业务成功"];
        block(YES);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"修改业务失败"];
    }];
}

+ (void)deleteMarket:(SHGMarketObject *)object success:(void (^)(BOOL))block
{
    NSDictionary *param = @{@"marketId":object.marketId};
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/deleteMarket"];
    [MOCHTTPRequestOperationManager postWithURL:request class:[SHGMarketFirstCategoryObject class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"删除业务成功"];
        block(YES);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"删除业务失败"];
    }];
}

//赞
+ (void)addPraiseWithObject:(SHGMarketObject *)object finishBlock:(void (^)(BOOL))block
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/praise/savePraise"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSDictionary *param = @{@"uid":uid, @"marketId":object.marketId};
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"点赞成功"];
        if (block) {
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
+ (void)deletePraiseWithObject:(SHGMarketObject *)object finishBlock:(void (^)(BOOL))block
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/praise/deletePraise"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSDictionary *param = @{@"uid":uid, @"marketId":object.marketId};
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"取消点赞成功"];
        if (block) {
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
+ (void)addCommentWithObject:(SHGMarketObject *)object content:(NSString *)content toOther:(NSString *)otherId finishBlock:(void (^)(BOOL))block
{
    if (!otherId) {
        otherId = @"-1";
    }
    if (!content) {
        content = @"";
    }
    SHGMarketCommentObject *targetCommentObject = nil;
    for (SHGMarketCommentObject *obj in object.commentList) {
        if ([obj.commentUserId isEqualToString:otherId]) {
            targetCommentObject = obj;
            break;
        }
    }
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/comment/saveComments"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
    NSDictionary *param = @{@"uid":uid, @"marketId":object.marketId, @"content":content, @"replyId":otherId};
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        SHGMarketCommentObject *newObject = [[SHGMarketCommentObject alloc] init];
        newObject.commentDetail = content;
        newObject.commentId = [response.dataDictionary objectForKey:@"commentid"];
        newObject.commentOtherName = targetCommentObject.commentUserName;
        newObject.commentUserId = uid;
        newObject.commentUserName = userName;
        [object.commentList addObject:newObject];
        object.commentNum = [NSString stringWithFormat:@"%ld",(long)[object.commentNum integerValue] + 1];
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
+ (void)deleteCommentWithID:(NSString *)commentId finishBlock:(void (^)(BOOL))block
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/comment/deleteComments"];
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

//分享业务
- (void)shareAction:(SHGMarketObject *)object baseController:(UIViewController *)controller finishBlock:(void (^)(BOOL))block
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *request = [rBaseAddressForHttp stringByAppendingFormat:@"/share/marketDetail?rid=%@&uid=%@",object.marketId, uid];
    UIImage *png = [UIImage imageNamed:@"80.png"];
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:png];
    NSString *theme = object.marketName;
    if (theme.length > 15) {
        theme = [NSString stringWithFormat:@"%@…",[object.marketName substringToIndex:15]];
    }
    NSString *postContent = [NSString stringWithFormat:@"【业务】%@", theme];
    NSString *shareContent = [NSString stringWithFormat:@"【业务】%@", theme];
    NSString *friendContent = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我看到了一个非常棒的业务,关于",theme,@"，赶快去业务版块查看吧！",request];

    NSString *messageContent = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我在金融大牛圈上看到了一个非常棒的业务,关于",theme,@"，赶快下载大牛圈查看吧！",@"https://itunes.apple.com/cn/app/da-niu-quan-jin-rong-zheng/id984379568?mt=8"];
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

//分享成功后通知服务端+1
+ (void)shareSuccessCallBack:(SHGMarketObject *)object finishBlock:(void (^)(BOOL))block
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/market/shareMarket"];
    NSDictionary *param = @{@"marketId":object.marketId};
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        object.shareNum = [NSString stringWithFormat:@"%ld",(long)[object.shareNum integerValue] + 1];
        if (block) {
            block(YES);
        }
    } failed:^(MOCHTTPResponse *response) {
        if (block) {
            block(NO);
        }
    }];
}


@end
