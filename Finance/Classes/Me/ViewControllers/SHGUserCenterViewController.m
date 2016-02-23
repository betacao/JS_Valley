//
//  SHGUserCenterViewController.m
//  Finance
//
//  Created by changxicao on 16/1/28.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGUserCenterViewController.h"
#import "SHGPersonalViewController.h"
#import "MyFollowViewController.h"
#import "MyTeamViewController.h"
#import "MyMoneyViewController.h"
#import "MyAppointmentViewController.h"
#import "SHGMarketMineViewController.h"
#import "MyCollectionViewController.h"
#import "SettingsViewController.h"

#define kLabelWidth ceilf(SCREENWIDTH / 4.0f)

@interface SHGUserCenterViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UITableView     *tableView;
@property (strong, nonatomic) UIView          *tableHeaderView;
@property (strong, nonatomic) UIImageView     *userHeaderView;
@property (strong, nonatomic) UILabel         *departmentLabel;
@property (strong, nonatomic) UILabel         *nickNameLabel;
@property (strong, nonatomic) UILabel         *companyLabel;
@property (strong, nonatomic) UIView          *lineView;

@property (strong, nonatomic) UIView          *messageView;
@property (strong, nonatomic) UIView          *labelView;
@property (strong, nonatomic) UILabel	*circleHeaderLabel;  //动态lable
@property (strong, nonatomic) UILabel	*followHeaderLabel;  //关注label
@property (strong, nonatomic) UILabel	*fansHeaderLabel;  //粉丝label
@property (strong, nonatomic) UIView	*breakLine1;
@property (strong, nonatomic) UIView	*breakLine2;
@property (strong, nonatomic) UIView	*breakLine3;
@property (strong, nonatomic) UIView	*bottomView;


@property (strong, nonatomic) UIButton      *authButton;
@property (strong, nonatomic) NSString      *nickName;
@property (strong, nonatomic) NSString      *department;
@property (strong, nonatomic) NSString      *company;
@property (strong, nonatomic) NSString      *industry;
@property (strong, nonatomic) NSString      *location;
@property (strong, nonatomic) NSString      *imageUrl;


@property (assign, nonatomic) BOOL shouldRefresh;
@property (strong, nonatomic) NSString *auditState;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSMutableArray *modelsArray;

@end

