//
//  MyCollectionViewController.m
//  Finance
//
//  Created by Okay Hoo on 15/4/29.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyCollectionTableViewCell.h"
#import "ProdListObj.h"
#import "CircleListObj.h"
#import "SHGCollectCardClass.h"
#import "BasePeopleObject.h"
#import "SHGMainPageTableViewCell.h"
#import "ProductListTableViewCell.h"
#import "SHGPersonalViewController.h"
#import "SHGCardTableViewCell.h"
#import "SHGNewsTableViewCell.h"
#import "SHGEmptyDataView.h"
#import "SHGMarketObject.h"
#import "SHGMarketTableViewCell.h"
#import "SHGMarketDetailViewController.h"
#import "SHGMarketSendViewController.h"
#import "SHGMarketSegmentViewController.h"
#import "SHGMarketDetailViewController.h"
#import "ProdConfigViewController.h"
#import "CircleDetailViewController.h"
#define KButtonWidth 320.f/4.0 * XFACTOR
@interface MyCollectionViewController ()<SHGMarketTableViewDelegate, MLEmojiLabelDelegate>
{
    UIImageView *imageBttomLine;
    BOOL hasDataFinished;
    NSInteger photoIndex;
    CircleListObj *deleteObj;
    NSInteger   clickIndex;
    NSInteger imageBttomLineWidth ;
}

@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, strong) UIView * categoryView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *postList;

@property (nonatomic, strong) NSMutableArray *productList;

@property (nonatomic, assign) NSInteger	selectType;

@property (nonatomic, strong) NSMutableArray * cardList;

@property (nonatomic, strong) NSMutableArray * newsList;

@property (nonatomic, strong) NSMutableArray * marketList;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
	self.selectType = 1;
    self.categoryView.userInteractionEnabled = YES;
    self.title = @"我的收藏";
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [CommonMethod setExtraCellLineHidden:self.tableView];
    [Hud showLoadingWithMessage:@"加载中"];
	[self requestPostListWithTarget:@"first" time:@"0"];

}

-(void)smsShareSuccess:(NSNotification *)noti
{
    id obj = noti.object;
    if ([obj isKindOfClass:[NSString class]])
    {
        NSString *rid = obj;
        for (CircleListObj *objs in self.dataSource) {
            if ([objs.rid isEqualToString:rid]) {
                [self otherShareWithObj:objs];
            }
        }
    }
}

-(UIView * )categoryView
{
    NSInteger  categoryViewHeight = 37.0f;
    NSInteger  buttonHeight = 35.0f;
    if (!_categoryView) {
        _categoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, categoryViewHeight)];
        _categoryView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
        NSArray * cartegoryArry = [NSArray arrayWithObjects:@"动态",@"业务",@"产品",@"名片", nil];
        for (NSInteger i = 0; i< cartegoryArry.count; i ++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*KButtonWidth, 0, KButtonWidth, buttonHeight);
            button.tag = 20+i;
            [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            if (i == 0) {
                [button setTitleColor:[UIColor colorWithHexString:@"D82626"] forState:UIControlStateNormal];
                 button.titleLabel.font = [UIFont systemFontOfSize:14];
            }
            [button setTitle:[cartegoryArry objectAtIndex:i] forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_categoryView addSubview:button];
        }
        clickIndex = 20;
        NSInteger imageBttomY = 34.0f;
        imageBttomLineWidth = 28.0f;
        imageBttomLine = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWIDTH/4.0f-imageBttomLineWidth)/2, imageBttomY, imageBttomLineWidth, 2.0f)];
        [imageBttomLine setImage:[UIImage imageNamed:@"tab下划线"]];
        NSInteger lineViewY = 36.0f;
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, lineViewY, SCREENWIDTH, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"e3e3e3"];
        [self.categoryView addSubview:lineView];
        [_categoryView addSubview:imageBttomLine];
    }
    return _categoryView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _categoryView.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _categoryView;
}

