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
#import "SHGHomeTableViewCell.h"
#import "ProductListTableViewCell.h"
#import "SHGPersonalViewController.h"
#import "SHGCardTableViewCell.h"
@interface MyCollectionViewController ()
{
    BOOL hasDataFinished;
    NSInteger photoIndex;
    CircleListObj *deleteObj;
}

@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *postList;

@property (nonatomic, strong) NSMutableArray *productList;

@property (nonatomic, assign) NSInteger	selectType;

@property (nonatomic, strong) NSMutableArray * cardList;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
	self.selectType = 1;
	self.navigationItem.titleView = self.segmentControl;
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];
    self.tableView.header.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [CommonMethod setExtraCellLineHidden:self.tableView];
    self.tableView.separatorStyle = 1;
    [Hud showLoadingWithMessage:@"加载中"];
	[self requestPostListWithTarget:@"first" time:@"-1"];

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

- (UISegmentedControl *)segmentControl
{
	if (!_segmentControl) {
		
		_segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(58, 0, 208, 30)];
		
		[_segmentControl insertSegmentWithTitle:@"帖子" atIndex:0 animated:YES];
		
		[_segmentControl insertSegmentWithTitle:@"产品" atIndex:1 animated:YES];
		[_segmentControl insertSegmentWithTitle:@"名片" atIndex:2 animated:YES];
		_segmentControl.selectedSegmentIndex = 0;
		
		[_segmentControl addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
		
		[_segmentControl setTintColor:RGB(248, 92, 83)];
		
		NSDictionary *titleArributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil];
		
		[_segmentControl setTitleTextAttributes:titleArributes forState:UIControlStateNormal];
		[_segmentControl setTitleTextAttributes:titleArributes forState:UIControlStateHighlighted];
		
	}
	return _segmentControl;
}

- (void)selected:(id)sender
{
  
	UISegmentedControl* control = (UISegmentedControl*)sender;
	switch (control.selectedSegmentIndex) {
		case 0:
		{
			self.selectType = 1;
            self.tableView.separatorStyle = 1;
            [Hud showLoadingWithMessage:@"加载中"];
			[self requestPostListWithTarget:@"first" time:@"-1"];
		}
			break;
		case 1:
		{
            self.tableView.separatorStyle = 0;
             self.selectType = 2;
            [Hud showLoadingWithMessage:@"加载中"];
            [self requestProductListWithTarget:@"first" time:@""];
            
		}
			break;
        case 2:
        {
            self.tableView.separatorStyle = 0;
            self.selectType = 3;
            [Hud showLoadingWithMessage:@"加载中"];
            [self requestCardListWithTarget:@"first" time:@"-1" ];
            
            
        }
            break;
		default:
			break;
	}
}

- (void)refreshDataSource
{
	if (self.selectType == 1) {
		self.dataSource = self.postList;
	}else if (self.selectType == 2){
		self.dataSource = self.productList;
    }else if (self.selectType == 3){
        self.dataSource = self.cardList;
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
		}else if (self.selectType == 2){
            ProdListObj *obj = self.dataSource[0];
            updateTime = obj.time;
			[self requestProductListWithTarget:target time:updateTime];
		}
        else if (self.selectType == 3){
            SHGCollectCardClass *obj = self.dataSource[0];
            updateTime = obj.collectTime;
            [self requestCardListWithTarget:target time:updateTime];
        }

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
		}else if (self.selectType == 2){
			[self requestProductListWithTarget:@"load" time:updateTime];
        }else if (self.selectType == 3){
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
                    [self.dataSource insertObject:obj atIndex:0];
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
    NSDictionary *dic = @{@"rid":obj.rid,
                          @"uid":obj.userid};
    [[AFHTTPRequestOperationManager manager] DELETE:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"])
        {
            [self detailDeleteWithRid:obj.rid];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_DELETE_CLICK object:obj];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Hud showMessageWithText:error.domain];
    }];
}

- (void)praiseClicked:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"praisesend"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],@"rid":obj.rid};

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
            [self.tableView reloadData];
            
            
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
        
    }
    else
    {
        [Hud showLoadingWithMessage:@"正在取消点赞"];

        [[AFHTTPRequestOperationManager manager] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                obj.ispraise = @"N";
                obj.praisenum = [NSString stringWithFormat:@"%ld",(long)[obj.praisenum integerValue] -1];
                [Hud showMessageWithText:@"取消点赞"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_PRAISE_CLICK object:obj];

            }
            [self.tableView reloadData];
            [Hud hideHud];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Hud showMessageWithText:error.domain];
            [Hud hideHud];

        }];
    }
}

