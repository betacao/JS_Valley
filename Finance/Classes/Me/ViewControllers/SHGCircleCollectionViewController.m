//
//  SHGCircleViewController.m
//  Finance
//
//  Created by weiqiankun on 16/3/17.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCircleCollectionViewController.h"
#import "SHGEmptyDataView.h"
#import "CircleListObj.h"
#import "CircleListDelegate.h"
#import "SHGMainPageTableViewCell.h"
#import "CircleDetailViewController.h"
#import "SHGAlertView.h"
@interface SHGCircleCollectionViewController ()<UITabBarDelegate, UITableViewDataSource,CircleListDelegate,UIAlertViewDelegate,CircleActionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@property (strong, nonatomic)  CircleListObj *deleteObj;;
@end

@implementation SHGCircleCollectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"动态收藏";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"efeeef"];
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    //这里面注册2个 是因为有可能单独进到这个页面里面，而不是通过segment(区别就在第二个参数 不是id)
    [SHGGlobleOperation registerAttationClass:[self class] method:@selector(loadAttationState:attationState:)];
    [SHGGlobleOperation registerPraiseClass:[self class] method:@selector(loadPraiseState:praiseState:)];
    [SHGGlobleOperation registerDeleteClass:[self class] method:@selector(loadDelete:)];

    [self requestPostListWithTarget:@"first" rid:@"-1"];

}


- (void)smsShareSuccess:(NSNotification *)noti
{
    id obj = noti.object;
    if ([obj isKindOfClass:[NSString class]]){
        NSString *rid = obj;
        for (CircleListObj *objs in self.dataArr) {
            if ([objs.rid isEqualToString:rid]) {
                [self otherShareWithObj:objs];
            }
        }
    }
}

- (NSMutableArray *)currentDataArray
{
    return self.dataArr;
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)refreshData
{
    [self requestPostListWithTarget:@"first" rid:@"-1"];
}

- (void)loadAttationState:(NSString *)targetUserID attationState:(NSNumber *)attationState
{
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CircleListObj class]]) {
            CircleListObj *listObject = (CircleListObj *)obj;
            if ([listObject.userid isEqualToString:targetUserID]) {
                listObject.isAttention = [attationState boolValue];
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

- (UITableViewCell *)emptyCell
{
    if (!_emptyCell) {
        _emptyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_emptyCell.contentView addSubview:self.emptyView];
    }
    return _emptyCell;
}

- (void)requestPostListWithTarget:(NSString *)target rid:(NSString *)rid
{
    WEAK(self, weakSelf);
    [self.view showLoading];

    NSDictionary * param = @{@"uid":UID, @"target":target, @"rid":rid, @"num":@"10"};
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"collection",@"mycirclelist"] class:[CircleListObj class] parameters:param success:^(MOCHTTPResponse *response) {
        [weakSelf.view hideHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([target isEqualToString:@"first"]) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:response.dataArray];
        }
        if ([target isEqualToString:@"load"]) {
            [self.dataArr addObjectsFromArray:response.dataArray];
            if (response.dataArray.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
        [self.tableView reloadData];
        [weakSelf.view hideHud];

    } failed:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.errorMessage);
        [weakSelf.view hideHud];
        [weakSelf.view showWithText:response.errorMessage];
        [self.tableView.mj_header endRefreshing];
        [self performSelector:@selector(endFoot) withObject:nil afterDelay:1.0];
    }];

}

- (void)endFoot
{
    [self.tableView.mj_footer endRefreshing];

}

- (SHGEmptyDataView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SHGEmptyDataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
    }
    return _emptyView;
}

