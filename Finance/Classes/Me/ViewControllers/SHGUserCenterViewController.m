//
//  SHGUserCenterViewController.m
//  Finance
//
//  Created by changxicao on 16/1/28.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGUserCenterViewController.h"
#import "SHGPersonalViewController.h"
#import "MyTeamViewController.h"
#import "MyMoneyViewController.h"
#import "MyAppointmentViewController.h"
#import "SHGBusinessMineViewController.h"
#import "SettingsViewController.h"
#import "SHGCardCollectionViewController.h"
#import "SHGCircleCollectionViewController.h"
#import "SHGBusinessCollectionListViewController.h"
#import "SHGMyFollowViewController.h"
#import "SHGMyFansViewController.h"

#define kLabelWidth ceilf(SCREENWIDTH / 4.0f)

@interface SHGUserCenterViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UITableView     *tableView;
@property (strong, nonatomic) UIView          *tableHeaderView;
@property (strong, nonatomic) UIImageView     *userHeaderView;
@property (strong, nonatomic) UILabel         *departmentLabel;
@property (strong, nonatomic) UILabel         *nickNameLabel;
@property (strong, nonatomic) UILabel         *companyLabel;
@property (strong, nonatomic) SHGUserCenterAuthTipView *authenTipView;
@property (strong, nonatomic) UIView          *lineView;
@property (strong, nonatomic) UIButton        *editButton;
@property (strong, nonatomic) UIView          *messageView;
@property (strong, nonatomic) UIView          *labelView;

@property (strong, nonatomic) UILabel	*circleHeaderLabel;  //动态lable
@property (strong, nonatomic) UILabel	*followHeaderLabel;  //关注label
@property (strong, nonatomic) UILabel	*fansHeaderLabel;  //粉丝label
@property (strong, nonatomic) UIView	*breakLine1;
@property (strong, nonatomic) UIView	*breakLine2;
@property (strong, nonatomic) UIView	*breakLine3;
@property (strong, nonatomic) UIView	*bottomView;

@property (strong, nonatomic) UIImageView *authMaskImageView;
@property (strong, nonatomic) UIButton *authMaskButton;
@property (strong, nonatomic) SHGAlertView *authAlertView;

@property (strong, nonatomic) UIButton      *authButton;
@property (strong, nonatomic) NSString      *nickName;
@property (strong, nonatomic) NSString      *department;
@property (strong, nonatomic) NSString      *company;
@property (strong, nonatomic) NSString      *industry;
@property (strong, nonatomic) NSString      *location;
@property (strong, nonatomic) NSString      *imageUrl;

@property (assign, nonatomic) BOOL hasUpdatedContacts;
@property (assign, nonatomic) BOOL shouldRefresh;
@property (strong, nonatomic) NSString *auditState;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSMutableArray *modelsArray;

@end

@implementation SHGUserCenterViewController

