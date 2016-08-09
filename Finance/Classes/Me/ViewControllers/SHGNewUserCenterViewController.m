//
//  SHGNewUserCenterViewController.m
//  Finance
//
//  Created by changxicao on 16/8/8.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGNewUserCenterViewController.h"
#import "SHGSegmentController.h"
#import "SettingsViewController.h"
#import "SHGPersonalViewController.h"
#import "ChatListViewController.h"

@interface SHGNewUserCenterViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *headerBgView;
@property (weak, nonatomic) IBOutlet SHGUserHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *spliteView;
@property (strong, nonatomic) SHGHorizontalTitleImageView *businessButton;
@property (strong, nonatomic) SHGHorizontalTitleImageView *circleButton;
@property (strong, nonatomic) SHGHorizontalTitleImageView *friendButton;

@property (strong, nonatomic) UILabel       *authLabel;
@property (strong, nonatomic) UIImageView   *vImageView;
@property (strong, nonatomic) UIView        *badgeView;

@property (strong, nonatomic) NSString      *nickName;
@property (strong, nonatomic) NSString      *department;
@property (strong, nonatomic) NSString      *company;
@property (strong, nonatomic) NSString      *industry;
@property (strong, nonatomic) NSString      *location;
@property (strong, nonatomic) NSString      *imageUrl;


@property (strong, nonatomic) SHGAlertView *authAlertView;
@property (strong, nonatomic) UIButton *authMaskButton;
@property (strong, nonatomic) UIImageView *authMaskImageView;

@property (assign, nonatomic) BOOL hasUpdatedContacts;
@property (assign, nonatomic) BOOL shouldRefresh;
@property (strong, nonatomic) NSString *auditState;

@end

@implementation SHGNewUserCenterViewController

+ (instancetype)sharedController
{
    static SHGNewUserCenterViewController *sharedGlobleInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGlobleInstance = [[self alloc] init];
    });
    return sharedGlobleInstance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *titleArray = @[@"我的消息", @"身份认证", @"邀请好友", @"更新通讯录", @"我的投诉", @"设置"];
    NSArray *imageArray = @[[UIImage imageNamed:@"me_message_icon"], [UIImage imageNamed:@"me_auth_icon"], [UIImage imageNamed:@"me_invate_icon"], [UIImage imageNamed:@"me_contact_icon"], [UIImage imageNamed:@"me_complain_icon"], [UIImage imageNamed:@"me_setting_icon"]];
    for (NSInteger i = 0; i < titleArray.count; i++) {
        SHGUserCenterObject *object = [[SHGUserCenterObject alloc] init];
        object.image = [imageArray objectAtIndex:i];
        object.text = [titleArray objectAtIndex:i];
        [self.dataArr addObject:object];
    }
    [self initView];
    [self addAutoLayout];
    [self initData];
}

- (void)initView
{
    self.tableView.backgroundColor = Color(@"f6f7f8");
    self.tableView.bounces = NO;

    self.headerBgView.backgroundColor = ColorA(@"f5f5f5", 0.2f);
    UITapGestureRecognizer *recognizer = [self.headerView.gestureRecognizers firstObject];
    #pragma clang diagnostic ignored"-Wundeclared-selector"
    [recognizer removeTarget:self.headerView action:@selector(tapUserHeaderView)];
    [recognizer addTarget:self action:@selector(tapUserHeaderView:)];
    [self.headerView addGestureRecognizer:recognizer];

    self.nameLabel.textColor = self.departmentLabel.textColor = self.companyLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = FontFactor(16.0f);
    self.departmentLabel.font = FontFactor(13.0f);
    self.companyLabel.font = FontFactor(13.0f);

    self.businessButton = [[SHGHorizontalTitleImageView alloc] init];
    [self.businessButton addImage:[UIImage imageNamed:@"me_business"]];
    [self.businessButton addTitleWithDictionary:@{NSFontAttributeName:FontFactor(16.0f), NSForegroundColorAttributeName:Color(@"3a3a3a"), @"text":@"业务"}];
    self.businessButton.margin = MarginFactor(7.0f);
    [self.businessButton target:self addSeletor:@selector(goToMyBusiness)];

    self.circleButton = [[SHGHorizontalTitleImageView alloc] init];
    [self.circleButton addImage:[UIImage imageNamed:@"me_dynamic"]];
    [self.circleButton addTitleWithDictionary:@{NSFontAttributeName:FontFactor(16.0f), NSForegroundColorAttributeName:Color(@"3a3a3a"), @"text":@"动态"}];
    self.circleButton.margin = MarginFactor(7.0f);
    [self.circleButton target:self addSeletor:@selector(goToMyCircle)];

    self.friendButton = [[SHGHorizontalTitleImageView alloc] init];
    [self.friendButton addImage:[UIImage imageNamed:@"me_friend"]];
    [self.friendButton addTitleWithDictionary:@{NSFontAttributeName:FontFactor(16.0f), NSForegroundColorAttributeName:Color(@"3a3a3a"), @"text":@"好友"}];
    self.friendButton.margin = MarginFactor(7.0f);

    [self.actionView sd_addSubviews:@[self.businessButton, self.circleButton, self.friendButton]];

    self.lineView1.backgroundColor = self.lineView2.backgroundColor = self.spliteView.backgroundColor = Color(@"e6e7e8");

    self.authLabel = [[UILabel alloc] init];
    self.authLabel.font = FontFactor(13.0f);

    self.vImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v_large"]];
    [self.vImageView sizeToFit];
}

