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
@property (strong, nonatomic) IBOutlet UIView *configView;
@property (weak, nonatomic) IBOutlet UITableView *tableList;
@property (strong, nonatomic) NSMutableArray *heightArray;

//业务介绍 产品信息 和业务流程的cell这边写死 不会去重复加载了
//如果想写的灵活 就要使用缓存了
@property (strong, nonatomic) ProdConfigTableViewCell *intoductionCell;
@property (strong, nonatomic) ProdConfigTableViewCell *infomationCell;
@property (strong, nonatomic) ProdConfigTableViewCell *flowCell;
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
  
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 24, 24)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"咨询"] forState:UIControlStateNormal];
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
        for (NSInteger i = 0; i < 3; i++) {
            [_heightArray addObject:@(44.0f)];
        }
    }
    return _heightArray;
}

- (ProdConfigTableViewCell *)intoductionCell
{
    if(!_intoductionCell){
        _intoductionCell = [[[NSBundle mainBundle] loadNibNamed:@"ProdConfigTableViewCell" owner:self options:nil] lastObject];
        _intoductionCell.delegate = self;
        _intoductionCell.lblDetail.text = @"业务介绍";
        NSString *url = [NSString stringWithFormat:@"%@/businessintroduction/%@",rBaseAddressForHttpProd,self.obj.pid];
        [_intoductionCell loadHtml:url];
    }
    return _intoductionCell;
}

- (ProdConfigTableViewCell *)infomationCell
{
    if(!_infomationCell){
        _infomationCell = [[[NSBundle mainBundle] loadNibNamed:@"ProdConfigTableViewCell" owner:self options:nil] lastObject];
        _infomationCell.delegate = self;
        _infomationCell.lblDetail.text = @"产品信息";
        NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpProd,self.obj.pid];
        [_infomationCell loadRequest:url];
    }
    return _infomationCell;
}


- (ProdConfigTableViewCell *)flowCell
{
    if(!_flowCell){
        _flowCell = [[[NSBundle mainBundle] loadNibNamed:@"ProdConfigTableViewCell" owner:self options:nil] lastObject];
        _flowCell.delegate = self;
        _flowCell.lblDetail.text = @"业务流程";
        NSString *url = [NSString stringWithFormat:@"%@/businessprocess/%@",rBaseAddressForHttpProd,self.obj.pid];
        [_flowCell loadHtml:url];
    }
    return _flowCell;
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

    self.cellArray = @[self.intoductionCell,self.infomationCell,self.flowCell];
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
-(void)go
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpProd,@"appointment"];
    [Hud showLoadingWithMessage:@"正在预约……"];
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
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"是否预约该产品？" leftButtonTitle:@"否" rightButtonTitle:@"是"];
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
        name = [NSString stringWithFormat:@"%@…",[self.obj.name substringToIndex:15]];
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
        [[AppDelegate currentAppdelegate] wechatShareWithText:detail shareUrl:shareUrl shareType:1];
    }];
    NSArray *shareList = [ShareSDK customShareListWithType: item3, item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), item1,nil];

    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:detail defaultContent:detail image:image title:SHARE_TITLE url:shareUrl description:detail mediaType:SHARE_TYPE];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:shareList content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {

        if (state == SSResponseStateSuccess){
            [self otherShareWithObj:_obj];
            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));

        } else if (state == SSResponseStateFail){
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
            [Hud showMessageWithText:@"分享失败"];
        }
    }];


}

-(void)otherShareWithObj:(ProdListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.pid];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [[AFHTTPRequestOperationManager manager] PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            [Hud showMessageWithText:@"分享成功"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Hud showMessageWithText:error.domain];
    }];
}
-(void)shareToFriendWithText:(NSString *)text
{
    NSString *state = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUTHSTATE];
    if (![state boolValue]) {
        [Hud showNoAuthMessage];
        return;
    }
    FriendsListViewController *vc=[[FriendsListViewController alloc] init];
    vc.isShare = YES;
    vc.shareContent = text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionCollet:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpProd,@"collection"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID], @"pid":self.obj.pid};
    if ([_obj.iscollected boolValue]){
        [[AFHTTPRequestOperationManager manager ] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                _obj.iscollected = @"0";
                [_btnCollet setImage:[UIImage imageNamed:@"收藏prod"] forState:UIControlStateNormal];
            }
            [Hud showMessageWithText:@"取消收藏成功"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Hud showMessageWithText:error.domain];
        }];
    } else{
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                ProdListObj *obj = _obj;
                obj.iscollected = @"1";
                _obj = obj;
                [_btnCollet setImage:[UIImage imageNamed:@"已收藏prod"] forState:UIControlStateNormal];
            }
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
    if (indexPath.row == 0) {
        return self.intoductionCell;
    } else if (indexPath.row == 1) {
        return self.infomationCell;
    } else{
        return self.flowCell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 255;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!IsArrEmpty(self.dataArr)) {
        for (int i = 0; i < self.dataArr.count; i++)
        {
            ConfigObj *obj = self.dataArr[i];
            CinfigView *view = [[[NSBundle mainBundle] loadNibNamed:@"ConfigView" owner:self options:nil] lastObject];

            [view setFrame:CGRectMake(0, 34*i+15, SCREENWIDTH, 34)];
            [view configViewWithObj:obj];
            [self.configView addSubview:view];
        }
    }
    return self.configView;
}

- (void)didUpdateCell:(ProdConfigTableViewCell *)cell height:(CGFloat)height
{
    NSInteger index = [self.cellArray indexOfObject:cell];
    if([[self.heightArray objectAtIndex:index] integerValue] == 44){
        [self.heightArray replaceObjectAtIndex:index withObject:@(height)];
        [self.tableList reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SubDetailViewController *vc = [[SubDetailViewController alloc] initWithNibName:@"SubDetailViewController" bundle:nil];
    vc.pid = _obj.pid;
    switch (indexPath.row)
    {
        case 0:
        {
            vc.method = @"businessintroduction";

        }
            break;
        case 1:
        {
            vc.method = @"";

        }
            break;
        case 2:
        {
            //业务流程
         
            vc.method = @"businessprocess";
        }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];

}

@end
