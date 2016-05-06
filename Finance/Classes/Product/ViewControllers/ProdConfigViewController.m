//
//  ProdConfigViewController.m
//  Finance
//
//  Created by HuMin on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//
#import "ChatViewController.h"
#import "ProdConfigViewController.h"
#import "ProdConfigTableViewCell.h"
#import "ConfigObj.h"
#import "AppDelegate.h"
#define kNumberOfRows 1
#define kHeightForNormalCell 44.0f

@interface ProdConfigViewController ()<ProdConfigDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnCollet;
@property (weak, nonatomic) IBOutlet UILabel *lblPercent;
@property (weak, nonatomic) IBOutlet UILabel *lblRight2;
@property (weak, nonatomic) IBOutlet UILabel *lblRight1;
@property (weak, nonatomic) IBOutlet UILabel *lblLeft2;
@property (weak, nonatomic) IBOutlet UILabel *lblLeft1;
@property (weak, nonatomic) IBOutlet UILabel *lblProdName;
@property (strong, nonatomic) IBOutlet UIView *viewFooter;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableList;
@property (strong, nonatomic) NSMutableArray *heightArray;
@property (strong, nonatomic) UIView *footerView;
@property (assign, nonatomic) BOOL isProductChange;
//业务介绍 产品信息 和业务流程的cell这边写死 不会去重复加载了
//如果想写的灵活 就要使用缓存了
@property (strong, nonatomic) ProdConfigTableViewCell *infomationCell;
@property (strong, nonatomic) NSArray *cellArray;


- (IBAction)actionTel:(id)sender;
- (IBAction)actionGo:(id)sender;
- (IBAction)actionShare:(id)sender;
- (IBAction)actionCollet:(id)sender;


@end

@implementation ProdConfigViewController


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isProductChange = YES;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"consult"] forState:UIControlStateNormal];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if (SCREENHEIGHT == 480) {
        CGRect rect = self.tableList.frame;
        rect.size.height = 480;
        self.tableList.frame = rect;
    }
    self.tableList.backgroundColor = RGB(242, 242, 242);
    self.tableList.tableHeaderView = self.viewHeader;
    [CommonMethod setExtraCellLineHidden:self.tableList];
    NSString *title = @"股票配资";
    if (![self.type isEqualToString:@"配资"]) {
        title =  [NSString stringWithFormat:@"%@产品",self.type];
    }
    self.title = @"产品详情";
    
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpProd,@"allotcapital/ratioterm",self.obj.pid] class:[ConfigObj class] parameters:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]} success:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.data);
        if (!IsArrEmpty(response.dataArray)) {
            ConfigObj *obj1 = [[ConfigObj alloc] init];
            obj1.left = @"比例期限";
            obj1.three = @"3个月";
            obj1.six = @"6个月";
            obj1.nine = @"9个月";
            obj1.twelve = @"12个月";
            if (response.dataArray.count > 0) {
                [self configDataWithArr:response.dataArray];
            }
            [self.dataArr addObject:obj1];
            [self.dataArr addObjectsFromArray:response.dataArray];

        }
        [self.tableList reloadData];
        
    } failed:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.error);

    }];
    [self initView];
}

- (NSMutableArray *)heightArray
{
    if(!_heightArray){
        _heightArray = [NSMutableArray array];
        for (NSInteger i = 0; i < kNumberOfRows; i++) {
            [_heightArray addObject:@(kHeightForNormalCell)];
        }
    }
    return _heightArray;
}