- (void)addAutoLayout
{
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, 0.0f, kTabBarHeight, 0.0f));

    self.headerBgView.sd_layout
    .topSpaceToView(self.tableHeaderView, 0.0f)
    .leftSpaceToView(self.tableHeaderView, MarginFactor(17.0f))
    .widthIs(MarginFactor(63.0f))
    .heightEqualToWidth();
    self.headerBgView.sd_cornerRadiusFromHeightRatio = @(0.5f);

    self.bgImageView.sd_layout
    .leftSpaceToView(self.tableHeaderView, 0.0f)
    .rightSpaceToView(self.tableHeaderView, 0.0f)
    .topSpaceToView(self.tableHeaderView, 0.0f)
    .heightRatioToView(self.headerBgView, 1.5f);

    self.headerView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(MarginFactor(7.0f), MarginFactor(7.0f), MarginFactor(7.0f), MarginFactor(7.0f)));
    self.headerView.sd_cornerRadiusFromHeightRatio = @(0.5f);

    self.nameLabel.sd_layout
    .leftSpaceToView(self.headerBgView, MarginFactor(11.0f))
    .topEqualToView(self.headerBgView)
    .heightIs(self.nameLabel.font.lineHeight);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.departmentLabel.sd_layout
    .leftSpaceToView(self.nameLabel, MarginFactor(11.0f))
    .centerYEqualToView(self.nameLabel)
    .heightIs(self.departmentLabel.font.lineHeight);
    [self.departmentLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.companyLabel.sd_layout
    .leftEqualToView(self.nameLabel)
    .topSpaceToView(self.nameLabel, MarginFactor(20.0f))
    .heightIs(self.companyLabel.font.lineHeight);
    [self.companyLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.modifyButton.sd_layout
    .rightSpaceToView(self.tableHeaderView, MarginFactor(19.0f))
    .centerYEqualToView(self.nameLabel)
    .widthIs(self.modifyButton.currentImage.size.width)
    .heightIs(self.modifyButton.currentImage.size.height);

    self.actionView.sd_layout
    .leftSpaceToView(self.tableHeaderView, 0.0f)
    .rightSpaceToView(self.tableHeaderView, 0.0f)
    .topSpaceToView(self.bgImageView, 0.0f)
    .heightIs(MarginFactor(61.0f));

    CGFloat width = floorf(SCREENWIDTH / 3.0f);

    self.lineView1.sd_layout
    .leftSpaceToView(self.actionView, width)
    .widthIs(1 / SCALE)
    .heightIs(MarginFactor(35.0f))
    .centerYEqualToView(self.actionView);

    self.lineView2.sd_layout
    .leftSpaceToView(self.actionView, 2.0f * width)
    .widthIs(1 / SCALE)
    .heightIs(MarginFactor(35.0f))
    .centerYEqualToView(self.actionView);

    self.spliteView.sd_layout
    .leftSpaceToView(self.actionView, 0.0f)
    .rightSpaceToView(self.actionView, 0.0f)
    .bottomSpaceToView(self.actionView, 0.0f)
    .heightIs(1 / SCALE);

    self.businessButton.sd_layout
    .centerYEqualToView(self.actionView)
    .centerXIs(0.5f * width);

    self.circleButton.sd_layout
    .centerYEqualToView(self.actionView)
    .centerXIs(1.5f * width);

    self.friendButton.sd_layout
    .centerYEqualToView(self.actionView)
    .centerXIs(2.5f * width);

    self.authMaskButton.sd_layout
    .topSpaceToView(self.authMaskImageView, 221.0f)
    .centerXEqualToView(self.authMaskImageView)
    .widthIs(self.authMaskButton.currentImage.size.width)
    .heightIs(self.authMaskButton.currentImage.size.height);

    [self.tableHeaderView setupAutoHeightWithBottomView:self.actionView bottomMargin:0.0f   ];

    [self.tableHeaderView setNeedsLayout];
    [self.tableHeaderView layoutIfNeeded];

    self.tableView.tableHeaderView = self.tableHeaderView;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.shouldRefresh){
        [[SHGSegmentController sharedSegmentController] setupUnreadMessageCount];
        [self loadData];
    } else{
        self.shouldRefresh = YES;
    }
}

