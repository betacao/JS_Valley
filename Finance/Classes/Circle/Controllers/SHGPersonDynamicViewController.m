//
//  SHGPersonDynamicViewController.m
//  Finance
//
//  Created by changxicao on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGPersonDynamicViewController.h"
#import "SHGMainPageTableViewCell.h"
#import "SHGLinkViewController.h"
#import "SHGEmptyDataView.h"
#import "SHGGlobleOperation.h"

@interface SHGPersonDynamicViewController ()<UITableViewDataSource, UITableViewDelegate, CircleListDelegate, CircleActionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *target;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;

@end

@implementation SHGPersonDynamicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.userId isEqualToString:UID]) {
        self.title = @"我的动态";
    } else{
        self.title = @"TA的动态";
    }
    [Hud showWait];
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.target = @"first";
    [self requestDataWithTarget:@"first" time:@"-1"];

    //这里面注册2个 是因为有可能单独进到这个页面里面，而不是通过segment
    [SHGGlobleOperation registerAttationClass:[self class] method:@selector(loadAttationState:attationState:)];
    [SHGGlobleOperation registerPraiseClass:[self class] method:@selector(loadPraiseState:praiseState:)];
    [SHGGlobleOperation registerDeleteClass:[self class] method:@selector(loadDelete:)];
}

- (void)loadAttationState:(NSString *)targetUserID attationState:(NSNumber *)attationState
{
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CircleListObj class]]) {
            CircleListObj *listObj = (CircleListObj *)obj;
            if ([listObj.userid isEqualToString:targetUserID]) {
                listObj.isAttention = [attationState boolValue];
            }
        }
    }];
    [self.tableView reloadData];
}

- (void)loadPraiseState:(NSString *)targetID praiseState:(NSNumber *)praiseState
{
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CircleListObj class]]) {
            CircleListObj *listObject = (CircleListObj *)obj;
            if ([listObject.rid isEqualToString:targetID]) {
                listObject.ispraise = [praiseState boolValue] ? @"Y" : @"N";
                if ([praiseState boolValue]) {
                    listObject.praisenum = [NSString stringWithFormat:@"%ld", (long)[listObject.praisenum integerValue] + 1];
                } else {
                    listObject.praisenum = [NSString stringWithFormat:@"%ld", (long)[listObject.praisenum integerValue] - 1];
                }
            }
        }
    }];
    [self.tableView reloadData];
}

- (void)loadDelete:(NSString *)targetID
{
    NSMutableArray *array = [NSMutableArray array];
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CircleListObj *listObject = (CircleListObj *)obj;
        if ([listObject.rid isEqualToString:targetID]) {
            [array addObject:listObject];
        }
    }];
    [self.dataArr removeObjectsInArray:array];
    [self.tableView reloadData];
}

- (void)requestDataWithTarget:(NSString *)target time:(NSString *)time
{

    WEAK(self, weakSelf);
    NSDictionary *param = @{@"uid":UID, @"target":target, @"rid":time, @"num":@(10)};
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"queryCircleListById",self.userId] class:[CircleListObj class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf parseDataWithDic:response.dataDictionary];
        [weakSelf.tableView reloadData];
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
        [Hud hideHud];
        NSLog(@"%@",response.errorMessage);
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)parseDataWithDic:(NSDictionary *)dictionary
{
    NSArray *listArray = [dictionary objectForKey:@"list"];
    listArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:listArray class:[CircleListObj class]];
    if ([self.target isEqualToString:@"first"] && listArray.count > 0) {
        [self.dataArr addObjectsFromArray:listArray];
    }
    if ([self.target isEqualToString:@"load"] && listArray.count > 0) {
        [self.dataArr addObjectsFromArray:listArray];
    }
    if (listArray.count < 10) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}


- (void)refreshFooter
{
    self.target = @"load";
    if (self.dataArr.count > 0){
        CircleListObj *obj = [self.dataArr lastObject];
        [self requestDataWithTarget:@"load" time:obj.rid];
    }
}