@implementation SHGUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleArray = @[@"我的合伙人", @"我的佣金", @"我的预约", @"我的业务", @"我的收藏", @"设置"];
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:NO];
    self.tableHeaderView.backgroundColor = [UIColor whiteColor];

    //tableView
    self.tableView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, kTabBarHeight);

    //tableView头
    self.userHeaderView.sd_layout
    .leftSpaceToView(self.tableHeaderView, MarginFactor(19.0f))
    .topSpaceToView(self.tableHeaderView, MarginFactor(17.0f))
    .widthIs(MarginFactor(45.0f))
    .heightEqualToWidth();

    //用户名
    self.nickNameLabel.sd_layout
    .leftSpaceToView(self.userHeaderView, MarginFactor(11.0f))
    .topEqualToView(self.userHeaderView)
    .autoHeightRatio(0.0f);
    [self.nickNameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    //职位
    self.departmentLabel.sd_layout
    .leftSpaceToView(self.nickNameLabel, MarginFactor(4.0f))
    .bottomEqualToView(self.nickNameLabel)
    .autoHeightRatio(0.0f);
    [self.departmentLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    //公司名
    self.companyLabel.sd_layout
    .leftEqualToView(self.nickNameLabel)
    .bottomEqualToView(self.userHeaderView)
    .autoHeightRatio(0.0f);
    [self.companyLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    //分割线
    self.lineView.sd_layout
    .leftSpaceToView(self.tableHeaderView, 0.0f)
    .rightSpaceToView(self.tableHeaderView, 0.0f)
    .topSpaceToView(self.userHeaderView, MarginFactor(17.0f))
    .heightIs(0.5f);

    //四个按钮
    self.labelView.sd_layout
    .leftSpaceToView(self.tableHeaderView, 0.0f)
    .rightSpaceToView(self.tableHeaderView, 0.0f)
    .topSpaceToView(self.lineView, 0.0f)
    .heightIs(MarginFactor(58.0f));

    //动态
    self.circleHeaderLabel.sd_layout
    .topSpaceToView(self.labelView, 0.0f)
    .leftSpaceToView(self.labelView, 0.0f)
    .widthIs(kLabelWidth)
    .heightRatioToView(self.labelView, 1.0f);

    //关注
    self.followHeaderLabel.sd_layout
    .topSpaceToView(self.labelView, 0.0f)
    .leftSpaceToView(self.circleHeaderLabel, 0.0f)
    .widthIs(kLabelWidth)
    .heightRatioToView(self.labelView, 1.0f);

    //粉丝
    self.fansHeaderLabel.sd_layout
    .leftSpaceToView(self.followHeaderLabel, 0.0f)
    .widthIs(kLabelWidth)
    .heightRatioToView(self.labelView, 1.0f)
    .centerYEqualToView(self.labelView);

    //认证
    self.authButton.sd_layout
    .topSpaceToView(self.labelView, 0.0f)
    .leftSpaceToView(self.fansHeaderLabel, 0.0f)
    .widthIs(kLabelWidth)
    .heightRatioToView(self.labelView, 1.0f);


    self.breakLine1.sd_layout
    .leftSpaceToView(self.circleHeaderLabel, 0.0f)
    .widthIs(0.5f)
    .heightIs(MarginFactor(22.0f))
    .centerYEqualToView(self.labelView);


    self.breakLine2.sd_layout
    .leftSpaceToView(self.followHeaderLabel, 0.0f)
    .widthIs(0.5f)
    .heightIs(MarginFactor(22.0f))
    .centerYEqualToView(self.labelView);

    self.breakLine3.sd_layout
    .leftSpaceToView(self.fansHeaderLabel, 0.0f)
    .widthIs(0.5f)
    .heightIs(MarginFactor(22.0f))
    .centerYEqualToView(self.labelView);

    self.bottomView.sd_layout
    .topSpaceToView(self.labelView, 0.0f)
    .leftSpaceToView(self.tableHeaderView, 0.0f)
    .rightSpaceToView(self.tableHeaderView, 0.0f)
    .heightIs(MarginFactor(9.0f));

    [self.tableHeaderView setupAutoHeightWithBottomView:self.bottomView bottomMargin:0.0f];
    [self.tableHeaderView layoutSubviews];
    [self.tableView setTableHeaderView:self.tableHeaderView];
    [self initData];

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

- (void)initData
{
    self.shouldRefresh = YES;
    self.nickName = @"";
    self.department = @"";
    self.company = @"";
    self.industry = @"";
    self.location = @"";
    self.imageUrl = @"";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:NOTIFI_CHANGE_UPDATE_AUTO_STATUE object:nil];
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
        button.titleLabel.font = [UIFont systemFontOfSize:FontFactor(15.0f)];
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
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //_tableView.backgroundColor = [UIColor colorWithHexString:@"f3f4f5"];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
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
        [_tableHeaderView addSubview:self.labelView];
        [_tableHeaderView addSubview:self.bottomView];
    }
    _tableHeaderView.backgroundColor = [UIColor whiteColor];
    return _tableHeaderView;
}

- (UIImageView *)userHeaderView
{
    if (!_userHeaderView) {
        _userHeaderView = [[UIImageView alloc] init];
        _userHeaderView.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUserHeadImage:)];
        [_userHeaderView addGestureRecognizer:recognizer];
    }
    return _userHeaderView;
}

- (UILabel *)nickNameLabel
{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = [UIFont systemFontOfSize:FontFactor(16.0f)];
        _nickNameLabel.textColor = [UIColor colorWithHexString:@"1d5798"];
    }
    return _nickNameLabel;
}

- (UILabel *)companyLabel
{
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
        _companyLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
        _companyLabel.textColor = [UIColor colorWithHexString:@"161616"];
    }
    return _companyLabel;
}

- (UILabel *)departmentLabel
{
    if (!_departmentLabel) {
        _departmentLabel = [[UILabel alloc] init];
        _departmentLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
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

- (UIView *)labelView
{
    if (!_labelView) {
        _labelView = [[UIView alloc] init];
        [_labelView addSubview:self.circleHeaderLabel];
        [_labelView addSubview:self.followHeaderLabel];
        [_labelView addSubview:self.fansHeaderLabel];
        [_labelView addSubview:self.authButton];
        [_labelView addSubview:self.breakLine1];
        [_labelView addSubview:self.breakLine2];
        [_labelView addSubview:self.breakLine3];
    }
    return _labelView;
}

- (UILabel *)circleHeaderLabel
{
    if (!_circleHeaderLabel) {
        _circleHeaderLabel = [[UILabel alloc] init];
        _circleHeaderLabel.textAlignment = NSTextAlignmentCenter;
        _circleHeaderLabel.textColor = [UIColor colorWithHexString:@"989898"];
        _circleHeaderLabel.numberOfLines = 0;
        _circleHeaderLabel.font = [UIFont systemFontOfSize:FontFactor(12.0f)];
        _circleHeaderLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMyCircle)];
        [_circleHeaderLabel addGestureRecognizer:tap];
    }
    return _circleHeaderLabel;
}

