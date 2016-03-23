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
#import "SHGMarketSegmentViewController.h"
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
    self.title = @"收藏";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];
    [self requestPostListWithTarget:@"first" time:@"0"];
}
-(void)smsShareSuccess:(NSNotification *)noti
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
    [self requestPostListWithTarget:@"first" time:@"0"];
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

- (void)requestPostListWithTarget:(NSString *)target time:(NSString *)time
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
  
    NSDictionary * param = @{@"uid":uid,
                             @"target":target,
                             @"time":time,
                             @"num":@"100"};
    
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"collection",@"mycirclelist"] class:[CircleListObj class] parameters:param success:^(MOCHTTPResponse *response) {
        if ([target isEqualToString:@"first"]) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:response.dataArray];
            
        }
        if ([target isEqualToString:@"refresh"]) {
            [self.dataArr removeAllObjects];
            if (response.dataArray.count > 0) {
                for (NSInteger i = response.dataArray.count-1; i >= 0; i --) {
                    CircleListObj *obj = response.dataArray[i];
                    [self.dataArr insertObject:obj atIndex:0];
                }
                
            }
            
        }
        if ([target isEqualToString:@"load"]) {
            [self.dataArr addObjectsFromArray:response.dataArray];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Hud hideHud];
        
    } failed:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.errorMessage);
        [Hud hideHud];
        [Hud showMessageWithText:response.errorMessage];
        [self.tableView.mj_header endRefreshing];
        [self performSelector:@selector(endFoot) withObject:nil afterDelay:1.0];
    }];
    
}

-(void)endFoot
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


- (void)refreshHeader
{
    [self requestPostListWithTarget:@"refresh" time:@""];
}

- (void)refreshFooter
{
    [self requestPostListWithTarget:@"load" time:@""];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        CircleListObj *obj = [self.dataArr objectAtIndex:indexPath.row];
        if ([obj.status boolValue]) {
            NSString *cellIdentifier = @"SHGMainPageTableViewCell";
            SHGMainPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGMainPageTableViewCell" owner:self options:nil] lastObject];
                cell.delegate = self;
            }
            cell.index = indexPath.row;
            cell.object = obj;
           //cell.controller = self;
            return cell;
        } else{
            NSString *cellIdentifier = @"noListIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.textLabel.text = @"原帖已删除";
            cell.textLabel.font = FontFactor(16.0f);
            
            return cell;
        }
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
    [self requestPostListWithTarget:@"first" time:@"-1"];
}

- (void)deleteClicked:(CircleListObj *)obj
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    _deleteObj = obj;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        [self deleteSele:_deleteObj];
    }
}
-(void)deleteSele:(CircleListObj *)obj
{
    
    //删除
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"circle"];
    NSDictionary *dic = @{@"rid":obj.rid, @"uid":obj.userid};
    __weak typeof(self) weakSelf = self;
    [[AFHTTPSessionManager manager] DELETE:url parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"]){
            [weakSelf detailDeleteWithRid:obj.rid];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_DELETE_CLICK object:obj];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [Hud showMessageWithText:error.domain];
    }];
}

- (void)praiseClicked:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"praisesend"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],@"rid":obj.rid};
    __weak typeof(self) weakSelf = self;
    if (![obj.ispraise isEqualToString:@"Y"]) {
        [Hud showWait];
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            NSLog(@"%@",response.data);
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                obj.ispraise = @"Y";
                obj.praisenum = [NSString stringWithFormat:@"%ld",(long)[obj.praisenum integerValue] +1];
                [Hud showMessageWithText:@"赞成功"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_PRAISE_CLICK object:obj];
            }
            [Hud hideHud];
            [weakSelf.tableView reloadData];
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
        
    } else{
        [Hud showWait];
        [[AFHTTPSessionManager manager] DELETE:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                obj.ispraise = @"N";
                obj.praisenum = [NSString stringWithFormat:@"%ld",(long)[obj.praisenum integerValue] -1];
                [Hud showMessageWithText:@"取消点赞"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_PRAISE_CLICK object:obj];
                
            }
            [weakSelf.tableView reloadData];
            [Hud hideHud];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [Hud showMessageWithText:error.domain];
            [Hud hideHud];
        }];
    }
}

