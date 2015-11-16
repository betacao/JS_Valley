//
//  SHGPersonDynamicViewController.m
//  Finance
//
//  Created by changxicao on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGPersonDynamicViewController.h"
#import "SHGHomeTableViewCell.h"
#import "MLEmojiLabel.h"
#import "LinkViewController.h"

@interface SHGPersonDynamicViewController ()<UITableViewDataSource, UITableViewDelegate, MLEmojiLabelDelegate, CircleListDelegate, CircleActionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SHGPersonDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"他的动态";
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleListObj *obj = self.dataArr[indexPath.row];

    if ([obj.status boolValue]) {
        static NSString *cellIdentifier = @"circleListIdentifier";
        SHGHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGHomeTableViewCell" owner:self options:nil] lastObject];
        }
        cell.index = indexPath.row;
        cell.delegate = self;
        [cell loadDatasWithObj:obj];

        MLEmojiLabel *mlLable = (MLEmojiLabel *)[cell viewWithTag:521];
        mlLable.delegate = self;
        return cell;
    } else{
        static NSString *cellIdentifier = @"noListIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = @"原帖已删除";
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleListObj *obj = self.dataArr[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CircleDetailViewController *vc = [[CircleDetailViewController alloc] initWithNibName:@"CircleDetailViewController" bundle:nil];
    vc.rid = obj.rid;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"You Click At Section: %ld Row: %ld",(long)indexPath.section,(long)indexPath.row);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleListObj *obj =self.dataArr[indexPath.row];
    if ([obj.status boolValue]){
        NSInteger height = [obj fetchCellHeight];
        return height;
    } else{
        return 0.0f;
    }
}

#pragma mark -- sdc
#pragma mark -- url点击
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    NSLog(@"1111");
    LinkViewController *controller =  [[LinkViewController alloc]init];
    controller.url = link;
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            [self.navigationController pushViewController:controller animated:YES];
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            [self openTel:link];
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }

}
#pragma mark -- sdc
#pragma mark -- 拨打电话
- (BOOL)openTel:(NSString *)tel
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
    NSLog(@"str======%@",str);
    return  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


#pragma mark ------分享

- (void)shareClicked:(CircleListObj *)obj
{
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:[UIImage imageNamed:@"80"]];
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

    id<ISSShareActionSheetItem> item4 = [ShareSDK shareActionSheetItemWithTitle:@"微信朋友圈" icon:[UIImage imageNamed:@"sns_icon_23"] clickHandler:^{
        [[AppDelegate currentAppdelegate] wechatShare:obj shareType:1];
    }];
    id<ISSShareActionSheetItem> item5 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友" icon:[UIImage imageNamed:@"sns_icon_22"] clickHandler:^{
        [[AppDelegate currentAppdelegate] wechatShare:obj shareType:0];
    }];

    NSArray *shareArray = nil;
    if ([WXApi isWXAppSupportApi]) {
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: item3, item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), item1,item2,nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item3, item5, item4, item1, item2, nil];
        }
    } else{
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: item3, SHARE_TYPE_NUMBER(ShareTypeQQ), item1, item2, nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item3, item1, item2, nil];
        }
    }

    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,obj.rid];

    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareContent defaultContent:shareContent image:image title:SHARE_TITLE url:shareUrl description:shareContent mediaType:SHARE_TYPE];

    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:shareArray content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess){
            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
            [self otherShareWithObj:obj];
        } else if (state == SSResponseStateFail){
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
        }
    }];

}


- (void)smsShareSuccess:(NSNotification *)noti
{
    id obj = noti.object;
    if ([obj isKindOfClass:[NSString class]])
    {
        NSString *rid = obj;
        for (CircleListObj *objs in self.dataArr) {
            if ([objs.rid isEqualToString:rid]) {
                [self otherShareWithObj:objs];
            }
        }
    }
}


- (void)shareToSMS:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendSmsWithText:text rid:rid];
}

- (void)shareToWeibo:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendmessageToShareWithObjContent:text rid:rid];
}

- (void)otherShareWithObj:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [[AFHTTPRequestOperationManager manager] PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            // [self refreshData];
            obj.sharenum = [NSString stringWithFormat:@"%ld",(long)([obj.sharenum integerValue] + 1)];
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_SHARE_CLIC object:obj];
            [Hud showMessageWithText:@"分享成功"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Hud showMessageWithText:error.domain];

    }];
}

- (void)shareToFriendWithObj:(CircleListObj *)obj
{
    NSString *shareText = [NSString stringWithFormat:@"转自:%@的帖子：%@",obj.nickname,obj.detail];
    FriendsListViewController *vc=[[FriendsListViewController alloc] init];
    vc.isShare = YES;
    vc.shareRid = obj.rid;
    vc.shareContent = shareText;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)circleShareWithObj:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {

        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            obj.sharenum = [NSString stringWithFormat:@"%ld",(long)([obj.sharenum integerValue] + 1)];
            [self.tableView reloadData];
            [Hud showMessageWithText:@"转发成功"];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];

    }];
}

- (void)cnickCLick:(NSString *)userId name:(NSString *)name
{
    if ([userId isEqualToString:self.userId]) {
        return;
    }
    [self gotoSomeOne:userId name:name];
}