-(void)buttonClick:(UIButton *) btn
{
    UIButton * button = [self.view viewWithTag:clickIndex];
    [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    clickIndex = btn.tag;
    switch (btn.tag) {
        case 20:
        {
            self.selectType = 1;
            [self refreshDataSource];
            self.tableView.separatorStyle = 0;
            CGRect rect = imageBttomLine.frame;
            rect.origin.x =(self.tableView.width/4.0f- imageBttomLineWidth )/2+ (btn.tag-20)*self.tableView.width/4.0f ;
            [UIView beginAnimations:nil context:nil];
            [imageBttomLine setFrame:rect];
            [UIView setAnimationDuration:0.3];
            [UIView commitAnimations];
            [btn setTitleColor:[UIColor colorWithHexString:@"D82626"] forState:UIControlStateNormal];
             btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.tableView reloadData];
            [Hud showLoadingWithMessage:@"加载中"];
            [self requestPostListWithTarget:@"first" time:@"-1"];
        }
            break;
        case 22:
        {
            self.tableView.separatorStyle = 0;
            self.selectType = 3;
            [self refreshDataSource];
            CGRect rect = imageBttomLine.frame;
            rect.origin.x =(self.tableView.width/4.0f-imageBttomLineWidth)/2+ (btn.tag-20)*self.tableView.width/4.0f ;
            [UIView beginAnimations:nil context:nil];
            [imageBttomLine setFrame:rect];
            [UIView setAnimationDuration:0.3];
            [UIView commitAnimations];
            [btn setTitleColor:[UIColor colorWithHexString:@"D82626"] forState:UIControlStateNormal];
             btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.tableView reloadData];
            [Hud showLoadingWithMessage:@"加载中"];
            [self requestProductListWithTarget:@"first" time:@""];
            
        }
            break;
        case 23:
        {
            self.tableView.separatorStyle = 0;
            self.selectType = 4;
             [self refreshDataSource];
            CGRect rect = imageBttomLine.frame;
            rect.origin.x =(self.tableView.width/4.0f-imageBttomLineWidth)/2+ (btn.tag-20)*self.tableView.width/4.0f ;
            [UIView beginAnimations:nil context:nil];
            [imageBttomLine setFrame:rect];
            [UIView setAnimationDuration:0.3];
            [UIView commitAnimations];
            [btn setTitleColor:[UIColor colorWithHexString:@"D82626"] forState:UIControlStateNormal];
             btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.tableView reloadData];
            [Hud showLoadingWithMessage:@"加载中"];
            [self requestCardListWithTarget:@"first" time:@"-1" ];
            
            
        }
            break;
        case 21:
        {
            self.tableView.separatorStyle = 0;
            self.selectType = 2;
            [self refreshDataSource];
            CGRect rect = imageBttomLine.frame;
            rect.origin.x =(self.tableView.width/4.0f-imageBttomLineWidth)/2+ (btn.tag-20)*self.tableView.width/4.0f ;
            [UIView beginAnimations:nil context:nil];
            [imageBttomLine setFrame:rect];
            [UIView setAnimationDuration:0.3];
            [UIView commitAnimations];
            [btn setTitleColor:[UIColor colorWithHexString:@"D82626"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.tableView reloadData];
            [Hud showLoadingWithMessage:@"加载中"];
            [self requestMarketCollectWithTarget:@"first" time:@"" ];
            
            
        }
            break;
    }

}


- (void)refreshDataSource
{
	if (self.selectType == 1) {
		self.dataSource = self.postList;
	} else if (self.selectType == 3){
		self.dataSource = self.productList;
    } else if (self.selectType == 4){
        self.dataSource = self.cardList;
    } else if (self.selectType == 2){
        self.dataSource = self.marketList;
    }
	
	[self.tableView reloadData];
	
	
}

-(void)reloadTable
{
    [self.tableView reloadData];
}