- (UILabel *)followHeaderLabel
{
    if (!_followHeaderLabel) {
        _followHeaderLabel = [[UILabel alloc] init];
        _followHeaderLabel.textAlignment = NSTextAlignmentCenter;
        _followHeaderLabel.numberOfLines = 0;
        _followHeaderLabel.textColor = [UIColor colorWithHexString:@"989898"];
        _followHeaderLabel.font = [UIFont systemFontOfSize:FontFactor(12.0f)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToFollowList)];
        [_followHeaderLabel addGestureRecognizer:tap];
        _followHeaderLabel.userInteractionEnabled = YES;
    }

    return _followHeaderLabel;
}


- (UILabel *)fansHeaderLabel
{
    if (!_fansHeaderLabel) {
        _fansHeaderLabel = [[UILabel alloc] init];
        _fansHeaderLabel.textAlignment = NSTextAlignmentCenter;
        _fansHeaderLabel.numberOfLines = 0;
        _fansHeaderLabel.textColor = [UIColor colorWithHexString:@"989898"];
        _fansHeaderLabel.font = [UIFont systemFontOfSize:FontFactor(12.0f)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToFansList)];
        [_fansHeaderLabel addGestureRecognizer:tap];
        _fansHeaderLabel.userInteractionEnabled = YES;
    }

    return _fansHeaderLabel;
}

- (UIButton *)authButton
{
    if (!_authButton) {
        _authButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_authButton addTarget:self action:@selector(actionAuth:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _authButton;
}

- (UIView *)breakLine1
{
    if (!_breakLine1) {
        _breakLine1 = [[UIView alloc] init];
        _breakLine1.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    }
    return _breakLine1;
}

- (UIView *)breakLine2
{
    if (!_breakLine2) {
        _breakLine2 = [[UIView alloc] init];
        _breakLine2.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    }
    return _breakLine2;
}

- (UIView *)breakLine3
{
    if (!_breakLine3) {
        _breakLine3 = [[UIView alloc] init];
        _breakLine3.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    }
    return _breakLine3;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"edeeef"];
    }
    return _bottomView;
}

- (NSMutableArray *)modelsArray
{
    if (!_modelsArray) {
        _modelsArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 6; i++) {
            SHGGlobleModel *model = [[SHGGlobleModel alloc] init];
            model.text = [self.titleArray objectAtIndex:i];
            [_modelsArray addObject:model];
        }
    }
    return _modelsArray;
}

- (void)refreshHeader
{
    [self getMyselfMaterial];
}