- (void)gotoSomeOne:(NSString *)uid name:(NSString *)name
{
    if ([uid isEqualToString:self.userId]) {
        return;
    }
    CircleSomeOneViewController *vc = [[CircleSomeOneViewController alloc] initWithNibName:@"CircleSomeOneViewController" bundle:nil];
    vc.userId = uid;
    vc.userName = name;
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------ 关注
- (void)attentionClicked:(CircleListObj *)obj
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID], @"oid":obj.userid};
    if (![obj.isattention isEqualToString:@"Y"]) {
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                for (CircleListObj *cobj in self.dataArr) {
                    if ([cobj.userid isEqualToString:obj.userid]) {
                        cobj.isattention = @"Y";
                    }
                }
                [self.delegate detailAttentionWithRid:obj.userid attention:obj.isattention];
                [Hud showMessageWithText:@"关注成功"];
//                NSString *state = [response.dataDictionary valueForKey:@"state"];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:obj];
            [self.tableView reloadData];
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
    } else{
        [[AFHTTPRequestOperationManager manager] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Hud hideHud];
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                for (CircleListObj *cobj in self.dataArr) {
                    if ([cobj.userid isEqualToString:obj.userid]) {
                        cobj.isattention = @"N";
                    }
                }
                [self.delegate detailAttentionWithRid:obj.userid attention:obj.isattention];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:obj];
                NSDictionary *data = [[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
                NSString *state = [data valueForKey:@"state"];
                if ([state isEqualToString:@"0"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CHANGE_SHOULD_UPDATE object:nil];
                }
                [Hud showMessageWithText:@"取消关注成功"];
            }
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Hud hideHud];
            [Hud showMessageWithText:error.domain];
        }];
    }

}

- (void)cityClicked:(CircleListObj *)obj
{
    if([obj.postType isEqualToString:@"pc"]){
        NSLog(@"1111");
        LinkViewController *vc=  [[LinkViewController alloc] init];
        vc.url = obj.pcurl;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)action{

    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],@"oid":self.userId};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {

        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]){
            for (CircleListObj *cobj in self.dataArr){
                if ([cobj.userid isEqualToString:self.userId]) {
                    cobj.isattention = @"Y";
                }
            }

            [self.delegate detailAttentionWithRid:self.userId attention:@"Y"];
            CircleListObj *cObj = [[CircleListObj alloc] init];
            cObj.userid = self.userId;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:cObj];
            [self.tableView reloadData];

        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
}

- (void)chat{
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:self.userId isGroup:NO];
//    chatVC.title = self.userName;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (IBAction)actionChat:(id)sender {

//    if ([self.rela intValue] == 0) {
//        [self action];
//    }
//    else if ([self.rela intValue] == 1){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您与对方还不是好友，对方关注您后可进行对话" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    } else{
//        [self chat];
//    }

}

#pragma mark detailDelagte

- (void)detailDeleteWithRid:(NSString *)rid
{
    for (CircleListObj *obj in self.dataArr) {
        if ([obj.rid isEqualToString:rid]) {
            [self.dataArr removeObject:obj];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_DELETE_CLICK object:obj];
            break;
        }
    }
    [self.tableView reloadData];
}

-(void)detailPraiseWithRid:(NSString *)rid praiseNum:(NSString *)num isPraised:(NSString *)isPrased
{
    for (CircleListObj *obj in self.dataArr) {
        if ([obj.rid isEqualToString:rid]) {
            obj.praisenum = num;
            obj.ispraise = isPrased;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_PRAISE_CLICK object:obj];

            break;
        }

    }
    [self.delegate detailPraiseWithRid:rid praiseNum:num isPraised:isPrased];

    [self.tableView reloadData];
}

- (void)detailShareWithRid:(NSString *)rid shareNum:(NSString *)num
{
    for (CircleListObj *obj in self.dataArr) {
        if ([obj.rid isEqualToString:rid]) {
            obj.sharenum = num;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_SHARE_CLIC object:obj];

            break;
        }
    }
    [self.delegate detailShareWithRid:rid shareNum:num];
    [self.tableView reloadData];

}

- (void)detailAttentionWithRid:(NSString *)rid attention:(NSString *)atten
{
    CircleListObj *bobj;

    for (CircleListObj *obj in self.dataArr) {
        if ([obj.userid isEqualToString:rid]){
            obj.isattention = atten;
            bobj = obj;
        }

    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:bobj];

    [self.delegate detailAttentionWithRid:rid attention:atten];
    [self.tableView reloadData];
}

- (void)detailCommentWithRid:(NSString *)rid commentNum:(NSString*)num comments:(NSMutableArray *)comments
{
    for (CircleListObj *obj in self.dataArr) {
        if ([obj.rid isEqualToString:rid]) {
            obj.cmmtnum = num;
            obj.comments = comments;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COMMENT_CLIC object:obj];

            break;
        }
    }
    [self.delegate detailCommentWithRid:rid commentNum:num comments:comments];
    [self.tableView reloadData];

}

- (void)gesToFriendList:(DDTapGestureRecognizer *)ge
{
    [self gotoFriendList];
}

- (void)gotoFriendList
{
    if (![self.userId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]]) {
        return;
    }
    ChatListViewController *vc = [[ChatListViewController alloc] init];
    vc.chatListType = ContactListView;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionFriendList:(id)sender {

    [self gotoFriendList];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
