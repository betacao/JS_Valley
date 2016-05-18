//
//  SHGBusinessManager.m
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessManager.h"
#import "SHGBusinessObject.h"
#import "SHGBusinessScrollView.h"
#import "SHGBusinessListViewController.h"
#import "SHGBusinessDetailViewController.h"
#import "SHGBusinessSendSuccessViewController.h"
@interface SHGBusinessManager()
@property (strong, nonatomic) NSArray *secondListArray;
@property (strong, nonatomic) NSArray *trademixedArray;//同业混业
@property (strong, nonatomic) NSArray *bondFinancingArray;
@property (strong, nonatomic) NSArray *moneySideArray;
@property (strong, nonatomic) NSArray *equityFinancingArray;
@property (strong, nonatomic) NSString *cityName;
@end
@implementation SHGBusinessManager

+ (instancetype)shareManager
{
    static SHGBusinessManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)clearCache
{
    self.secondListArray = @[];
    [[SHGBusinessListViewController sharedController] clearCache];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"cityName" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"cityName"]) {
        NSString *newValue = [change objectForKey:@"new"];
        [SHGBusinessListViewController sharedController].cityName = newValue;
    }
}

//创建新业务
+ (void)createNewBusiness:(NSDictionary *)param success:(void (^)(BOOL ,NSString *))block
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/business/saveBusiness"];
    [MOCHTTPRequestOperationManager postWithURL:request class:[SHGBusinessObject class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        //[Hud showMessageWithText:@"发布业务成功"];
        
        NSDictionary *dictionary = response.dataDictionary;
        NSLog(@"zzzzz%@",dictionary);
        NSString *businessId = [dictionary objectForKey:@"result"];
        block(YES,businessId);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"发布业务失败"];
    }];
}

+ (void)editBusiness:(NSDictionary *)param success:(void (^)(BOOL ))block
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/business/editBusiness"];
    [MOCHTTPRequestOperationManager postWithURL:request class:[SHGBusinessObject class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"修改业务成功"];
        block(YES);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"修改业务失败"];
    }];

}
//列表
+ (void)getListDataWithParam:(NSDictionary *)param block:(void (^)(NSArray *, NSString *, NSString *, NSString *))block
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/business/getBusinessList"] class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSDictionary *dictionary = response.dataDictionary;

        NSArray *dataArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[dictionary objectForKey:@"businesslist"] class:[SHGBusinessObject class]];
        NSString *positon = [dictionary objectForKey:@"position"];
        NSString *tipUrl = [dictionary objectForKey:@"tipurl"];
        NSString *cfData = [dictionary objectForKey:@"cfdata"];
        block(dataArray, positon, tipUrl, cfData);
    } failed:^(MOCHTTPResponse *response) {
        block(nil, nil, nil, nil);
        [Hud showMessageWithText:@"获取列表数据失败"];
    }];
}
//二级分类
- (void)getSecondListBlock:(void (^)(NSArray *, NSString *))block
{
    __weak typeof(self) weakSelf = self;
    if (self.secondListArray.count > 0) {
        NSInteger index = [[SHGBusinessScrollView sharedBusinessScrollView] currentIndex] == 0 ? 1 : [[SHGBusinessScrollView sharedBusinessScrollView] currentIndex];
        NSArray *array = [NSArray arrayWithArray:[self.secondListArray objectAtIndex:index - 1]];
        if (block) {
            block(array, self.cityName);
        }
    } else {
        [Hud showWait];
        [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/business/getBusinessCondition"] parameters:@{@"uid":UID} success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            weakSelf.trademixedArray = [response.dataDictionary objectForKey:@"trademixed"];
            weakSelf.bondFinancingArray = [response.dataDictionary objectForKey:@"bondfinancing"];
            weakSelf.moneySideArray = [response.dataDictionary objectForKey:@"moneyside"];
            weakSelf.equityFinancingArray = [response.dataDictionary objectForKey:@"equityfinancing"];
            weakSelf.cityName = [response.dataDictionary objectForKey:@"areaname"];

            weakSelf.trademixedArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.trademixedArray class:[SHGBusinessSecondObject class]];
            weakSelf.bondFinancingArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.bondFinancingArray class:[SHGBusinessSecondObject class]];
            weakSelf.moneySideArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.moneySideArray class:[SHGBusinessSecondObject class]];
            weakSelf.equityFinancingArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.equityFinancingArray class:[SHGBusinessSecondObject class]];

            weakSelf.secondListArray = @[weakSelf.bondFinancingArray, weakSelf.equityFinancingArray, weakSelf.moneySideArray, weakSelf.trademixedArray];

            NSInteger index = [[SHGBusinessScrollView sharedBusinessScrollView] currentIndex] == 0 ? 1 : [[SHGBusinessScrollView sharedBusinessScrollView] currentIndex];
            NSArray *array = [NSArray arrayWithArray:[self.secondListArray objectAtIndex:index - 1]];

            if (block) {
                block(array, weakSelf.cityName);
            }
            [Hud hideHud];
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:@"获取分类错误"];
        }];
    }
}