- (UITableViewCell *)emptyCell
{
    if (!_emptyCell) {
        _emptyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_emptyCell.contentView addSubview:self.emptyView];
    }
    return _emptyCell;
}


- (SHGEmptyDataView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SHGEmptyDataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
    }
    return _emptyView;
}

#pragma mark ------ tableviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count > 0) {
        return self.dataArr.count;
    } else{
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        id object = [self.dataArr objectAtIndex:indexPath.row];
        if([object isKindOfClass:[CircleListObj class]]){

            if (![((CircleListObj *)object).postType isEqualToString:@"ad"]){
                return SCREENWIDTH;
            } else{
                return MarginFactor(198.0f);
            }

        }
        return SCREENWIDTH;
    }
    return SCREENHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        CircleListObj *obj = self.dataArr[indexPath.row];
        
        if ([obj.status boolValue]) {
            NSString *cellIdentifier = @"SHGMainPageTableViewCell";
            SHGMainPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGMainPageTableViewCell" owner:self options:nil] lastObject];
            }
            cell.index = indexPath.row;
            cell.delegate = self;
            cell.object = obj;
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            return cell;
        } else{
            NSString *cellIdentifier = @"noListIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.textLabel.text = @"原帖已删除";
            cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
            
            return cell;
        }

    } else{
        return self.emptyCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        CircleListObj *obj = self.dataArr[indexPath.row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CircleDetailViewController *vc = [[CircleDetailViewController alloc] initWithNibName:@"CircleDetailViewController" bundle:nil];
        vc.rid = obj.rid;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        CircleListObj *obj = self.dataArr[indexPath.row];
        if ([obj.status boolValue]){
            NSInteger height = [tableView cellHeightForIndexPath:indexPath model:obj keyPath:@"object" cellClass:[SHGMainPageTableViewCell class] contentViewWidth:SCREENWIDTH];
            return height;
        } else{
            return 0.0f;
        }

    } else{
         return CGRectGetHeight(self.view.frame);
    }
}

#pragma mark ------分享

- (void)shareClicked:(CircleListObj *)obj
{
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:[UIImage imageNamed:@"80"]];
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
            shareArray = [ShareSDK customShareListWithType:  item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), item3,item1,item2,nil];
        } else{
            shareArray = [ShareSDK customShareListWithType:  item5, item4, item3, item1, item2, nil];
        }
    } else{
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: SHARE_TYPE_NUMBER(ShareTypeQQ), item3, item1, item2, nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item3, item1, item2, nil];
        }
    }

    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,obj.rid];

    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareContent defaultContent:shareContent image:image title:title url:shareUrl description:shareContent mediaType:SHARE_TYPE];

    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:shareArray content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess){
            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
            [self otherShareWithObj:obj];
            [[SHGGloble sharedGloble] recordUserAction:obj.rid type:@"dynamic_shareQQ"];
        } else if (state == SSResponseStateFail){
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
        }
    }];

}


- (void)smsShareSuccess:(NSNotification *)noti
{
    id obj = noti.object;
    if ([obj isKindOfClass:[NSString class]]) {
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
    NSDictionary *param = @{@"uid":UID};
    WEAK(self, weakSelf);
    [MOCHTTPRequestOperationManager putWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            obj.sharenum = [NSString stringWithFormat:@"%ld",(long)([obj.sharenum integerValue] + 1)];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_SHARE_CLIC object:obj];
            [Hud showMessageWithText:@"分享成功"];
            [weakSelf.tableView reloadData];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
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

- (void)cityClicked:(CircleListObj *)obj
{
    if([obj.postType isEqualToString:@"pc"]){
        NSLog(@"1111");
        SHGLinkViewController *vc=  [[SHGLinkViewController alloc] init];
        vc.url = obj.pcurl;
        [self.navigationController pushViewController:vc animated:YES];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