- (void)goToMyCircle
{
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    controller.userId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goToFollowList
{
    MyFollowViewController *controller = [[MyFollowViewController alloc] init];
    controller.relationShip = 1;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goToFansList
{
    MyFollowViewController *controller = [[MyFollowViewController alloc] init];
    controller.relationShip = 2;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)actionAuth:(id)sender {
    VerifyIdentityViewController *controller = [[VerifyIdentityViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark ------更换头像
- (void)changeUserHeadImage:(UIGestureRecognizer *)recognizer
{
    UIActionSheet *takeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选图", nil];
    [takeSheet showInView:self.view];
}

- (void)cameraClick
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [self presentViewController:pickerImage animated:YES completion:nil];
}

- (void)photosClick
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [self presentViewController:pickerImage animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *newHeadiamge = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.userHeaderView.image = newHeadiamge;
    //更改头像不需要刷新界面了，直接更改头像图片
    self.shouldRefresh = NO;
    [self uploadHeadImage:newHeadiamge];
}

#pragma mark ------上传头像
- (void)uploadHeadImage:(UIImage *)image
{
    //头像需要压缩 跟其他的上传图片接口不一样了
    [Hud showLoadingWithMessage:@"正在上传图片..."];
    __weak typeof(self) weakSelf = self;
    [[AFHTTPSessionManager manager] POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/basephoto"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
        [formData appendPartWithFileData:imageData name:@"hahaggg.jpg" fileName:@"hahaggg.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = [(NSString *)[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
        NSString *newHeadIamgeName = [(NSArray *)[dic valueForKey:@"pname"] objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:newHeadIamgeName forKey:KEY_HEAD_IMAGE];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_SENDPOST object:nil];

        [weakSelf putHeadImage:newHeadIamgeName];
        [Hud hideHud];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [Hud hideHud];
        [Hud showMessageWithText:@"上传图片失败"];
    }];
    
}

//更新服务器端
- (void)putHeadImage:(NSString *)headImageName
{
    [MOCHTTPRequestOperationManager putWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"modifyuser"] class:nil parameters:@{@"uid":UID,@"type":@"headimage",@"value":headImageName, @"title":self.department,  @"company":self.company} success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            [Hud showMessageWithText:@"修改成功"];
        }
    } failed:^(MOCHTTPResponse *response) {

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
        [aCircleString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"161616"], NSFontAttributeName:[UIFont systemFontOfSize:FontFactor(13.0f)]} range:NSMakeRange(4, aCircleString.length - 4)];
        [aCircleString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [aCircleString length])];

        NSMutableAttributedString *aFollowString = [[NSMutableAttributedString alloc] initWithString:followString];
        [aFollowString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"161616"], NSFontAttributeName:[UIFont systemFontOfSize:FontFactor(13.0f)]} range:NSMakeRange(4, aFollowString.length - 4)];
        [aFollowString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [aFollowString length])];

        NSMutableAttributedString *aFansString = [[NSMutableAttributedString alloc] initWithString:fansString];
        [aFansString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"161616"], NSFontAttributeName:[UIFont systemFontOfSize:FontFactor(13.0f)]} range:NSMakeRange(4, aFansString.length - 4)];
        [aFansString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [aFansString length])];

        weakSelf.circleHeaderLabel.attributedText = aCircleString;
        weakSelf.followHeaderLabel.attributedText = aFollowString;
        weakSelf.fansHeaderLabel.attributedText = aFansString;

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
            weakSelf.auditState = [response.dataDictionary objectForKey:@"auditstate"];
            if ([weakSelf.auditState isEqualToString:@"0"]) {
                [weakSelf.authButton setImage:[UIImage imageNamed:@"me_unAuth"] forState:UIControlStateNormal];
            } else if ([weakSelf.auditState isEqualToString:@"1"]){
                [weakSelf.authButton setImage:[UIImage imageNamed:@"me_authed"] forState:UIControlStateNormal];
            } else if ([weakSelf.auditState isEqualToString:@"2"]){
                [weakSelf.authButton setImage:[UIImage imageNamed:@"me_authering"] forState:UIControlStateNormal];
            } else{
                [weakSelf.authButton setImage:[UIImage imageNamed:@"me_rejected"] forState:UIControlStateNormal];
            }
        }
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableHeaderView layoutSubviews];

    } failed:^(MOCHTTPResponse *response) {

        [weakSelf.tableView.header endRefreshing];
        
    }];
}
#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableView cellHeightForIndexPath:indexPath model:self.modelsArray[indexPath.row] keyPath:@"model" cellClass:[SHGGlobleTableViewCell class] contentViewWidth:SCREENWIDTH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SHGGlobleTableViewCell";
    SHGGlobleTableViewCell *cell = (SHGGlobleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil){
        cell = [[SHGGlobleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setupNeedShowAccessorView:NO];
    }
    cell.model = [self.modelsArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0){

        MyTeamViewController *controller = [[MyTeamViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [MobClick event:@"MyTeamViewController" label:@"onClick"];
        [self.navigationController pushViewController:controller animated:YES];

    } else if (indexPath.row == 1) {
        MyMoneyViewController *controller = [[MyMoneyViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [MobClick event:@"MyMoneyViewController" label:@"onClick"];
        [self.navigationController pushViewController:controller animated:YES];

    } else if (indexPath.row == 2) {

        MyAppointmentViewController *controller = [[MyAppointmentViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [MobClick event:@"MyAppointmentViewController" label:@"onClick"];
        [self.navigationController pushViewController:controller animated:YES];

    } else if (indexPath.row == 3) {

        SHGMarketMineViewController *controller = [[SHGMarketMineViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];

    } else if (indexPath.row == 4) {

        MyCollectionViewController *controller = [[MyCollectionViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [MobClick event:@"MyCollectionViewController" label:@"onClick"];
        [self.navigationController pushViewController:controller animated:YES];

    } else if (indexPath.row == 5) {

        if (self.nickName.length > 0){
            SettingsViewController *controller = [[SettingsViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.userInfo = @{kNickName:self.nickName, kDepartment:self.department, kCompany:self.company, kLocation:self.location, kIndustry:self.industry, kHeaderImage:self.imageUrl};
            [self.navigationController	pushViewController:controller animated:YES];
        }
    }
}

#pragma mark ------actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        NSLog(@"拍照");
        [self cameraClick];
    } else if (buttonIndex == 1){
        NSLog(@"选图");
        [self photosClick];
    } else if (buttonIndex == 2){
        NSLog(@"取消");
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