-(void)refreshHeader
{
    NSString *target = @"first";
	if (self.dataSource.count > 0)
	{
		NSString *updateTime = @"";
        target = @"refresh";
		if (self.selectType == 1) {
            CircleListObj *obj = self.dataSource[0];
            updateTime = obj.publishdate;
            [Hud showLoadingWithMessage:@"加载中"];
			[self requestPostListWithTarget:target time:updateTime];
		} else if (self.selectType == 3){
            ProdListObj *obj = self.dataSource[0];
            updateTime = obj.time;
			[self requestProductListWithTarget:target time:updateTime];
		} else if (self.selectType == 4){
            SHGCollectCardClass *obj = self.dataSource[0];
            updateTime = obj.collectTime;
            [self requestCardListWithTarget:target time:updateTime];
        } else if (self.selectType == 2){
            SHGMarketObject *obj = self.dataSource[0];
            updateTime = obj.createTime;
            [self requestMarketCollectWithTarget:target time:updateTime];
        }
        //1.7.2 资讯隐藏
//        else if (self.selectType == 4){
//            CircleListObj *obj = self.dataSource[0];
//            updateTime = obj.publishdate;
//            [self requestCardListWithTarget:target time:updateTime];
//        }

    } else
    {
        [self.tableView.header endRefreshing];
    }
}

-(void)refreshFooter
{
    if (hasDataFinished){
        [self.tableView.footer endRefreshingWithNoMoreData];
        return;
    }
	if (self.dataSource.count > 0){
		NSString *updateTime = @"";
		if (self.selectType == 1) {
            [Hud showLoadingWithMessage:@"加载中"];
			[self requestPostListWithTarget:@"load" time:updateTime];
		} else if (self.selectType == 3){
			[self requestProductListWithTarget:@"load" time:updateTime];
        } else if (self.selectType == 4){
             [Hud showLoadingWithMessage:@"加载中"];
            [self requestCardListWithTarget:@"load" time:updateTime];
        } else if (self.selectType == 2){
            [Hud showLoadingWithMessage:@"加载中"];
            [self requestCardListWithTarget:@"load" time:updateTime];
        }

	} else{
        [self.tableView.footer endRefreshing];
    }
}

- (void)requestPostListWithTarget:(NSString *)target time:(NSString *)time
{
    if ([target isEqualToString:@"first"])
    {
        [self.tableView.footer resetNoMoreData];
        hasDataFinished = NO;

    }
	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
   //
	NSDictionary * param = @{@"uid":uid,
			  @"target":target,
			  @"time":time,
			  @"num":@"100"};

	[MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"collection",@"mycirclelist"] class:[CircleListObj class] parameters:param success:^(MOCHTTPResponse *response) {
        if ([target isEqualToString:@"first"]) {
            [self.postList removeAllObjects];
            [self.postList addObjectsFromArray:response.dataArray];
            
        }
        if ([target isEqualToString:@"refresh"]) {
            if (response.dataArray.count > 0) {
                for (NSInteger i = response.dataArray.count-1; i >= 0; i --) {
                    CircleListObj *obj = response.dataArray[i];
                    [self.postList insertObject:obj atIndex:0];
                }
                
            }
            
        }
        if ([target isEqualToString:@"load"]) {
            [self.postList addObjectsFromArray:response.dataArray];
            if (IsArrEmpty(response.dataArray)) {
                hasDataFinished = YES;
            }
            else
            {
                hasDataFinished = NO;
            }
        }
      
        [self refreshDataSource];
        
		[self.tableView.header endRefreshing];
		[self.tableView.footer endRefreshing];
        [Hud hideHud];

	} failed:^(MOCHTTPResponse *response) {
		NSLog(@"%@",response.errorMessage);
        [Hud hideHud];
        [Hud showMessageWithText:response.errorMessage];
		[self.tableView.header endRefreshing];
        [self performSelector:@selector(endFoot) withObject:nil afterDelay:1.0];
	}];

}
- (void)requestMarketCollectWithTarget:(NSString *)target time:(NSString *)time
{
    if ([target isEqualToString:@"first"])
    {
        [self.tableView.footer resetNoMoreData];
        hasDataFinished = NO;
        
    }
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [Hud showLoadingWithMessage:@"加载中"];
    NSDictionary *param = @{@"uid":uid,@"target":target,@"time":time,@"num":@"100"};
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"market",@"collection"] class:[SHGMarketObject class] parameters:param success:^(MOCHTTPResponse *response) {
        NSDictionary *dictionary = response.dataDictionary;
        NSArray * dataArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:[dictionary objectForKey:@"datas"] class:[SHGMarketObject class]];

        if ([target isEqualToString:@"first"]) {
            [self.marketList removeAllObjects];
            [self.marketList addObjectsFromArray:dataArray];
            
        }
        if ([target isEqualToString:@"refresh"]) {
            if (dataArray.count > 0) {
                for (NSInteger i = dataArray.count-1; i >= 0; i --) {
                    SHGMarketObject *obj = dataArray[i];
                    [self.marketList insertObject:obj atIndex:0];
                }
                
            }
            
        }
        if ([target isEqualToString:@"load"]) {
            [self.marketList addObjectsFromArray:dataArray];
            
        }
        if (IsArrEmpty(dataArray)) {
            hasDataFinished = YES;
        }
        else
        {
            hasDataFinished = NO;
        }
        [self refreshDataSource];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [Hud hideHud];
        
    } failed:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.errorMessage);
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [Hud hideHud];
        
    }];

}