- (void)refreshFooter
{
    if (self.dataArr.count > 0){
        CircleListObj *obj = [self.dataArr lastObject];
        [self requestPostListWithTarget:@"load" rid:obj.rid];
    }
}
#pragma mark ------tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count > 0) {
        NSInteger count = self.dataArr.count;
        return count;
    } else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataArr.count > 0){
        CircleListObj *obj = [self.dataArr objectAtIndex:indexPath.row];
        if ([obj.status boolValue]) {
            CGFloat height = [tableView cellHeightForIndexPath:indexPath model:obj keyPath:@"object" cellClass:[SHGMainPageTableViewCell class] contentViewWidth:SCREENWIDTH];
            return height;
        }
    } else{
        return CGRectGetHeight(self.view.frame);
    }
    return 0.0f;
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
    return CGRectGetHeight(self.view.frame);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        CircleListObj *obj = [self.dataArr objectAtIndex:indexPath.row];
        NSString *cellIdentifier = @"SHGMainPageTableViewCell";
        SHGMainPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGMainPageTableViewCell" owner:self options:nil] lastObject];
        }
        cell.delegate = self;
        cell.index = indexPath.row;
        cell.object = obj;
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    } else{
        return self.emptyCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleListObj *obj = [self.dataArr objectAtIndex:indexPath.row];
    CircleDetailViewController *vc = [[CircleDetailViewController alloc] initWithNibName:@"CircleDetailViewController" bundle:nil];
    vc.delegate = self;
    vc.rid = obj.rid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeCardCollection
{
    [self requestPostListWithTarget:@"first" rid:@"-1"];
}

- (void)shareToSMS:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendSmsWithText:text rid:rid];
}

- (void)shareClicked:(CircleListObj *)obj
{
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:[UIImage imageNamed:@"80"]];
    NSString *postContent = @"";
    NSString *shareContent = @"";
    NSString *title = @" ";
    if (obj.groupPostTitle.length > 0) {
        if (obj.groupPostTitle.length > 15) {
            title = [NSString stringWithFormat:@"%@...",[obj.groupPostTitle substringToIndex:15]];
        } else{
            title = obj.groupPostTitle;
        }
        
    } else{
        title = SHARE_TITLE;
    }
    
    if(IsStrEmpty(obj.detail)){
        if ([title isEqualToString:SHARE_TITLE]) {
            postContent = SHARE_CONTENT;
            shareContent = SHARE_CONTENT;
        } else{
            postContent = title;
            shareContent = title;
        }
        
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

- (void)shareToWeibo:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendmessageToShareWithObjContent:text rid:rid];
}

- (void)shareToFriendWithText:(NSString *)text rid:(NSString *)rid
{
    FriendsListViewController *vc=[[FriendsListViewController alloc] init];
    vc.isShare = YES;
    vc.shareRid = rid;
    vc.shareContent = text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareToFriendWithObj:(CircleListObj *)obj
{

    [self circleShareWithObj:obj];
    FriendsListViewController *vc=[[FriendsListViewController alloc] init];
    vc.isShare = YES;
    vc.shareContent = obj.detail;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)circleShareWithObj:(CircleListObj *)obj
{
    WEAK(self, weakSelf);
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {

        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            obj.sharenum = [NSString stringWithFormat:@"%ld",(long)[obj.sharenum integerValue]+1];
            [self.tableView reloadData];
            [weakSelf.view showWithText:@"分享成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_SHARE_CLIC object:obj];

        }
    } failed:^(MOCHTTPResponse *response) {
        [weakSelf.view showWithText:response.errorMessage];

    }];
}

- (void)otherShareWithObj:(CircleListObj *)obj
{
    WEAK(self, weakSelf);
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [MOCHTTPRequestOperationManager putWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            obj.sharenum = [NSString stringWithFormat:@"%ld",(long)[obj.sharenum integerValue]+1];
            [self.tableView reloadData];
            [weakSelf.view showWithText:@"分享成功"];
        }
    } failed:^(MOCHTTPResponse *response) {
        [weakSelf.view showWithText:response.errorMessage];
    }];
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
    [self.tableView reloadData];

}

-(void)detailCollectionWithRid:(NSString *)rid collected:(NSString *)isColle
{
    [self requestPostListWithTarget:@"first" rid:@"-1"];\
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