- (SHGAlertView *)authAlertView
{
    if (!_authAlertView) {
        _authAlertView = [[SHGAlertView alloc] initWithCustomView:self.authMaskImageView leftButtonTitle:nil rightButtonTitle:nil];
        _authAlertView.touchOtherDismiss = YES;
        __weak typeof(self) weakSelf = self;
        _authAlertView.leftBlock = ^{
            SHGAuthenticationViewController *controller = [[SHGAuthenticationViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        };
    }
    return _authAlertView;
}

- (UIImageView *)authMaskImageView
{
    if (!_authMaskImageView) {
        _authMaskImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_authMask"]];
        [_authMaskImageView sizeToFit];
        _authMaskImageView.userInteractionEnabled = YES;
    }

    return _authMaskImageView;
}

- (UIButton *)authMaskButton
{
    if (!_authMaskButton) {
        _authMaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_authMaskButton setImage:[UIImage imageNamed:@"me_authButton"] forState:UIControlStateNormal];
#pragma clang diagnostic ignored"-Wundeclared-selector"
        [_authMaskButton addTarget:self.authAlertView action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.authMaskImageView addSubview:self.authMaskButton];
    }

    return _authMaskButton;
}

- (UIView *)badgeView
{
    if (!_badgeView) {
        _badgeView = [[UIView alloc] init];
        _badgeView.clipsToBounds = YES;
        UILabel *label = [[UILabel alloc] init];
        label.font = FontFactor(12.0f);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = Color(@"f04f46");
        [_badgeView addSubview:label];
    }
    return _badgeView;
}

- (void)setUnReadNumber:(NSInteger)unReadNumber
{
    _unReadNumber = unReadNumber;
    SHGUserCenterTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (unReadNumber > 0) {
        UILabel *label = [self.badgeView.subviews firstObject];
        label.text = [NSString stringWithFormat:@"%ld", (long)unReadNumber];
        CGFloat width = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, label.font.lineHeight)].width;
        width = width > MarginFactor(15.0f) ? width : MarginFactor(15.0f);
        self.badgeView.frame = CGRectMake(0.0f, 0.0f, width, MarginFactor(15.0f));
        label.frame = self.badgeView.bounds;
        self.badgeView.layer.cornerRadius = CGRectGetHeight(self.badgeView.frame) / 2.0f;
        [cell addViewTolastView: self.badgeView];
    } else {
        [cell addViewTolastView:nil];
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

- (void)refreshHeader
{
    [self loadData];
}

- (void)loadData
{
    self.headerView.image = [UIImage imageNamed:@"default_head"];
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"personaluser"] parameters:@{@"uid":UID,@"version":[SHGGloble sharedGloble].currentVersion} success:^(MOCHTTPResponse *response) {

        weakSelf.nameLabel.text = [response.dataDictionary valueForKey:@"name"];
        weakSelf.nickName = [response.dataDictionary valueForKey:@"name"];
        if([response.dataDictionary valueForKey:@"titles"]){
            NSString *department = [response.dataDictionary valueForKey:@"titles"];
            weakSelf.department = department;
            if (department.length > 8) {
                department = [department substringToIndex:8];
            }
            weakSelf.departmentLabel.text = department;
        } else{
            weakSelf.departmentLabel.text = @"暂无职称";
        }
        if([response.dataDictionary valueForKey:@"companyname"]){
            NSString *companyName = [response.dataDictionary valueForKey:@"companyname"];
            weakSelf.company = companyName;
            if (companyName.length > 12) {
                companyName = [companyName substringToIndex:12];
            }
            weakSelf.companyLabel.text = companyName;

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
            UIImage *placeImage = weakSelf.headerView.image;
            if(!placeImage){
                placeImage = [UIImage imageNamed:@"default_head"];
            }
            [weakSelf.headerView updateHeaderView:[rBaseAddressForImage stringByAppendingString:headImageUrl] placeholderImage:placeImage userID:nil];
        }

        SHGUserCenterTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        if ([[response.dataDictionary objectForKey:@"userstatus"] isEqualToString:@"true"]) {
            [cell addViewToFrontView:weakSelf.vImageView];
        } else {
            [cell addViewToFrontView:nil];
        }

        if ([response.dataDictionary objectForKey:@"auditstate"]) {
            weakSelf.modifyButton.hidden = YES;
            weakSelf.auditState = [response.dataDictionary objectForKey:@"auditstate"];
            if ([weakSelf.auditState isEqualToString:@"0"]) {
                weakSelf.authLabel.text = @"未认证";
                weakSelf.authLabel.textColor = Color(@"f04f46");
                //弹出提示框
                if ([TabBarViewController tabBar].selectedIndex == 3) {
                    [weakSelf.authAlertView show];
                }
            } else if ([weakSelf.auditState isEqualToString:@"1"]){
                weakSelf.authLabel.text = @"认证中";
                weakSelf.authLabel.textColor = Color(@"f04f46");
            } else if ([weakSelf.auditState isEqualToString:@"2"]){
                weakSelf.authLabel.text = @"已审核";
                weakSelf.authLabel.textColor = Color(@"17bb27");
                weakSelf.modifyButton.hidden = NO;
            } else if ([weakSelf.auditState isEqualToString:@"3"]){
                weakSelf.authLabel.text = @"已驳回";
                weakSelf.authLabel.textColor = Color(@"f04f46");
            } else{
                weakSelf.authLabel.text = @"已审核";
                weakSelf.authLabel.textColor = Color(@"17bb27");
                weakSelf.modifyButton.hidden = NO;
            }
            [weakSelf.authLabel sizeToFit];
            [cell addViewTolastView: weakSelf.authLabel];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    } failed:^(MOCHTTPResponse *response) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark -邀请好友
- (void)actionInvite
{
    __weak typeof(self) weakSelf = self;
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:[UIImage imageNamed:@"80"]];
    NSString *contentOther =[NSString stringWithFormat:@"%@",@"诚邀您加入大牛圈--金融业务互助平台"];
    NSString *content =[NSString stringWithFormat:@"%@%@",@"诚邀您加入大牛圈--金融业务互助平台！这里有业务互助、人脉嫁接！赶快加入吧！",[NSString stringWithFormat:@"%@?uid=%@",SHARE_YAOQING_URL,[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID]]];
    id<ISSShareActionSheetItem> item3 = [ShareSDK shareActionSheetItemWithTitle:@"短信" icon:[UIImage imageNamed:@"sns_icon_19"] clickHandler:^{
        [weakSelf shareToSMS:content];
    }];

    NSString *shareUrl =[NSString stringWithFormat:@"%@?uid=%@",SHARE_YAOQING_URL,[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID]];
    id<ISSShareActionSheetItem> item4 = [ShareSDK shareActionSheetItemWithTitle:@"微信朋友圈" icon:[UIImage imageNamed:@"sns_icon_23"] clickHandler:^{
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"user_inviteMicroCircle"];
        [[AppDelegate currentAppdelegate] wechatShareWithText:contentOther shareUrl:shareUrl shareType:1];
    }];
    id<ISSShareActionSheetItem> item5 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友" icon:[UIImage imageNamed:@"sns_icon_22"] clickHandler:^{
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"user_inviteMicroFriend"];
        [[AppDelegate currentAppdelegate] wechatShareWithText:contentOther shareUrl:shareUrl shareType:0];
    }];

    NSArray *shareArray = nil;
    if ([WXApi isWXAppSupportApi]) {
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), item3, nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item5, item4, item3, nil];
        }
    } else{
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: SHARE_TYPE_NUMBER(ShareTypeQQ), item3, nil];
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