-(void)endFoot
{
    [self.tableView.footer endRefreshing];

}

- (void)deleteClicked:(CircleListObj *)obj
{
 
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    deleteObj = obj;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        [self deleteSele:deleteObj];
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
        [Hud showLoadingWithMessage:@"正在点赞"];
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
        [Hud showLoadingWithMessage:@"正在取消点赞"];
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
    CircleListObj *obj = self.dataSource[index];
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
            shareArray = [ShareSDK customShareListWithType: item5, item4, item0, item3, item1, item2, nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item5, item4, item3, item1, item2, nil];
        }
    } else{
        if ([WeiboSDK isCanShareInWeiboAPP]) {
            shareArray = [ShareSDK customShareListWithType: item0, item3, item1, item2, nil];
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
        } else if (state == SSResponseStateFail){
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);

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
    [Hud showLoadingWithMessage:@"请稍等..."];
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID], @"oid":obj.userid};
    if (![obj.isattention isEqualToString:@"Y"]) {
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                for (CircleListObj *cobj in self.dataSource) {
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
                for (CircleListObj *cobj in self.dataSource) {
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

- (void)requestCardListWithTarget:(NSString *)target time:(NSString *)time
{
    if ([target isEqualToString:@"first"])
    {
        [self.tableView.footer resetNoMoreData];
        hasDataFinished = NO;
        
    }

    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [Hud showLoadingWithMessage:@"加载中"];
    NSDictionary *param = @{@"uid":uid,
                           @"target":target,
                            @"time":time,
                           @"num":@"100"};
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"userCard",@"myCardlist"] class:[SHGCollectCardClass class] parameters:param success:^(MOCHTTPResponse *response) {
        NSLog(@"=========%@",response.dataArray);
        
        if ([target isEqualToString:@"first"]) {
           [self.cardList removeAllObjects];
           [self.cardList addObjectsFromArray:response.dataArray];
            
        }
        if ([target isEqualToString:@"refresh"]) {
            if (response.dataArray.count > 0) {
                for (NSInteger i = response.dataArray.count-1; i >= 0; i --) {
                    SHGCollectCardClass *obj = response.dataArray[i];
                    [self.cardList insertObject:obj atIndex:0];
                }
                
            }
            
        }
        if ([target isEqualToString:@"load"]) {
            [self.cardList addObjectsFromArray:response.dataArray];
            
        }
        if (IsArrEmpty(response.dataArray)) {
            hasDataFinished = YES;
        }
        else
        {
            hasDataFinished = NO;
        }
        [self refreshDataSource];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [Hud hideHud];
        
    } failed:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.errorMessage);
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [Hud hideHud];
        
    }];


}
- (void)requestNewsListWithTarget:(NSString *)target time:(NSString *)time
{
    if ([target isEqualToString:@"first"])
    {
        [self.tableView.footer resetNoMoreData];
        hasDataFinished = NO;
        
    }
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [Hud showLoadingWithMessage:@"加载中"];
    NSDictionary *param = @{@"uid":uid,
                            @"target":target,
                            @"time":time,
                            @"num":@"100"};
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"collection",@"myNewsList"] class:[CircleListObj class] parameters:param success:^(MOCHTTPResponse *response) {
        NSLog(@"=========%@",response.dataArray);
        
        if ([target isEqualToString:@"first"]) {
            [self.newsList removeAllObjects];
            [self.newsList addObjectsFromArray:response.dataArray];
            
        }
        if ([target isEqualToString:@"refresh"]) {
            if (response.dataArray.count > 0) {
                for (NSInteger i = response.dataArray.count-1; i >= 0; i --) {
                    CircleListObj *obj = [response.dataArray objectAtIndex:i];
                    [self.newsList insertObject:obj atIndex:0];
                }
                
            }
            
        }
        if ([target isEqualToString:@"load"]) {
            [self.newsList addObjectsFromArray:response.dataArray];
            
        }
        if (IsArrEmpty(response.dataArray)) {
            hasDataFinished = YES;
        }
        else
        {
            hasDataFinished = NO;
        }
        [self refreshDataSource];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [Hud hideHud];
        
    } failed:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.errorMessage);
        [Hud showMessageWithText:response.errorMessage];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [Hud hideHud];
        
    }];
    
    
}

