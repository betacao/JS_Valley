//
//  SHGUserCenterViewController.m
//  Finance
//
//  Created by changxicao on 16/1/28.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGUserCenterViewController.h"

@interface SHGUserCenterViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView     *tableView;
@property (strong, nonatomic) UIView          *tableHeaderView;
@property (strong, nonatomic) UIImageView     *userHeaderView;
@property (strong, nonatomic) UILabel         *departmentLabel;
@property (strong, nonatomic) UILabel         *nickNameLabel;
@property (strong, nonatomic) UILabel         *companyLabel;
@property (strong, nonatomic) UIView          *lineView;

@property (strong, nonatomic) UIView          *messageView;
@property (strong, nonatomic) UIView          *labelView;

@property (strong, nonatomic) UIButton      *authButton;
@property (strong, nonatomic) NSString      *nickName;
@property (strong, nonatomic) NSString      *department;
@property (strong, nonatomic) NSString      *company;
@property (strong, nonatomic) NSString      *industry;
@property (strong, nonatomic) NSString      *location;
@property (strong, nonatomic) NSString      *imageUrl;


@property (assign, nonatomic) BOOL shouldRefresh;
@property (strong, nonatomic) NSString *auditState;

@end

@implementation SHGUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:NO];

    self.tableView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);

    self.userHeaderView.sd_layout
    .leftSpaceToView(self.tableHeaderView, 19.0f)
    .topSpaceToView(self.tableHeaderView, 17.0f)
    .widthIs(45.0f)
    .heightEqualToWidth();

    self.nickNameLabel.sd_layout
    .leftSpaceToView(self.userHeaderView, 11.0f)
    .topEqualToView(self.userHeaderView)
    .autoHeightRatio(0);
    [self.nickNameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.departmentLabel.sd_layout
    .leftSpaceToView(self.nickNameLabel, 4.0f)
    .topEqualToView(self.nickNameLabel)
    .autoHeightRatio(0);
    [self.departmentLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.companyLabel.sd_layout
    .leftEqualToView(self.nickNameLabel)
    .bottomEqualToView(self.userHeaderView)
    .autoHeightRatio(0);
    [self.companyLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.lineView.sd_layout
    .leftSpaceToView(self.tableHeaderView, 0.0f)
    .rightSpaceToView(self.tableHeaderView, 0.0f)
    .topSpaceToView(self.userHeaderView, 17.0f)
    .heightIs(0.5f);

    [self.tableHeaderView setupAutoHeightWithBottomView:self.lineView bottomMargin:0];
    [self.tableHeaderView layoutSubviews];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.shouldRefresh){
        [self getMyselfMaterial];
    } else{
        self.shouldRefresh = YES;
    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kNavBarTitleFontSize];
        _titleLabel.textColor = TEXT_COLOR;
        _titleLabel.text = @"我";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIBarButtonItem *)rightBarButtonItem
{
    if (!_rightBarButtonItem) {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(actionInvite:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"邀请" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button sizeToFit];
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _rightBarButtonItem;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setTableHeaderView:self.tableHeaderView];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] init];
        [_tableHeaderView addSubview:self.userHeaderView];
        [_tableHeaderView addSubview:self.nickNameLabel];
        [_tableHeaderView addSubview:self.companyLabel];
        [_tableHeaderView addSubview:self.departmentLabel];
        [_tableHeaderView addSubview:self.lineView];
    }
    return _tableHeaderView;
}

- (UIImageView *)userHeaderView
{
    if (!_userHeaderView) {
        _userHeaderView = [[UIImageView alloc] init];
    }
    return _userHeaderView;
}

- (UILabel *)nickNameLabel
{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = [UIFont systemFontOfSize:16.0f];
        _nickNameLabel.textColor = [UIColor colorWithHexString:@"1d5798"];
    }
    return _nickNameLabel;
}

- (UILabel *)companyLabel
{
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
        _companyLabel.font = [UIFont systemFontOfSize:14.0f];
        _companyLabel.textColor = [UIColor colorWithHexString:@"161616"];
    }
    return _companyLabel;
}

- (UILabel *)departmentLabel
{
    if (!_departmentLabel) {
        _departmentLabel = [[UILabel alloc] init];
        _departmentLabel.font = [UIFont systemFontOfSize:14.0f];
        _departmentLabel.textColor = [UIColor colorWithHexString:@"161616"];
    }
    return _departmentLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    }
    return _lineView;
}


-(void)refreshHeader
{
    [self getMyselfMaterial];
}

#pragma mark ------获取数据
- (void)getMyselfMaterial
{
    [self.userHeaderView setImage:[UIImage imageNamed:@"default_head"]];
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"personaluser"] parameters:@{@"uid":UID} success:^(MOCHTTPResponse *response) {

        NSString *circleCount = [response.dataDictionary valueForKey:@"circles"];
        NSString *followCount = [response.dataDictionary valueForKey:@"attention"];
        NSString *fansCount = [response.dataDictionary valueForKey:@"fans"];

        NSString *circleString = [NSString stringWithFormat:@"动态 \n%@",circleCount];
        NSString *followString = [NSString stringWithFormat:@"关注 \n%@",followCount];
        NSString *fansString = [NSString stringWithFormat:@"粉丝 \n%@",fansCount];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:1.0f];
        paragraphStyle1.alignment = NSTextAlignmentCenter;
        NSMutableAttributedString *aCircleString = [[NSMutableAttributedString alloc] initWithString:circleString];
        [aCircleString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"161616"] range:NSMakeRange(4, aCircleString.length - 4)];
        [aCircleString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [aCircleString length])];

        NSMutableAttributedString *aFollowString = [[NSMutableAttributedString alloc] initWithString:followString];
        [aFollowString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"161616"] range:NSMakeRange(4, aFollowString.length - 4)];
        [aFollowString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [aFollowString length])];

        NSMutableAttributedString *aFansString = [[NSMutableAttributedString alloc] initWithString:fansString];
        [aFansString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"161616"] range:NSMakeRange(4, aFansString.length - 4)];
        [aFansString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [aFansString length])];