- (void)shareToSMS:(NSString *)text
{
    [[SHGGloble sharedGloble] recordUserAction:@"" type:@"user_inviteSms"];
    [[AppDelegate currentAppdelegate] sendSmsWithText:text rid:@""];
}

- (void)uploadContact
{
    [[SHGGloble sharedGloble] recordUserAction:@"" type:@"user_setting_updateFriend"];
    [[SHGGloble sharedGloble] getUserAddressList:^(BOOL finished) {
        if(finished){
            [[SHGGloble sharedGloble] uploadPhonesWithPhone:^(BOOL finish) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(finished){
                        [Hud showMessageWithText:@"通讯录更新成功"];
                    } else{
                        [Hud showMessageWithText:@"上传通讯录列表失败"];
                    }
                });
            }];
        } else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [Hud showMessageWithText:@"获取通讯录列表失败，请到系统设置设置权限"];
            });
        }
    }];
}

- (void)changeUpdateState
{
    self.hasUpdatedContacts = NO;
}

- (void)actionAuth
{
    SHGAuthenticationViewController *controller = [[SHGAuthenticationViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.authState = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)editButtonClicked:(UIButton *)button
{
    SHGModifyUserInfoViewController *controller = [[SHGModifyUserInfoViewController alloc]init];
    __weak typeof(self)weakSelf = self;
    controller.hidesBottomBarWhenPushed = YES;
    controller.userInfo = @{kNickName:weakSelf.nickName, kDepartment:weakSelf.department, kCompany:weakSelf.company, kLocation:weakSelf.location, kIndustry:weakSelf.industry, kHeaderImage:weakSelf.imageUrl};
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goToMyCircle
{
    [[SHGGloble sharedGloble] recordUserAction:@"" type:@"user_dynamic"];
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    controller.userId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goToMyBusiness
{
    //    [[SHGGloble sharedGloble] recordUserAction:@"" type:@"user_business"];
    //    SHGBusinessMineViewController *controller = [[SHGBusinessMineViewController alloc] initWithNibName:@"SHGBusinessMineViewController" bundle:nil];
    //    controller.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:controller animated:YES];
}


- (void)jumpToChatList
{
    [[TabBarViewController tabBar].navigationController pushViewController:[ChatListViewController sharedController] animated:YES];
}

- (void)tapUserHeaderView:(UIGestureRecognizer *)recognizer
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
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        [self presentViewController:pickerImage animated:YES completion:nil];
    }
}

- (void)photosClick
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    [pickerImage.navigationBar setShadowImage:[[UIImage alloc] init]];
    [pickerImage.navigationBar setBackgroundImage:[CommonMethod imageWithColor:Color(@"f04f46")] forBarMetrics:UIBarMetricsDefault];
    pickerImage.navigationBar.tintColor = [UIColor whiteColor];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        [self presentViewController:pickerImage animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *newHeadiamge = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.headerView.image = newHeadiamge;
    //更改头像不需要刷新界面了，直接更改头像图片
    self.shouldRefresh = NO;
    [self uploadHeadImage:newHeadiamge];
}

#pragma mark ------上传头像
- (void)uploadHeadImage:(UIImage *)image
{
    //头像需要压缩 跟其他的上传图片接口不一样了
    [Hud showWait];
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/basephoto"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGUserCenterObject *object = [self.dataArr objectAtIndex:indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[ SHGUserCenterTableViewCell class] contentViewWidth:SCREENWIDTH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGUserCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHGUserCenterTableViewCell"];
    if (!cell) {
        cell = [[SHGUserCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHGUserCenterTableViewCell"];
    }
    cell.object = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = ((SHGUserCenterObject *)[self.dataArr objectAtIndex:indexPath.row]).text;
    if ([text containsString:@"邀请好友"]) {
        [self actionInvite];
    } else if ([text containsString:@"更新通讯录"]) {
        if (self.hasUpdatedContacts){
            [Hud showMessageWithText:@"您刚刚更新过好友"];
        } else{
            SHGAlertView *alert = [[SHGAlertView alloc] initWithTitle:@"提示" contentText:@"更新好友将更新您一度人脉中手机通讯录，将有效拓展您的人脉。" leftButtonTitle:@"取消" rightButtonTitle:@"更新"];
            __weak typeof(self) weakSelf = self;
            alert.rightBlock = ^{
                [weakSelf uploadContact];
            };
            alert.leftBlock = ^{
                self.hasUpdatedContacts = NO;
            };
            [alert show];
            self.hasUpdatedContacts = YES;
            [self performSelector:@selector(changeUpdateState) withObject:nil afterDelay:60.0f];
        }
    } else if ([text containsString:@"我的消息"]){
        [self jumpToChatList];
    } else if ([text containsString:@"身份认证"]){
        [self actionAuth];
    } else if ([text containsString:@"我的投诉"]){
        //        [self actionAuth];
    } else if ([text containsString:@"设置"]){
        if (self.nickName.length > 0){
            SettingsViewController *controller = [[SettingsViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.userInfo = @{kNickName:self.nickName, kDepartment:self.department, kCompany:self.company, kLocation:self.location, kIndustry:self.industry, kHeaderImage:self.imageUrl};
            [self.navigationController	pushViewController:controller animated:YES];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end


@interface SHGUserCenterTableViewCell()

@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UIView *topLineView;
@property (strong, nonatomic) UIView *bottomLineView;
@property (strong, nonatomic) UIImageView *arrowImageView;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIView *frontView;
@property (strong, nonatomic) UIView *lastView;

@end

@implementation SHGUserCenterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        [self addAutoLayout];
    }
    return self;
}

- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = Color(@"f6f7f8");

    self.mainView = [[UIView alloc] init];
    self.mainView.backgroundColor = [UIColor whiteColor];

    self.topLineView = [[UIView alloc] init];
    self.topLineView.backgroundColor = Color(@"e6e7e8");

    self.bottomLineView = [[UIView alloc] init];
    self.bottomLineView.backgroundColor = Color(@"e6e7e8");

    self.iconImageView = [[UIImageView alloc] init];

    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrowImage"]];

    self.label = [[UILabel alloc] init];
    self.label.font = FontFactor(16.0f);
    self.label.textColor = Color(@"3a3a3a");

    self.frontView = [[UIView alloc] init];
    self.lastView = [[UIView alloc] init];

    [self.contentView addSubview:self.mainView];
    [self.mainView sd_addSubviews:@[self.topLineView, self.bottomLineView, self.iconImageView, self.arrowImageView, self.label, self.frontView, self.lastView]];
}

- (void)addAutoLayout
{
    self.mainView.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(MarginFactor(52.0f))
    .topSpaceToView(self.contentView, MarginFactor(10.0f));

    self.topLineView.sd_layout
    .leftSpaceToView(self.mainView, 0.0f)
    .rightSpaceToView(self.mainView, 0.0f)
    .topSpaceToView(self.mainView, 0.0f)
    .heightIs(1 / SCALE);

    self.bottomLineView.sd_layout
    .leftSpaceToView(self.mainView, 0.0f)
    .rightSpaceToView(self.mainView, 0.0f)
    .bottomSpaceToView(self.mainView, 0.0f)
    .heightIs(1 / SCALE);

    [self.label setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.arrowImageView.sd_layout
    .rightSpaceToView(self.mainView, MarginFactor(19.0f))
    .centerYEqualToView(self.mainView)
    .widthIs(self.arrowImageView.size.width)
    .heightIs(self.arrowImageView.size.height);

    [self setupAutoHeightWithBottomView:self.mainView bottomMargin:0.0f];
}

- (void)setObject:(SHGUserCenterObject *)object
{
    _object = object;
    self.iconImageView.image = object.image;
    self.label.text = object.text;

    self.iconImageView.sd_resetLayout
    .leftSpaceToView(self.mainView, MarginFactor(17.0f))
    .centerYEqualToView(self.mainView)
    .widthIs(self.iconImageView.image.size.width)
    .heightIs(self.iconImageView.image.size.height);

    self.label.sd_resetLayout
    .leftSpaceToView(self.iconImageView, MarginFactor(10.0f))
    .centerYEqualToView(self.mainView)
    .heightIs(self.label.font.lineHeight);
}

- (void)addViewToFrontView:(UIView *)view
{
    [self.frontView removeAllSubviews];
    if (view) {
        [self.frontView addSubview:view];
        self.frontView.sd_resetLayout
        .leftSpaceToView(self.label, MarginFactor(12.0f))
        .centerYEqualToView(self.mainView)
        .widthIs(CGRectGetWidth(view.frame))
        .heightIs(CGRectGetHeight(view.frame));
    }
}

- (void)addViewTolastView:(UIView *)view
{
    [self.lastView removeAllSubviews];
    if (view) {
        [self.lastView addSubview:view];
        self.lastView.sd_resetLayout
        .rightSpaceToView(self.arrowImageView, MarginFactor(12.0f))
        .centerYEqualToView(self.mainView)
        .widthIs(CGRectGetWidth(view.frame))
        .heightIs(CGRectGetHeight(view.frame));
    }
}

@end


@implementation SHGUserCenterObject



@end