-(void)gotoSomeOne:(NSString *)uid name:(NSString *)name
{
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    controller.userId = uid;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    
}
-(void)headTap:(NSInteger)index
{
    
    CircleListObj *obj = self.dataSource[index];
    [self gotoSomeOne:obj.userid name:obj.nickname];
    
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
        postContent = [NSString stringWithFormat:@"%@…",[obj.detail substringToIndex:15]];
    }
    if (obj.detail.length > 15)
    {
        
        shareTitle = [obj.detail substringToIndex:15];
        
        shareContent = [NSString stringWithFormat:@"%@…",[obj.detail substringToIndex:15]];
        
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
            shareArray = [ShareSDK customShareListWithType: item3, item5, item4, item0, item1, item2, nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item3, item5, item4, item1, item2, nil];
        }
    } else{
        if ([WeiboSDK isCanShareInWeiboAPP]) {
            shareArray = [ShareSDK customShareListWithType: item3, item0, item1, item2, nil];
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

-(void)otherShareWithObj:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [[AFHTTPRequestOperationManager manager] PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            // [self refreshData];
            obj.sharenum = [NSString stringWithFormat:@"%ld",(long)[obj.sharenum integerValue]+1];
            [self.tableView reloadData];
            [Hud showMessageWithText:@"分享成功"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Hud showMessageWithText:error.domain];
        
    }];
}

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
            [self.tableView reloadData];
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
    } else{
        [[AFHTTPRequestOperationManager manager] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            [self.tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
	return self.dataSource.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectType == 1) {
        CircleListObj *obj = self.dataSource[indexPath.row];
        if ([obj.status boolValue]) {
            return [obj fetchCellHeight];
        }
        else{
            return 44;
        }
    }else if (self.selectType == 2)
    {
        return 100;
        
    }
    else if (self.selectType == 3)
    {
        return 144;
        
    }else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectType == 1) {
        CircleListObj *obj = self.dataSource[indexPath.row];
        
        if ([obj.status boolValue]) {
            NSString *cellIdentifier = @"circleListIdentifier";
            SHGHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGHomeTableViewCell" owner:self options:nil] lastObject];
            }
            cell.index = indexPath.row;
            cell.delegate = self;
            [cell loadDatasWithObj:obj type:@"normal"];
            return cell;
        }
        
        else
        {
            NSString *cellIdentifier = @"noListIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.textLabel.text = @"原帖已删除";
            cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
            
            return cell;
        }

    }else if (self.selectType == 2)
    {
        NSString *prodCellIdentifier = @"circleCellIdentifier";
        ProductListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:prodCellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductListTableViewCell" owner:self options:nil] lastObject];
        }
        ProdListObj *obj = self.dataSource[indexPath.row];
        [cell loadDatasWithObj:obj];
        return cell;
    }if (self.selectType == 3) {
        NSString *cardCellIdentifier = @"SHGCardTableViewCell";
        SHGCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cardCellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGCardTableViewCell" owner:self options:nil] lastObject];
        }
        SHGCollectCardClass *obj = self.dataSource[indexPath.row];
        [cell loadCardDatasWithObj:obj];
        return cell;
        
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
    }else if (self.selectType == 2)
    {
        ProdListObj *obj = self.dataSource[indexPath.row];
        ProdConfigViewController *vc = [[ProdConfigViewController alloc] initWithNibName:@"ProdConfigViewController" bundle:nil];
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
    }else if (self.selectType == 3)
    {
       
        SHGCollectCardClass * obj = self.dataSource[indexPath.row];
        SHGPersonalViewController * vc = [[SHGPersonalViewController alloc]init];
        vc.userId = obj.uid;
        [self.navigationController pushViewController:vc animated:YES];
    

    }
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableArray *)productList{
    if (!_productList) {
        _productList = [NSMutableArray array];
    }
    return _productList;
}
-(NSMutableArray *)postList{
    if (!_postList) {
        _postList = [NSMutableArray array];
    }
    return _postList;
}
-(NSMutableArray *)cardList{
    if (!_cardList) {
        _cardList = [NSMutableArray array];
    }
    return _cardList;
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
}

@end