- (UIView *)footerView
{
    if(!_footerView){
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _footerView;
}


- (ProdConfigTableViewCell *)infomationCell
{
    if(!_infomationCell){
        _infomationCell = [[[NSBundle mainBundle] loadNibNamed:@"ProdConfigTableViewCell" owner:self options:nil] lastObject];
        _infomationCell.delegate = self;
        NSString *url = [NSString stringWithFormat:@"%@/other/%@",rBaseAddressForHttpProd,self.obj.pid];
        [_infomationCell loadRequest:url];
    }
    return _infomationCell;
}


-(void)rightItemClick:(id)sender
{
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:CHATID_MANAGER isGroup:NO];
    chatVC.title = CHAT_NAME_MANAGER;
    [self.navigationController pushViewController:chatVC animated:YES];
}
-(void)configDataWithArr:(NSArray *)arr
{
    for (int i = 0; i < arr.count ; i ++)
    {
        ConfigObj *obj = arr[i];
        obj.left = [NSString stringWithFormat:@"1配%d",i+2];
    }
}
-(void)initView
{
    _lblProdName.text = self.obj.name;
    if (!IsStrEmpty(_obj.commision)) {
        _lblPercent.text = [NSString stringWithFormat:@"%@%@",self.obj.commision,@"%"];
    }
    _lblLeft1.text = self.obj.left1;
    _lblLeft2.text = self.obj.left2;
    _lblRight1.text = self.obj.right1;

    _lblRight2.text = self.obj.right2;
    NSString *imaeName ;
    if ([_obj.iscollected boolValue]) {
        imaeName = @"已收藏prod";
    }else{
        imaeName = @"收藏prod";

    }
    [_btnCollet setImage:[UIImage imageNamed:imaeName] forState:UIControlStateNormal];

    self.cellArray = @[self.infomationCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionTel:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:MANAGER_PHONE otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSURL *call = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",MANAGER_PHONE]];
        if ([[UIApplication sharedApplication] canOpenURL:call]) {
            [[UIApplication sharedApplication] openURL:call];
        }
    }
}

- (void)go
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpProd,@"appointment"];
    [Hud showWait];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID], @"pid":_obj.pid};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];

        NSLog(@"%@",response.data);
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            NSString *value = response.dataDictionary[@"value"];
            ProdConsulutionViewController *vc = [[ProdConsulutionViewController alloc] initWithNibName:@"ProdConsulutionViewController" bundle:nil];
            vc.codeStr = value;
            [self.navigationController pushViewController:vc animated:YES];

        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];

        [Hud showMessageWithText:response.errorMessage];
    }];
}
- (IBAction)actionGo:(id)sender {
    SHGAlertView *alert = [[SHGAlertView alloc] initWithTitle:@"提示" contentText:@"是否预约该产品？" leftButtonTitle:@"否" rightButtonTitle:@"是"];
    __weak typeof(self) weakSelf = self;
    alert.rightBlock = ^{
        [weakSelf go];
    };
    
    [alert show];
}
-(void)shareToSMS:(NSString *)text
{
    [[AppDelegate currentAppdelegate] sendSmsWithText:text rid:@""];
}


-(void)shareToWeibo:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendmessageToShareWithObjContent:text rid:rid];
}
- (IBAction)actionShare:(id)sender {

    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:[UIImage imageNamed:@"80"]];

    NSString *name = self.obj.name;
    if (self.obj.name.length > 15) {
        name = [NSString stringWithFormat:@"%@...",[self.obj.name substringToIndex:15]];
    }
    NSString *detail = [NSString stringWithFormat:@"%@：%@，%@，%@，%@，返佣费率%@%%",name,self.obj.left1,self.obj.right1,self.obj.left2,self.obj.right2,self.obj.commision];
    detail = name;
    id<ISSShareActionSheetItem> item1 = [ShareSDK shareActionSheetItemWithTitle:@"圈内好友" icon:[UIImage imageNamed:@"圈内好友图标"] clickHandler:^{
        NSString *text = [NSString stringWithFormat:@"%@%@",@"Hi，我在金融大牛圈上看到了一款非常好的金融产品:",self.obj.name];
        NSString *detail = [NSString stringWithFormat:@"，%@%@，%@，%@，",self.obj.left1,self.obj.right1,self.obj.left2,self.obj.right2];

        NSString *remain = @"想了解的话到发现模块去看吧！";
        NSString *shareContent = [NSString stringWithFormat:@"%@%@%@",text,detail,remain];
        [self shareToFriendWithText:shareContent];
    }];
    id<ISSShareActionSheetItem> item3 = [ShareSDK shareActionSheetItemWithTitle:@"短信" icon:[UIImage imageNamed:@"sns_icon_19"] clickHandler:^{
        NSString *content = [NSString stringWithFormat:@"Hi，我在金融大牛圈上看到了一款非常好的%@金融产品，分享给你一起赚钱哦，赶快下载大牛圈查看吧！%@",self.type,[NSString stringWithFormat:@"%@%@", rBaseAddressForHttpProductShare,self.obj.pid]];
        [self shareToSMS:content];
    }];

    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",rBaseAddressForHttpProductShare,self.obj.pid];

    id<ISSShareActionSheetItem> item4 = [ShareSDK shareActionSheetItemWithTitle:@"微信朋友圈" icon:[UIImage imageNamed:@"sns_icon_23"] clickHandler:^{
        [[AppDelegate currentAppdelegate] wechatShareWithText:detail shareUrl:shareUrl shareType:1];
    }];
    id<ISSShareActionSheetItem> item5 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友" icon:[UIImage imageNamed:@"sns_icon_22"] clickHandler:^{
        [[AppDelegate currentAppdelegate] wechatShareWithText:detail shareUrl:shareUrl shareType:0];
    }];