- (void)clicked:(NSInteger )index;
{
    CircleDetailViewController *vc = [[CircleDetailViewController alloc] initWithNibName:@"CircleDetailViewController" bundle:nil];
    CircleListObj *obj = self.dataArr[index];
    vc.hidesBottomBarWhenPushed = YES;
    // vc.obj = obj;
    vc.delegate = self;
    vc.rid = obj.rid;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)shareToSMS:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendSmsWithText:text rid:rid];
}
- (void)shareClicked:(CircleListObj *)obj
{
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:[UIImage imageNamed:@"80"]];
    
    if (!IsArrEmpty(obj.photoArr)  ) {
        //  image = [ShareSDK imageWithUrl:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,_obj.photoArr[0]]];
    }
    NSString *postContent;
    NSString *shareContent;
    
    NSString *shareTitle ;
    if (IsStrEmpty(obj.detail)) {
        postContent = SHARE_CONTENT;
        shareTitle = SHARE_TITLE;
        shareContent = SHARE_CONTENT;
    }
    else
    {
        postContent = obj.detail;
        shareTitle = obj.detail;
        shareContent = obj.detail;
    }
    if (obj.detail.length > 15)
    {
        postContent = [NSString stringWithFormat:@"%@...",[obj.detail substringToIndex:15]];
    }
    if (obj.detail.length > 15)
    {
        
        shareTitle = [obj.detail substringToIndex:15];
        
        shareContent = [NSString stringWithFormat:@"%@...",[obj.detail substringToIndex:15]];
        
    }
    NSString *content = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我在金融大牛圈上看到了一个非常棒的帖子,关于",postContent,@"，赶快下载大牛圈查看吧！",[NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,obj.rid]];
    id<ISSShareActionSheetItem> item1 = [ShareSDK shareActionSheetItemWithTitle:@"大牛说" icon:[UIImage imageNamed:@"圈子图标"] clickHandler:^{
        [self circleShareWithObj:obj];
    }];
    id<ISSShareActionSheetItem> item2 = [ShareSDK shareActionSheetItemWithTitle:@"圈内好友" icon:[UIImage imageNamed:@"圈内好友图标"] clickHandler:^{
        
        NSString *shareText = [NSString stringWithFormat:@"转自:%@的帖子：%@",obj.nickname,obj.detail];
        [self shareToFriendWithText:shareText rid:obj.rid];
    }];
    
    id<ISSShareActionSheetItem> item3 = [ShareSDK shareActionSheetItemWithTitle:@"短信" icon:[UIImage imageNamed:@"sns_icon_19"] clickHandler:^{
        [self shareToSMS:content  rid:obj.rid];
    }];
    id<ISSShareActionSheetItem> item0 = [ShareSDK shareActionSheetItemWithTitle:@"新浪微博" icon:[UIImage imageNamed:@"sns_icon_1"] clickHandler:^{
        [self shareToWeibo:content rid:obj.rid];
    }];
    
    id<ISSShareActionSheetItem> item4 = [ShareSDK shareActionSheetItemWithTitle:@"微信朋友圈" icon:[UIImage imageNamed:@"sns_icon_23"] clickHandler:^{
        [[AppDelegate currentAppdelegate]wechatShare:obj shareType:1];
    }];
    id<ISSShareActionSheetItem> item5 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友" icon:[UIImage imageNamed:@"sns_icon_22"] clickHandler:^{
        [[AppDelegate currentAppdelegate]wechatShare:obj shareType:0];
    }];
    
    //    NSArray *shareList = [ShareSDK customShareListWithType: item3, item5, item4, item0, item1, item2, nil];
    NSArray *shareArray = nil;
    if ([WXApi isWXAppSupportApi]) {
        if ([WeiboSDK isCanShareInWeiboAPP]) {
            shareArray = [ShareSDK customShareListWithType:  item5, item4, item0, item3, item1, item2, nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item5, item4, item3, item1, item2, nil];
        }
    } else{
        if ([WeiboSDK isCanShareInWeiboAPP]) {
            shareArray = [ShareSDK customShareListWithType: item0,  item3, item1, item2, nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item3, item1, item2, nil];
        }
        
    }
    
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,obj.rid];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareContent defaultContent:shareContent image:image title:SHARE_TITLE url:shareUrl description:shareContent mediaType:SHARE_TYPE];
    //创建弹出菜单容器
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:shareArray content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess){
            [self otherShareWithObj:obj];
            [[SHGGloble sharedGloble] recordUserAction:obj.rid type:@"dynamic_shareQQ"];
        } else if (state == SSResponseStateFail){
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"帖子分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
            
        }
    }];
    
}
-(void)shareToWeibo:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendmessageToShareWithObjContent:text rid:rid];
}
-(void)shareToFriendWithText:(NSString *)text rid:(NSString *)rid
{
    
    FriendsListViewController *vc=[[FriendsListViewController alloc] init];
    vc.isShare = YES;
    vc.shareRid = rid;
    vc.shareContent = text;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)shareToFriendWithObj:(CircleListObj *)obj
{
    
    [self circleShareWithObj:obj];
    FriendsListViewController *vc=[[FriendsListViewController alloc] init];
    vc.isShare = YES;
    vc.shareContent = obj.detail;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)circleShareWithObj:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            obj.sharenum = [NSString stringWithFormat:@"%ld",(long)[obj.sharenum integerValue]+1];
            [self.tableView reloadData];
            [Hud showMessageWithText:@"分享成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_SHARE_CLIC object:obj];
            
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
        
    }];
}