//        weakSelf.circleHeaderLabel.attributedText = aCircleString;
//        weakSelf.followHeaderLabel.attributedText = aFollowString;
//        weakSelf.fansHeaderLabel.attributedText = aFansString;

        weakSelf.nickNameLabel.text = [response.dataDictionary valueForKey:@"name"];
        weakSelf.nickName = [response.dataDictionary valueForKey:@"name"];
        if([response.dataDictionary valueForKey:@"titles"]){
            weakSelf.departmentLabel.text = [response.dataDictionary valueForKey:@"titles"];
            weakSelf.department = self.departmentLabel.text;
        } else{
            weakSelf.departmentLabel.text = @"暂无职称";
        }
        if([response.dataDictionary valueForKey:@"companyname"]){
            weakSelf.companyLabel.text = [response.dataDictionary valueForKey:@"companyname"];
            weakSelf.company = self.companyLabel.text;
        } else{
            weakSelf.companyLabel.text = @"暂无公司名";
        }

        if([response.dataDictionary valueForKey:@"industrycode"]){
            weakSelf.industry = [response.dataDictionary valueForKey:@"industrycode"];
        }

        if([response.dataDictionary valueForKey:@"head_img"]){
            weakSelf.imageUrl = [response.dataDictionary valueForKey:@"head_img"];
        }

        if([response.dataDictionary valueForKey:@"position"]){
            weakSelf.location = [response.dataDictionary valueForKey:@"position"];
        }

        NSString *headImageUrl = [response.dataDictionary valueForKey:@"head_img"];
        if (!IsStrEmpty(headImageUrl)) {
            UIImage *placeImage = weakSelf.userHeaderView.image;
            if(!placeImage){
                placeImage = [UIImage imageNamed:@"default_head"];
            }
            [weakSelf.userHeaderView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,headImageUrl]] placeholderImage:placeImage];
        }

        if ([response.dataDictionary objectForKey:@"auditstate"]) {
            self.auditState = [response.dataDictionary objectForKey:@"auditstate"];
            if ([self.auditState isEqualToString:@"0"]) {
                [self.authButton setImage:[UIImage imageNamed:@"me_unAuth"] forState:UIControlStateNormal];
            } else if ([self.auditState isEqualToString:@"1"]){
                [self.authButton setImage:[UIImage imageNamed:@"me_authed"] forState:UIControlStateNormal];
            } else if ([self.auditState isEqualToString:@"2"]){
                [self.authButton setImage:[UIImage imageNamed:@"me_authering"] forState:UIControlStateNormal];
            } else{
                [self.authButton setImage:[UIImage imageNamed:@"me_rejected"] forState:UIControlStateNormal];
            }
        }

        [weakSelf.tableView.header endRefreshing];

        [weakSelf.tableHeaderView layoutSubviews];
    } failed:^(MOCHTTPResponse *response) {
        [weakSelf.tableView.header endRefreshing];
        
    }];
}

#pragma mark -邀请好友
- (void)actionInvite:(id)sender
{
    __weak typeof(self) weakSelf = self;
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:[UIImage imageNamed:@"80"]];
    NSString *contentOther =[NSString stringWithFormat:@"%@",@"诚邀您加入金融大牛圈！金融从业人员的家！"];
    NSString *content =[NSString stringWithFormat:@"%@%@",@"诚邀您加入大牛圈APP！金融从业人员的家！这里有干货资讯、人脉嫁接、业务互助！赶快加入吧！",[NSString stringWithFormat:@"%@?uid=%@",SHARE_YAOQING_URL,[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID]]];
    id<ISSShareActionSheetItem> item3 = [ShareSDK shareActionSheetItemWithTitle:@"短信" icon:[UIImage imageNamed:@"sns_icon_19"] clickHandler:^{
        [weakSelf shareToSMS:content];
    }];

    NSString *shareUrl =[NSString stringWithFormat:@"%@?uid=%@",SHARE_YAOQING_URL,[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID]];
    id<ISSShareActionSheetItem> item4 = [ShareSDK shareActionSheetItemWithTitle:@"微信朋友圈" icon:[UIImage imageNamed:@"sns_icon_23"] clickHandler:^{
        [[AppDelegate currentAppdelegate] wechatShareWithText:contentOther shareUrl:shareUrl shareType:1];
    }];
    id<ISSShareActionSheetItem> item5 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友" icon:[UIImage imageNamed:@"sns_icon_22"] clickHandler:^{
        [[AppDelegate currentAppdelegate] wechatShareWithText:contentOther shareUrl:shareUrl shareType:0];
    }];

    NSArray *shareArray = nil;
    if ([WXApi isWXAppSupportApi]) {
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: item3, item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item3, item5, item4, nil];
        }
    } else{
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: item3, SHARE_TYPE_NUMBER(ShareTypeQQ), nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item3, nil];
        }
    }


    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:contentOther defaultContent:SHARE_DEFAULT_CONTENT image:image title:SHARE_TITLE_INVITE url:shareUrl description:SHARE_DEFAULT_CONTENT mediaType:SHARE_TYPE];

    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:shareArray content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess){
            [MobClick event:@"ActionInviteFriend" label:@"onClick"];
            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
        }
        else if (state == SSResponseStateFail){
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
            
        }
    }];
}

-(void)shareToSMS:(NSString *)text
{
    [[AppDelegate currentAppdelegate] sendSmsWithText:text rid:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