//    NSArray *shareList = [ShareSDK customShareListWithType: item3, item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), item1,nil];

    NSArray *shareArray = nil;
    if ([WXApi isWXAppSupportApi]) {
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), item3, item1, nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item5, item4, item3, item1, nil];
        }
    } else{
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: SHARE_TYPE_NUMBER(ShareTypeQQ), item3, item1, nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item3, item1, nil];
        }
    }

    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:detail defaultContent:detail image:image title:SHARE_TITLE url:shareUrl description:detail mediaType:SHARE_TYPE];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:shareArray content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {

        if (state == SSResponseStateSuccess){
            [self otherShareWithObj:_obj];
            [[SHGGloble sharedGloble] recordUserAction:_obj.pid type:@"dynamic_shareQQ"];
            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));

        } else if (state == SSResponseStateFail){
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
        }
    }];


}

- (void)otherShareWithObj:(ProdListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.pid];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [MOCHTTPRequestOperationManager putWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            [Hud showMessageWithText:@"分享成功"];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
}

- (void)shareToFriendWithText:(NSString *)text
{
    __weak typeof(self) weakSelf = self;
    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state) {
        if (state) {
            FriendsListViewController *vc=[[FriendsListViewController alloc] init];
            vc.isShare = YES;
            vc.shareContent = text;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else{
            SHGAuthenticationViewController *controller = [[SHGAuthenticationViewController alloc] init];
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
    } showAlert:YES leftBlock:nil failString:@"认证后才能进行操作哦～"];


}

- (IBAction)actionCollet:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpProd,@"collection"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID], @"pid":self.obj.pid};
    __weak typeof(self)weakSelf = self;
    if ([self.obj.iscollected boolValue]){
        [MOCHTTPRequestOperationManager deleteWithURL:url parameters:param success:^(MOCHTTPResponse *response) {
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                weakSelf.obj.iscollected = @"0";
                [weakSelf.btnCollet setImage:[UIImage imageNamed:@"收藏prod"] forState:UIControlStateNormal];
            }
            weakSelf.isProductChange = NO;
            [Hud showMessageWithText:@"取消收藏"];
        } failed:^(MOCHTTPResponse *response) {
            [Hud showMessageWithText:response.errorMessage];
        }];
    } else{
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                ProdListObj *obj = _obj;
                obj.iscollected = @"1";
                weakSelf.obj = obj;
                [weakSelf.btnCollet setImage:[UIImage imageNamed:@"已收藏prod"] forState:UIControlStateNormal];
            }
            weakSelf.isProductChange = YES;
            [Hud showMessageWithText:@"收藏成功"];

        } failed:^(MOCHTTPResponse *response) {
            [Hud showMessageWithText:response.errorMessage];

        }];
    }
    
}

#pragma mark =============  UITableView DataSource  =============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [[self.heightArray objectAtIndex:indexPath.row] floatValue];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.infomationCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(self.dataArr && self.dataArr.count > 0){
        return CGRectGetHeight(self.footerView.frame);
    } else{
        return 0.0f;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!IsArrEmpty(self.dataArr)) {
        if([self.footerView subviews].count == 0){
            for (int i = 0; i < self.dataArr.count; i++){
                ConfigObj *obj = self.dataArr[i];
                CinfigView *view = [[[NSBundle mainBundle] loadNibNamed:@"ConfigView" owner:self options:nil] lastObject];
                CGRect frame = self.footerView.frame;
                [view setFrame:CGRectMake(0, 34.0f * i, SCREENWIDTH, 34.0f)];
                [view configViewWithObj:obj];
                frame.size.height = CGRectGetMaxY(view.frame);
                frame.size.width = SCREENWIDTH;
                self.footerView.frame = frame;
                [self.footerView addSubview:view];
            }
        } else{
            return self.footerView;
        }
    }
    return nil;
}

- (void)didUpdateCell:(ProdConfigTableViewCell *)cell height:(CGFloat)height
{
    NSInteger index = [self.cellArray indexOfObject:cell];
    if([[self.heightArray objectAtIndex:index] floatValue] == kHeightForNormalCell){
        [self.heightArray replaceObjectAtIndex:index withObject:@(height)];
        [self.tableList reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kNumberOfRows;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