+ (instancetype)sharedController
{
    static SHGUserCenterViewController *sharedGlobleInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGlobleInstance = [[self alloc] init];
    });
    return sharedGlobleInstance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *array0 = @[[[SHGGlobleModel alloc] initWithText:@"业务收藏" lineViewHidden:NO accessoryViewHidden:NO], [[SHGGlobleModel alloc] initWithText:@"动态收藏" lineViewHidden:NO accessoryViewHidden:NO], [[SHGGlobleModel alloc] initWithText:@"名片收藏" lineViewHidden:YES accessoryViewHidden:NO]];
    NSArray *array1 = @[[[SHGGlobleModel alloc] initWithText:@"我的业务" lineViewHidden:YES accessoryViewHidden:NO]];
    NSArray *array2 = @[[[SHGGlobleModel alloc] initWithText:@"邀请好友加入大牛圈" lineViewHidden:NO accessoryViewHidden:YES], [[SHGGlobleModel alloc] initWithText:@"更新通讯录到大牛圈" lineViewHidden:YES accessoryViewHidden:YES]];
    NSArray *array3 = @[[[SHGGlobleModel alloc] initWithText:@"设置" lineViewHidden:YES accessoryViewHidden:NO]];
    self.titleArray = @[array1, array0, array2, array3];

    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:NO];
    self.tableHeaderView.backgroundColor = [UIColor whiteColor];;
    UIImage * editImage = [UIImage imageNamed:@"userCenterEdit"];
    CGSize editSize = editImage.size;
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
    .heightIs(self.nickNameLabel.font.lineHeight);
    [self.nickNameLabel setSingleLineAutoResizeWithMaxWidth:kLabelWidth];

    //编辑按钮
    self.editButton.sd_layout
    .rightSpaceToView(self.tableHeaderView, MarginFactor(15.0f))
    .centerYEqualToView(self.userHeaderView)
    .widthIs(editSize.width)
    .heightIs(editSize.height);
    self.editButton.hidden = YES;

    //职位
    self.departmentLabel.sd_layout
    .leftSpaceToView(self.nickNameLabel, MarginFactor(10.0f))
    .bottomEqualToView(self.nickNameLabel)
    .heightIs(self.departmentLabel.font.lineHeight);
    [self.departmentLabel setSingleLineAutoResizeWithMaxWidth:kLabelWidth * 2.0f];

    //v+企
    self.authenticationView.sd_layout
    .leftSpaceToView(self.departmentLabel, MarginFactor(-7.0f))
    .centerYEqualToView(self.departmentLabel)
    .offset(MarginFactor(1.0f))
    .heightIs(13.0f);

    self.authenTipView.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.authenticationView, MarginFactor(2.0f))
    .widthIs(MarginFactor(331.0f))
    .heightIs(MarginFactor(148.0f));

    //公司名
    self.companyLabel.sd_layout
    .leftEqualToView(self.nickNameLabel)
    .rightSpaceToView(self.editButton, MarginFactor(39.0f))
    .bottomEqualToView(self.userHeaderView)
    .heightRatioToView(self.nickNameLabel, 1.0f);
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
    .topSpaceToView(self.lineView, 0.5f)
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

    //认证的maskView

    self.authMaskButton.sd_layout
    .topSpaceToView(self.authMaskImageView, 221.0f)
    .centerXEqualToView(self.authMaskImageView)
    .widthIs(self.authMaskButton.currentImage.size.width)
    .heightIs(self.authMaskButton.currentImage.size.height);

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

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
        [_tableHeaderView addSubview:self.authenticationView];
        [_tableHeaderView addSubview:self.lineView];
        [_tableHeaderView addSubview:self.labelView];
        [_tableHeaderView addSubview:self.bottomView];
        [_tableHeaderView addSubview:self.authenTipView];
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
        _nickNameLabel.font = FontFactor(16.0f);
        _nickNameLabel.textColor = [UIColor colorWithHexString:@"1d5798"];
    }
    return _nickNameLabel;
}

- (UILabel *)companyLabel
{
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
        _companyLabel.font = FontFactor(14.0f);
        _companyLabel.textColor = [UIColor colorWithHexString:@"161616"];
    }
    return _companyLabel;
}

- (UILabel *)departmentLabel
{
    if (!_departmentLabel) {
        _departmentLabel = [[UILabel alloc] init];
        _departmentLabel.font = FontFactor(14.0f);
        _departmentLabel.textColor = [UIColor colorWithHexString:@"161616"];
    }
    return _departmentLabel;
}

- (SHGAuthenticationView *)authenticationView
{
    __weak typeof(self) weakSelf = self;
    if (!_authenticationView) {
        _authenticationView = [SHGAuthenticationView buttonWithType:UIButtonTypeCustom];
        _authenticationView.block = ^{
            CGFloat toAlpha = ABS(weakSelf.authenTipView.alpha - 1.0f);
            [UIView animateWithDuration:0.3f animations:^{
                weakSelf.authenTipView.alpha = toAlpha;
            }];
        };
        _authenticationView.showGray = YES;
    }
    return _authenticationView;
}

- (SHGUserCenterAuthTipView *)authenTipView
{
    if (!_authenTipView) {
        _authenTipView = [[SHGUserCenterAuthTipView alloc] init];
        _authenTipView.alpha = 0.0f;
    }
    return _authenTipView;
}