- (void)requestProductListWithTarget:(NSString *)target time:(NSString *)time
{
	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [Hud showLoadingWithMessage:@"加载中"];

	NSDictionary *param;
	if (IsStrEmpty(time)) {
		param = @{@"uid":uid,
				  @"target":target,
				  @"num":@"100"};
		
	}else{
		param = @{@"uid":uid,
				  @"target":target,
				  @"time":time,
				  @"num":@"100"};
	}
	[MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"prod",@"collection"] class:[ProdListObj class] parameters:param success:^(MOCHTTPResponse *response) {
		 NSLog(@"++++++++++%@",response.dataArray);
        if ([target isEqualToString:@"first"]) {
            [self.productList removeAllObjects];
            [self.productList addObjectsFromArray:response.dataArray];
            
        }
        if ([target isEqualToString:@"refresh"]) {
            if (response.dataArray.count > 0) {
                for (NSInteger i = response.dataArray.count-1; i >= 0; i --) {
                    ProdListObj *obj = response.dataArray[i];
                    [self.productList insertObject:obj atIndex:0];
                }
                
            }
            
        }
        if ([target isEqualToString:@"load"]) {
            [self.productList addObjectsFromArray:response.dataArray];
            
        }
        if (IsArrEmpty(response.dataArray)) {
            hasDataFinished = YES;
        }
        else
        {
            hasDataFinished = NO;
        }
        [self refreshDataSource];
		[self.tableView.header endRefreshing];
		[self.tableView.footer endRefreshing];
        [Hud hideHud];

	} failed:^(MOCHTTPResponse *response) {
		NSLog(@"%@",response.errorMessage);
		[self.tableView.header endRefreshing];
		[self.tableView.footer endRefreshing];
        [Hud hideHud];

	}];
	

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
    NSInteger count ;
    if (self.dataSource > 0) {
        count = self.dataSource.count;
    }else
    {
        count = 1;
    }
	return count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectType == 1) {
        CircleListObj *obj = self.dataSource[indexPath.row];
        if ([obj.status boolValue]) {
            CGFloat height = [tableView cellHeightForIndexPath:indexPath model:obj keyPath:@"object" cellClass:[SHGMainPageTableViewCell class] contentViewWidth:SCREENWIDTH];
            return height;
        }  else{
            return 44.0f;
        }
    } else if (self.selectType == 3){
        return MarginFactor(116.0f);

    } else if (self.selectType == 4) {
        return MarginFactor(90.0f);

    } else if (self.selectType == 2) {
        SHGMarketObject *object = [self.marketList objectAtIndex:indexPath.row];
        CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[SHGMarketTableViewCell class] contentViewWidth:SCREENWIDTH];
        return height;

    } else {
        return 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectType == 1) {
        if (self.dataSource.count > 0) {
            CircleListObj *obj = self.dataSource[indexPath.row];
            if ([obj.status boolValue]) {
                NSString *cellIdentifier = @"SHGMainPageTableViewCell";
                SHGMainPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGMainPageTableViewCell" owner:self options:nil] lastObject];
                    cell.delegate = self;
                }
                cell.index = indexPath.row;
                cell.object = obj;
                cell.controller = self;
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
    } else if(self.selectType == 3){
        if (self.dataSource.count > 0 ) {
            NSString *prodCellIdentifier = @"circleCellIdentifier";
            ProductListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:prodCellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductListTableViewCell" owner:self options:nil] lastObject];
            }
            ProdListObj *obj = self.dataSource[indexPath.row];
            cell.object = obj;
            return cell;
        } else{
            return self.emptyCell;
        }
    } else if(self.selectType == 4) {
        if (self.dataSource > 0) {
            NSString *cardCellIdentifier = @"circleCellIdentifier";
            SHGCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cardCellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGCardTableViewCell" owner:self options:nil] lastObject];
            }
            SHGCollectCardClass *obj = self.dataSource[indexPath.row];
            cell.object = obj;
            return cell;
        } else{
            return self.emptyCell;
        }

    }
    if (self.selectType == 2) {

        NSString *identifier = @"SHGMarketTableViewCell";
        if (self.dataSource.count > 0) {
            SHGMarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGMarketTableViewCell" owner:self options:nil] lastObject];
            }
            cell.delegate = self;
            SHGMarketObject * obj = [self.dataSource objectAtIndex:indexPath.row];
            cell.object = obj;
            return cell;
        } else{
            return self.emptyCell;
        }
    }
    
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectType == 1) {
        CircleListObj *obj = self.dataSource[indexPath.row];
        CircleDetailViewController *vc = [[CircleDetailViewController alloc] initWithNibName:@"CircleDetailViewController" bundle:nil];
        vc.delegate = self;
        vc.rid = obj.rid;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.selectType == 3){
        ProdListObj *obj = self.dataSource[indexPath.row];
        ProdConfigViewController *vc = [[ProdConfigViewController alloc] initWithNibName:@"ProdConfigViewController" bundle:nil];
        vc.controller = self;
        vc.obj = obj;
        NSString *type;
        if ([obj.type isEqualToString:@"pz"]) {
           type = @"配资";
        }else if ([obj.type isEqualToString:@"xg"]){
            type = @"打新股";

        }else if ([obj.type isEqualToString:@"sb"]){
            type = @"新三板";

        }else if ([obj.type isEqualToString:@"dx"]){
            type = @"定向增发";
        }
        vc.type = type;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.selectType == 4){
       
        SHGCollectCardClass * obj = self.dataSource[indexPath.row];
        SHGPersonalViewController * vc = [[SHGPersonalViewController alloc]init];
        //vc.controller = self;
        vc.userId = obj.uid;
        [self.navigationController pushViewController:vc animated:YES];
    

    } else if (self.selectType == 2) {
        if (self.marketList.count > 0) {
            
            SHGMarketObject *obj = [self.marketList objectAtIndex:indexPath.row];
            SHGMarketDetailViewController *  viewController =[[SHGMarketDetailViewController alloc] initWithNibName:@"SHGMarketDetailViewController" bundle:nil];
           // viewController.controller = self;
            viewController.object = obj;
            [self.navigationController pushViewController:viewController animated:YES];
        }

    }
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];

    }    return _dataSource;
}
- (NSMutableArray *)productList{
    if (!_productList) {
        _productList = [NSMutableArray array];
    }
    return _productList;
}
- (NSMutableArray *)postList{
    if (!_postList) {
        _postList = [NSMutableArray array];
    }
    return _postList;
}
- (NSMutableArray *)cardList{
    if (!_cardList) {
        _cardList = [NSMutableArray array];
    }
    return _cardList;
}
- (NSMutableArray *)marketList{
    if (!_marketList) {
        _marketList = [NSMutableArray array];
    }
    return _marketList;
}