+ (void)deleteBusiness:(SHGBusinessObject *)object success:(void (^)(BOOL))block
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/business/deleteBusiness"] parameters:@{@"businessId": object.businessID, @"type":object.type} success:^(MOCHTTPResponse *response) {
        NSString *result = [response.dataDictionary objectForKey:@"result"];
        if (!IsStrEmpty(result) && [result integerValue] > 0) {
            block(YES);
        } else {
            block(NO);
        }
    } failed:^(MOCHTTPResponse *response) {
        block(NO);
    }];
}

+ (void)collectBusiness:(SHGBusinessObject *)object success:(void (^)(BOOL))block
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/business/collection/saveBusinessCollect"] parameters:@{@"uid":UID, @"businessId": object.businessID, @"type":object.type} success:^(MOCHTTPResponse *response) {
        NSString *result = [response.dataDictionary objectForKey:@"result"];
        if (!IsStrEmpty(result) && [result integerValue] > 0) {
            block(YES);
            [[SHGGloble sharedGloble] recordUserAction:[NSString stringWithFormat:@"%@#%@", object.businessID, object.type] type:@"business_collect"];
        } else {
            block(NO);
        }
    } failed:^(MOCHTTPResponse *response) {
        block(NO);
    }];
}

+ (void)unCollectBusiness:(SHGBusinessObject *)object success:(void (^)(BOOL))block
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/business/collection/deleteBusinessCollect"] parameters:@{@"uid":UID, @"businessId": object.businessID, @"type":object.type} success:^(MOCHTTPResponse *response) {
        NSString *result = [response.dataDictionary objectForKey:@"result"];
        if (!IsStrEmpty(result) && [result integerValue] > 0) {
            block(YES);
        } else {
            block(NO);
        }
    } failed:^(MOCHTTPResponse *response) {
        block(NO);
    }];
}

+ (void)getMyorSearchDataWithParam:(NSDictionary *)param block:(void (^)(NSArray *, NSString *))block
{
    //[Hud showWait];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/business/getAllTypeBusinessList"];
    [MOCHTTPRequestOperationManager postWithURL:request class:nil parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        NSDictionary *dictionary = response.dataDictionary;
        NSArray *dataArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[dictionary objectForKey:@"businesslist"] class:[SHGBusinessObject class]];
        NSString *total = [dictionary objectForKey:@"total"];
        block(dataArray, total);
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        block(nil, @"0");
        [Hud showMessageWithText:@"获取列表数据失败"];
    }];
}

+ (void)loadHotSearchWordFinishBlock:(void (^)(NSArray *))block
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/common/collection/getHotSearchWordCommon"];
    [MOCHTTPRequestOperationManager postWithURL:request parameters:@{@"object":@"business", @"field":@"search_word"} success:^(MOCHTTPResponse *response) {
        NSArray *hotwords = [response.dataDictionary objectForKey:@"hotwords"];
        if (block) {
            block(hotwords);
        }
    } failed:^(MOCHTTPResponse *response) {
        if (block) {
            block(nil);
        }
    }];
}

+ (void)getBusinessDetail:(SHGBusinessObject *)object success:(void (^)(SHGBusinessObject *))block
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/business/getBusinessById"];
    NSDictionary *param = @{@"uid":UID, @"type":object.type, @"businessId":object.businessID };
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        SHGBusinessObject *otherObject = [[[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:@[response.dataDictionary] class:[SHGBusinessObject class]] firstObject];
        if (block) {
            block(otherObject);
        }
    } failed:^(MOCHTTPResponse *response) {
        if (block) {
            block(nil);
        }
    }];
}