- (UIButton *)editButton
{
    if (!_editButton){
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setEnlargeEdge:MarginFactor(15.0f)];
        [_editButton setImage:[UIImage imageNamed:@"userCenterEdit"] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableHeaderView addSubview:_editButton];
    }
    return _editButton;
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
        _circleHeaderLabel.font = FontFactor(12.0f);
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
        _followHeaderLabel.font = FontFactor(12.0f);
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
        _fansHeaderLabel.font = FontFactor(12.0f);
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

- (void)refreshHeader
{
    [self getMyselfMaterial];
}

- (void)goToMyBusiness
{
    [[SHGGloble sharedGloble] recordUserAction:@"" type:@"user_business"];
    SHGBusinessMineViewController *controller = [[SHGBusinessMineViewController alloc] initWithNibName:@"SHGBusinessMineViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
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

- (void)goToFollowList
{
    SHGMyFollowViewController *controller = [[SHGMyFollowViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goToFansList
{
    SHGMyFansViewController *controller = [[SHGMyFansViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)actionAuth:(id)sender
{
    SHGAuthenticationViewController *controller = [[SHGAuthenticationViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.authState = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)editButtonClicked:(UIButton *)button
{
    SHGModifyUserInfoViewController *controller = [[SHGModifyUserInfoViewController alloc]init];
    __weak typeof(self)weakSelf = self;
    controller.hidesBottomBarWhenPushed = YES;
    controller.userInfo = @{kNickName:weakSelf.nickName, kDepartment:weakSelf.department, kCompany:weakSelf.company, kLocation:weakSelf.location, kIndustry:weakSelf.industry, kHeaderImage:weakSelf.imageUrl};
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)authenTipButtonClick:(UIButton *)button
{
    CGFloat toAlpha = ABS(button.alpha - 1.0f);
    [UIView animateWithDuration:0.3f animations:^{
        button.alpha = toAlpha;
    }];
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
    self.userHeaderView.image = newHeadiamge;
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

-(void)shareToSMS:(NSString *)text
{
    [[SHGGloble sharedGloble] recordUserAction:@"" type:@"user_inviteSms"];
    [[AppDelegate currentAppdelegate] sendSmsWithText:text rid:@""];
}

#pragma mark ------获取数据
- (void)getMyselfMaterial
{
    [self.userHeaderView setImage:[UIImage imageNamed:@"default_head"]];
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"personaluser"] parameters:@{@"uid":UID,@"version":[SHGGloble sharedGloble].currentVersion} success:^(MOCHTTPResponse *response) {

        NSString *circles = [response.dataDictionary valueForKey:@"circles"];
        NSString *followCount = [response.dataDictionary valueForKey:@"attention"];
        NSString *fansCount = [response.dataDictionary valueForKey:@"fans"];

        NSString *circlesString = [NSString stringWithFormat:@"动态 \n%@",circles];
        NSString *followString = [NSString stringWithFormat:@"关注 \n%@",followCount];
        NSString *fansString = [NSString stringWithFormat:@"粉丝 \n%@",fansCount];

        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:1.0f];
        paragraphStyle1.alignment = NSTextAlignmentCenter;
        NSMutableAttributedString *aCircleString = [[NSMutableAttributedString alloc] initWithString:circlesString];
        [aCircleString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"161616"], NSFontAttributeName:FontFactor(13.0f)} range:NSMakeRange(4, aCircleString.length - 4)];
        [aCircleString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [aCircleString length])];

        NSMutableAttributedString *aFollowString = [[NSMutableAttributedString alloc] initWithString:followString];
        [aFollowString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"161616"], NSFontAttributeName:FontFactor(13.0f)} range:NSMakeRange(4, aFollowString.length - 4)];
        [aFollowString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [aFollowString length])];

        NSMutableAttributedString *aFansString = [[NSMutableAttributedString alloc] initWithString:fansString];
        [aFansString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"161616"], NSFontAttributeName:FontFactor(13.0f)} range:NSMakeRange(4, aFansString.length - 4)];
        [aFansString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [aFansString length])];

        weakSelf.circleHeaderLabel.attributedText = aCircleString;
        weakSelf.followHeaderLabel.attributedText = aFollowString;
        weakSelf.fansHeaderLabel.attributedText = aFansString;

        weakSelf.nickNameLabel.text = [response.dataDictionary valueForKey:@"name"];
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
            UIImage *placeImage = weakSelf.userHeaderView.image;
            if(!placeImage){
                placeImage = [UIImage imageNamed:@"default_head"];
            }
            [weakSelf.userHeaderView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,headImageUrl]] placeholderImage:placeImage];
        }
        [weakSelf.authenticationView updateWithVStatus:[[response.dataDictionary objectForKey:@"userstatus"] isEqualToString:@"true"] ? YES : NO enterpriseStatus:[[response.dataDictionary objectForKey:@"businessstatus"] boolValue]];

        if ([response.dataDictionary objectForKey:@"auditstate"]) {
            weakSelf.editButton.hidden = YES;
            weakSelf.auditState = [response.dataDictionary objectForKey:@"auditstate"];
            if ([weakSelf.auditState isEqualToString:@"0"]) {
                [weakSelf.authButton setImage:[UIImage imageNamed:@"me_unAuth"] forState:UIControlStateNormal];
                //公司名
                self.companyLabel.sd_resetLayout
                .leftEqualToView(self.nickNameLabel)
                .rightSpaceToView(self.tableHeaderView, MarginFactor(15.0f))
                .bottomEqualToView(self.userHeaderView)
                .heightRatioToView(self.nickNameLabel, 1.0f);
                //弹出提示框
                if ([TabBarViewController tabBar].selectedIndex == 3) {
                    [weakSelf.authAlertView show];
                }
            } else if ([weakSelf.auditState isEqualToString:@"1"]){
                [weakSelf.authButton setImage:[UIImage imageNamed:@"me_authering"] forState:UIControlStateNormal];
            } else if ([weakSelf.auditState isEqualToString:@"2"]){
                [weakSelf.authButton setImage:[UIImage imageNamed:@"me_authed"] forState:UIControlStateNormal];
                weakSelf.editButton.hidden = NO;
            } else if ([weakSelf.auditState isEqualToString:@"3"]){
                [weakSelf.authButton setImage:[UIImage imageNamed:@"me_rejected"] forState:UIControlStateNormal];
            } else{
                [weakSelf.authButton setImage:[UIImage imageNamed:@"me_unConsummate"] forState:UIControlStateNormal];
                weakSelf.editButton.hidden = NO;
            }
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableHeaderView layoutSubviews];

        CGPoint point = weakSelf.authenticationView.center;
        point = [weakSelf.tableHeaderView convertPoint:weakSelf.authenticationView.center toView:weakSelf.authenTipView.contentView];
        weakSelf.authenTipView.pointX = point.x - 6.0f;

    } failed:^(MOCHTTPResponse *response) {

        [weakSelf.tableView.mj_header endRefreshing];

    }];
}
#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.titleArray objectAtIndex:section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = [UIColor colorWithHexString:@"edeeef"];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    }
    return MarginFactor(9.0f);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:self.modelsArray[indexPath.row] keyPath:@"model" cellClass:[SHGGlobleTableViewCell class] contentViewWidth:SCREENWIDTH];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SHGGlobleTableViewCell";
    SHGGlobleTableViewCell *cell = (SHGGlobleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil){
        cell = [[SHGGlobleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    SHGGlobleModel *model = [[self.titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.authenTipView.alpha > 0) {
        [UIView animateWithDuration:0.3f animations:^{
            self.authenTipView.alpha = 0.0f;
        }];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *text = ((SHGGlobleModel *)[[self.titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).text;
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
    } else if ([text containsString:@"我的业务"]){
        [self goToMyBusiness];
    } else if ([text containsString:@"业务收藏"]){
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"user_collectBusiness"];
        SHGBusinessCollectionListViewController *controller = [[SHGBusinessCollectionListViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ([text containsString:@"动态收藏"]){

        SHGCircleCollectionViewController *controller = [[SHGCircleCollectionViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([text containsString:@"名片收藏"]){

        SHGCardCollectionViewController *controller = [[SHGCardCollectionViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];

    } else if ([text containsString:@"设置"]){

        if (self.nickName.length > 0){
            SettingsViewController *controller = [[SettingsViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.userInfo = @{kNickName:self.nickName, kDepartment:self.department, kCompany:self.company, kLocation:self.location, kIndustry:self.industry, kHeaderImage:self.imageUrl};
            [self.navigationController	pushViewController:controller animated:YES];
        }

    }
}

- (void)changeUpdateState
{
    self.hasUpdatedContacts = NO;
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


@interface SHGUserCenterAuthTipView()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) UIImageView *labelImageView;

@end

@implementation SHGUserCenterAuthTipView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
        [self addAutoLayout];
    }
    return self;
}

- (void)initView
{
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_authTipBg"]];

    self.leftImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"me_authLeftImage"]resizableImageWithCapInsets:UIEdgeInsetsMake(7.0f, 7.0f, 7.0f, 10.0f) resizingMode:UIImageResizingModeStretch]];

    self.rightImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"me_authRightImage"]resizableImageWithCapInsets:UIEdgeInsetsMake(13.0f, 12.0f, 7.0f, 7.0f) resizingMode:UIImageResizingModeStretch]];

    self.labelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_authTipLabel"]];

    self.contentView = [[UIView alloc] init];
    [self.contentView sd_addSubviews:@[self.leftImageView, self.rightImageView, self.labelImageView]];

    [self sd_addSubviews:@[self.imageView, self.contentView]];
}

- (void)addAutoLayout
{
    self.imageView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .bottomSpaceToView(self, 0.0f)
    .heightIs(MarginFactor(self.imageView.image.size.height));

    self.contentView.sd_layout
    .centerXEqualToView(self)
    .widthIs(MarginFactor(256.0f))
    .heightIs(MarginFactor(88.0f))
    .topSpaceToView(self, 0.0f);

    self.leftImageView.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .bottomEqualToView(self.rightImageView)
    .widthIs(self.pointX)
    .heightIs(MarginFactor(88.0f) - 6.0f);

    self.rightImageView.sd_layout
    .rightSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.contentView, 0.0f)
    .leftSpaceToView(self.leftImageView, 0.0f)
    .heightRatioToView(self.contentView, 1.0f);

    self.labelImageView.sd_layout
    .centerXEqualToView(self.contentView)
    .centerYEqualToView(self.contentView)
    .widthIs(MarginFactor(self.labelImageView.image.size.width))
    .heightIs(MarginFactor(self.labelImageView.image.size.height));
}

- (void)setPointX:(CGFloat)pointX
{
    if (pointX == _pointX || !self.superview) {
        return;
    }

    if (pointX > CGRectGetWidth(self.contentView.frame) - (self.rightImageView.image.size.width - 6.0f)) {
        _pointX = CGRectGetWidth(self.contentView.frame) - (self.rightImageView.image.size.width - 6.0f);
        CGFloat offset = pointX - _pointX;
        self.sd_resetNewLayout
        .centerXEqualToView(self.superview)
        .topSpaceToView([SHGUserCenterViewController sharedController].authenticationView, MarginFactor(2.0f))
        .widthIs(MarginFactor(331.0f))
        .heightIs(MarginFactor(148.0f))
        .offset(offset);
    } else{
        _pointX = pointX;
        self.sd_resetNewLayout
        .topSpaceToView([SHGUserCenterViewController sharedController].authenticationView, MarginFactor(2.0f))
        .centerXEqualToView(self.superview)
        .widthIs(MarginFactor(331.0f))
        .heightIs(MarginFactor(148.0f));
    }

    self.leftImageView.sd_resetLayout
    .leftSpaceToView(self.contentView, 0.0f)
    .bottomEqualToView(self.rightImageView)
    .widthIs(_pointX)
    .heightIs(MarginFactor(88.0f) - 6.0f);
    
    [self updateLayout];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.0f;
    }];
}

@end