- (NSMutableArray *)newsList{
    if (!_newsList) {
        _newsList = [NSMutableArray array];
    }
    return _newsList;
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



#pragma mark detailDelagte

-(void)detailDeleteWithRid:(NSString *)rid
{
    for (CircleListObj *obj in self.dataSource) {
        if ([obj.rid isEqualToString:rid]) {
            [self.dataSource removeObject:obj];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_DELETE_CLICK object:obj];
            break;
        }
    }
    [self.tableView reloadData];
}

-(void)detailPraiseWithRid:(NSString *)rid praiseNum:(NSString *)num isPraised:(NSString *)isPrased
{
    for (CircleListObj *obj in self.dataSource) {
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
    for (CircleListObj *obj in self.dataSource) {
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
    for (CircleListObj *obj in self.dataSource) {
        if ([obj.userid isEqualToString:rid]) {
            obj.isattention = atten;
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:obj];
        }
    }
    [self.tableView reloadData];
}

-(void)detailCommentWithRid:(NSString *)rid commentNum:(NSString*)num comments:(NSMutableArray *)comments
{
    for (CircleListObj *obj in self.dataSource) {
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
- (void)changeMarketCollection
{
    [self requestMarketCollectWithTarget:@"first" time:@"-1"];
}
- (void)changeProductCollection
{
    [self requestProductListWithTarget:@"first" time:@"-1"];
}
- (void)changeCardCollection
{
    [self requestCardListWithTarget:@"first" time:@"-1"];
}
#pragma mark ------SHGMarketTableViewCellDelegate
- (void)clickPrasiseButton:(SHGMarketObject *)object
{
    [[SHGMarketSegmentViewController sharedSegmentController] addOrDeletePraise:object block:^(BOOL success) {
        
    }];
    [self.tableView reloadData];
}
- (void)clickCollectButton:(SHGMarketObject *)object state:(void (^)(BOOL))block
{
    __weak typeof(self) weakSelf = self;
    [[SHGMarketSegmentViewController sharedSegmentController] addOrDeleteCollect:object state:^(BOOL state) {
        [weakSelf.dataSource removeObject:object];
        [weakSelf.tableView reloadData];
    }];
    
    
}
- (void)clickCommentButton:(SHGMarketObject *)object
{
    SHGMarketDetailViewController *controller = [[SHGMarketDetailViewController alloc] init];
    controller.object = object;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickEditButton:(SHGMarketObject *)object
{
    SHGMarketSendViewController *controller = [[SHGMarketSendViewController alloc] init];
    controller.object = object;
    controller.delegate = [SHGMarketSegmentViewController sharedSegmentController];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickDeleteButton:(SHGMarketObject *)object
{
    [[SHGMarketSegmentViewController sharedSegmentController] deleteMarket:object];
}

@end