- (void)otherShareWithObj:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [MOCHTTPRequestOperationManager putWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            obj.sharenum = [NSString stringWithFormat:@"%ld",(long)[obj.sharenum integerValue]+1];
            [self.tableView reloadData];
            [Hud showMessageWithText:@"分享成功"];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
}

- (void)attentionClicked:(CircleListObj *)obj
{
    [Hud showWait];
    __weak typeof(self) weakSelf = self;
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
                [Hud showMessageWithText:@"关注成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:obj];
            } else{
                [Hud showMessageWithText:@"失败"];
            }
            [weakSelf.tableView reloadData];
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
    } else{
        [[AFHTTPSessionManager manager] DELETE:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [Hud hideHud];
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                for (CircleListObj *cobj in self.dataArr) {
                    if ([cobj.userid isEqualToString:obj.userid]) {
                        cobj.isattention = @"N";
                    }
                }
                [Hud showMessageWithText:@"取消关注成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:obj];
            } else{
                [Hud showMessageWithText:@"失败"];
            }
            [weakSelf.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [Hud hideHud];
            [Hud showMessageWithText:error.domain];
        }];
    }
}

#pragma mark detailDelagte

-(void)detailDeleteWithRid:(NSString *)rid
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
    [self.tableView reloadData];
}

-(void)detailShareWithRid:(NSString *)rid shareNum:(NSString *)num
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
-(void)detailAttentionWithRid:(NSString *)rid attention:(NSString *)atten
{
    for (CircleListObj *obj in self.dataArr) {
        if ([obj.userid isEqualToString:rid]) {
            obj.isattention = atten;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:obj];
        }
    }
    [self.tableView reloadData];
}

-(void)detailCommentWithRid:(NSString *)rid commentNum:(NSString*)num comments:(NSMutableArray *)comments
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
    [self requestPostListWithTarget:@"first" time:@"-1"];
    //[self requestMarketCollectWithTarget:@"first" time:@"-1"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