//评论
+ (void)addCommentWithObject:(SHGBusinessObject *)object content:(NSString *)content toOther:(NSString *)otherId finishBlock:(void (^)(BOOL))block
{
    if (!otherId) {
        otherId = @"-1";
    }
    if (!content) {
        content = @"";
    }
    SHGBusinessCommentObject *targetCommentObject = nil;
    for (SHGBusinessCommentObject *obj in object.commentList) {
        if ([obj.commentUserId isEqualToString:otherId]) {
            targetCommentObject = obj;
            break;
        }
    }
    [Hud showWait];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/common/comment/business/saveComment"];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
    NSDictionary *param = @{@"uid":UID, @"businessId":object.businessID, @"content":content, @"replyId":otherId, @"type":object.type};

    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        SHGBusinessCommentObject *newObject = [[SHGBusinessCommentObject alloc] init];
        newObject.commentDetail = content;
        newObject.commentId = [response.dataDictionary objectForKey:@"result"];
        newObject.commentOtherName = targetCommentObject.commentUserName;
        newObject.commentUserId = UID;
        newObject.commentUserName = userName;
        [object.commentList addObject:newObject];
        [Hud showMessageWithText:@"评论成功"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_MEMORY];
        if (block) {
            block(YES);
        }
        [[SHGGloble sharedGloble] recordUserAction:[NSString stringWithFormat:@"%@#%@", object.businessID, object.type] type:@"business_comment"];
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
    [Hud showWait];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/common/comment/deleteComment"];
    NSDictionary *param = @{@"commentId":commentId, @"type":@"business"};
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"删除评论成功"];
        if (block) {
            block(YES);
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"删除评论失败"];

    }];
}

//分享业务
- (void)shareAction:(SHGBusinessObject *)object baseController:(UIViewController *)controller finishBlock:(void (^)(BOOL))block
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *request = [rBaseAddressForHttp stringByAppendingFormat:@"/business/share/businessDetail?rowId=%@&uid=%@&businessType=%@",object.businessID, uid, object.type];
    UIImage *png = [UIImage imageNamed:@"80.png"];
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:png];
    NSString *theme = object.businessTitle;
    if (theme.length > 15) {
        theme = [NSString stringWithFormat:@"%@...",[theme substringToIndex:15]];
    }
    NSString *postContent = [NSString stringWithFormat:@"【业务】%@", theme];
    NSString *shareContent = [NSString stringWithFormat:@"【业务】%@", theme];
    NSString *friendContent = @"";
    NSString *messageContent = @"";
    if ([controller isKindOfClass:[SHGBusinessSendSuccessViewController class]] || [uid isEqualToString:object.createBy]) {
        friendContent = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我发布了一个非常棒的业务,关于",theme,@"，赶快去业务版块查看吧！",request];
        messageContent = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我在金融大牛圈上发布了一个非常棒的业务,关于",theme,@"，赶快下载大牛圈查看吧！",@"https://itunes.apple.com/cn/app/da-niu-quan-jin-rong-zheng/id984379568?mt=8"];
        
    } else{
        friendContent = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我看到了一个非常棒的业务,关于",theme,@"，赶快去业务版块查看吧！",request];
        messageContent = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我在金融大牛圈上看到了一个非常棒的业务,关于",theme,@"，赶快下载大牛圈查看吧！",@"https://itunes.apple.com/cn/app/da-niu-quan-jin-rong-zheng/id984379568?mt=8"];
    }

   
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
            [[SHGGloble sharedGloble] recordUserAction:object.businessID type:@"dynamic_shareQQ"];
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
+ (void)shareSuccessCallBack:(SHGBusinessObject *)object finishBlock:(void (^)(BOOL))block
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/business/shareBusiness"];
    NSDictionary *param = @{@"businessId":object.businessID, @"type":object.type};
    [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
        if (block) {
            block(YES);
        }
    } failed:^(MOCHTTPResponse *response) {
        if (block) {
            block(NO);
        }
    }];
}

+ (void)refreshBusiness:(SHGBusinessObject *)object success:(void (^)(BOOL))block
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/business/refreshBusiness"] parameters:@{@"uid": UID,@"businessId": object.businessID, @"businessType":object.type} success:^(MOCHTTPResponse *response) {
        if (block) {
            block(YES);
        }
        [Hud showMessageWithText:@"刷新成功"];
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:@"刷新失败"];
    }];
}

@end
