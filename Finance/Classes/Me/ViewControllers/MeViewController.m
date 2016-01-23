//
//  MeViewController.m
//  Finance
//
//  Created by HuMin on 15/4/10.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MeViewController.h"
#import "MyFollowViewController.h"
#import "MyAddressViewController.h"
#import "MyTeamViewController.h"
#import "VerifyIdentityViewController.h"
#import "MyMoneyViewController.h"
#import "MyCollectionViewController.h"
#import "MyAppointmentViewController.h"
#import "SettingsViewController.h"
#import "SHGUserTagModel.h"
#import "SHGPersonalViewController.h"
#import "SHGSelectTagsViewController.h"
#import "SHGMarketMineViewController.h"
#define kRowHeight 50.0f * YFACTOR
#define kMessageViewHeight 72.0f * YFACTOR
#define klabelViewHeight 41.0f * YFACTOR
#define kSpaceMargin 10.0f * YFACTOR
@interface MeViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView	*tableView;
@property (weak, nonatomic) IBOutlet UIView		*headerView;
@property (weak, nonatomic) IBOutlet UIView     *messageView;
@property (weak, nonatomic) IBOutlet UIView     *labelView;
@property (weak, nonatomic) IBOutlet UILabel    *moneyLabel;  //职位
@property (weak, nonatomic) IBOutlet UILabel    *txtNickName;
@property (weak, nonatomic) IBOutlet UILabel    *companyName; //公司名称
@property (weak, nonatomic) IBOutlet UIImageView *btnUserPic;
@property (weak, nonatomic) IBOutlet UIView *defaultView;

@property (strong, nonatomic) SettingsViewController *settingController;
@property (strong, nonatomic) UILabel	*circleHeaderLabel;  //动态lable
@property (strong, nonatomic) UILabel	*followHeaderLabel;  //关注label
@property (strong, nonatomic) UILabel	*fansHeaderLabel;  //粉丝label
@property (strong, nonatomic) UIButton *authButton;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *department;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *industry;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *head_img;

@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;
@property (assign, nonatomic) BOOL shouldRefresh;
@property (strong, nonatomic) NSString *auditState;
- (void)changeUserHeadImage;

@end
#define spaceWidth  0
#define labelWidth  (SCREENWIDTH - spaceWidth * 3.0f ) / 4.0f

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shouldRefresh = YES;
    self.nickName = @"";
    self.department = @"";
    self.company = @"";
    self.industry = @"";
    self.location = @"";
    self.head_img = nil;
    [self initUI];

    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:NO];
    CGRect frame = self.messageView.frame;
    frame.size.height = kMessageViewHeight;
    self.messageView.frame = frame;
    
    frame = self.labelView.frame;
    frame.size.height = klabelViewHeight ;
    frame.origin.y = kMessageViewHeight;
    self.labelView.frame = frame;
    self.headerView.height = kMessageViewHeight + klabelViewHeight + kSpaceMargin;
    
    frame = self.btnUserPic.frame;
    frame.origin.y = (kMessageViewHeight - frame.size.height) /2.0f;
    self.btnUserPic.frame = frame;
    self.defaultView.frame = frame;
    self.tableView.tableHeaderView = self.headerView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:NOTIFI_CHANGE_UPDATE_AUTO_STATUE object:nil];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(UILabel *)titleLabel
{
    if (!_titleLabel)
    {
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
        self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    }
    return _rightBarButtonItem;
}

-(void)refreshData
{
    [self getMyselfMaterial];
}

-(void)refreshHeader
{
    [self getMyselfMaterial];
}

- (void)getMyselfMaterial
{
    [self.btnUserPic setImage:[UIImage imageNamed:@"default_head"]];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"personaluser"] parameters:@{@"uid":uid}success:^(MOCHTTPResponse *response) {
        
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

        weakSelf.circleHeaderLabel.attributedText = aCircleString;
        weakSelf.followHeaderLabel.attributedText = aFollowString;
        weakSelf.fansHeaderLabel.attributedText = aFansString;

        weakSelf.txtNickName.text = [response.dataDictionary valueForKey:@"name"];
        weakSelf.nickName = [response.dataDictionary valueForKey:@"name"];
        if([response.dataDictionary valueForKey:@"titles"]){
            weakSelf.moneyLabel.text = [response.dataDictionary valueForKey:@"titles"];
            weakSelf.department = self.moneyLabel.text;
        } else{
            weakSelf.moneyLabel.text = @"暂无职称";
        }
        if([response.dataDictionary valueForKey:@"companyname"]){
            weakSelf.companyName.text = [response.dataDictionary valueForKey:@"companyname"];
            weakSelf.company = self.companyName.text;
        } else{
            weakSelf.companyName.text = @"暂无公司名";
        }

        if([response.dataDictionary valueForKey:@"industrycode"]){
            weakSelf.industry = [response.dataDictionary valueForKey:@"industrycode"];
        }

        if([response.dataDictionary valueForKey:@"head_img"]){
            weakSelf.head_img = [response.dataDictionary valueForKey:@"head_img"];
        }

        if([response.dataDictionary valueForKey:@"position"]){
            weakSelf.location = [response.dataDictionary valueForKey:@"position"];
        }

        //更改合适的位置
        CGSize size = [weakSelf.txtNickName sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        [self.txtNickName sizeToFit];
        CGRect frame = weakSelf.txtNickName.frame;
        frame.size.width = size.width;
        frame.origin.y = (kMessageViewHeight - self.btnUserPic.size.height) /2.0f;
        weakSelf.txtNickName.frame = frame;

        size = [weakSelf.moneyLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        [self.moneyLabel sizeToFit];
        frame = weakSelf.moneyLabel.frame;
        frame.origin.x = CGRectGetMaxX(weakSelf.txtNickName.frame) + kObjectMargin/2.0f;
        frame.origin.y = CGRectGetMaxY(self.txtNickName.frame) - CGRectGetHeight(frame);
        frame.size.width = size.width;
        weakSelf.moneyLabel.frame = frame;
        
        size = [weakSelf.companyName sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        [self.companyName sizeToFit];
        frame = self.companyName.frame;
        frame.origin.y = CGRectGetMaxY(self.btnUserPic.frame) - CGRectGetHeight(frame);
        self.companyName.frame = frame;
        
        NSString *headImageUrl = [response.dataDictionary valueForKey:@"head_img"];
        if (!IsStrEmpty(headImageUrl)) {
            UIImage *placeImage = weakSelf.btnUserPic.image;
            if(!placeImage){
                placeImage = [UIImage imageNamed:@"default_head"];
            }
            [weakSelf.btnUserPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,headImageUrl]] placeholderImage:placeImage];
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
        
    } failed:^(MOCHTTPResponse *response) {
        [weakSelf.tableView.header endRefreshing];
        
    }];
}

- (SettingsViewController *)settingController
{
    if (!_settingController) {
        _settingController = [[SettingsViewController alloc] init];
        _settingController.hidesBottomBarWhenPushed = YES;
    }
    return _settingController;
}
#pragma mark -设置
- (void)goToSettings
{
    if (self.nickName.length > 0) {
        self.settingController.userInfo = @{kNickName:self.nickName, kDepartment:self.department, kCompany:self.company, kLocation:self.location, kIndustry:self.industry, kHeaderImage:self.head_img};
        [self.navigationController	pushViewController:self.settingController animated:YES];
    }
}


- (void)initUI
{
    self.txtNickName.font = [UIFont systemFontOfSize:14.0f * FontFactor];
    self.moneyLabel.font = [UIFont systemFontOfSize:12.0f * FontFactor];
    self.companyName.font = [UIFont systemFontOfSize:12.0f * FontFactor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUserHeadImage)];
    tap.cancelsTouchesInView = YES;
    [self.btnUserPic addGestureRecognizer:tap];
    self.btnUserPic.userInteractionEnabled = YES;

    NSString *headImage = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_HEAD_IMAGE];
    [self.btnUserPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,headImage]] placeholderImage:[UIImage imageNamed:@"default_head"]];

    self.circleHeaderLabel.text = @"动态 \n0";
    self.followHeaderLabel.text = @"关注 \n0";
    self.fansHeaderLabel.text	= @"粉丝 \n0";

    UIView *spaceView1 = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH / 4.0f, (klabelViewHeight - 22.0f)/2.0f, 0.5f, 22.0f)];
    UIView *spaceView2 = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH / 4.0f * 2.0f,(klabelViewHeight - 22.0f)/2.0f, 0.5f, 22.0f)];
    UIView *spaceView3 = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH / 4.0f * 3.0f,(klabelViewHeight - 22.0f)/2.0f, 0.5f, 22.0f)];
    spaceView1.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    spaceView2.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    spaceView3.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];

    [self.labelView addSubview:spaceView1];
    [self.labelView addSubview:spaceView2];
    [self.labelView addSubview:spaceView3];

    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENHEIGHT, 0.5f)];
    topLine.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    [self.labelView addSubview:topLine];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)changeUserHeadImage
{
    UIActionSheet *takeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选图", nil];
    [takeSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"拍照");
        [self cameraClick];
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"选图");
        [self photosClick];
    }
    else if (buttonIndex == 2)
    {
        NSLog(@"取消");
    }
}

-(void)cameraClick
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [self presentViewController:pickerImage animated:YES completion:^{

    }];
}

-(void)photosClick
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [self presentViewController:pickerImage animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *newHeadiamge = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.btnUserPic.image = newHeadiamge;
    //更改头像不需要刷新界面了，直接更改头像图片
    self.shouldRefresh = NO;
    [self uploadHeadImage:newHeadiamge];
}

- (void)uploadHeadImage:(UIImage *)image
{
    //头像需要压缩 跟其他的上传图片接口不一样了
    [Hud showLoadingWithMessage:@"正在上传图片..."];
    [[AFHTTPRequestOperationManager manager] POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/basephoto"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
        [formData appendPartWithFileData:imageData name:@"hahaggg.jpg" fileName:@"hahaggg.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = [(NSString *)[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
        NSString *newHeadIamgeName = [(NSArray *)[dic valueForKey:@"pname"] objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:newHeadIamgeName forKey:KEY_HEAD_IMAGE];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_SENDPOST object:nil];
        
        [self putHeadImage:newHeadIamgeName];
        [Hud hideHud];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [Hud hideHud];
        [Hud showMessageWithText:@"上传图片失败"];
        
    }];
    
}

- (void)putHeadImage:(NSString *)headImageName
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    
    [[AFHTTPRequestOperationManager manager] PUT:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"modifyuser"] parameters:@{@"uid":uid,@"type":@"headimage",@"value":headImageName, @"title":self.department,  @"company":self.company} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        NSLog(@"%@",responseObject);
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            
            [Hud showMessageWithText:@"修改成功"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


#pragma mark -身份认证
- (void)actionAuth:(id)sender {
    VerifyIdentityViewController *vc = [[VerifyIdentityViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -邀请好友

- (void)actionInvite:(id)sender
{

    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:[UIImage imageNamed:@"80"]];

    NSString *contentOther =[NSString stringWithFormat:@"%@",@"诚邀您加入金融大牛圈！金融从业人员的家！"];

    NSString *content =[NSString stringWithFormat:@"%@%@",@"诚邀您加入大牛圈APP！金融从业人员的家！这里有干货资讯、人脉嫁接、业务互助！赶快加入吧！",[NSString stringWithFormat:@"%@?uid=%@",SHARE_YAOQING_URL,[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID]]];
    id<ISSShareActionSheetItem> item3 = [ShareSDK shareActionSheetItemWithTitle:@"短信" icon:[UIImage imageNamed:@"sns_icon_19"] clickHandler:^{
        [self shareToSMS:content];
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

-(void)shareToWeibo:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendmessageToShareWithObjContent:text rid:rid];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    return kRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MeCell";
    MeTableViewCell *cell = (MeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MeTableViewCell" owner:self options:nil] lastObject];
    }
    if (indexPath.row == 0) {
        cell.lblName.text = @"我的合伙人";
    } else if (indexPath.row == 1) {
        cell.lblName.text = @"我的佣金";
    } else if (indexPath.row == 2) {
        cell.lblName.text = @"我的预约";
    } else if (indexPath.row == 3) {
        cell.lblName.text = @"我的业务";
    } else if (indexPath.row == 4) {
        cell.lblName.text = @"我的收藏";
    } else if (indexPath.row == 5) {
        cell.lblName.text = @"设置";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0){
        MyTeamViewController *vc = [[MyTeamViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [MobClick event:@"MyTeamViewController" label:@"onClick"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        MyMoneyViewController *vc = [[MyMoneyViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [MobClick event:@"MyMoneyViewController" label:@"onClick"];
        [self.navigationController pushViewController:vc animated:YES];

    } else if (indexPath.row == 2) {
        MyAppointmentViewController *vc = [[MyAppointmentViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [MobClick event:@"MyAppointmentViewController" label:@"onClick"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 3) {
        SHGMarketMineViewController *marketMineViewController = [[SHGMarketMineViewController alloc] init];
        marketMineViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:marketMineViewController animated:YES];
        
    } else if (indexPath.row == 4) {
        MyCollectionViewController *vc = [[MyCollectionViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [MobClick event:@"MyCollectionViewController" label:@"onClick"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 5) {
        [self goToSettings];
    }
}
//处理tableView左边空白
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
}
#pragma mark - Init Methods
- (UILabel *)circleHeaderLabel
{
    if (!_circleHeaderLabel) {
        _circleHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceWidth, 0, labelWidth, klabelViewHeight)];
        _circleHeaderLabel.textAlignment = NSTextAlignmentCenter;
        _circleHeaderLabel.numberOfLines = 0;
        _circleHeaderLabel.font = [UIFont systemFontOfSize:11.0f * FontFactor] ;
        _circleHeaderLabel.textColor = [UIColor colorWithHexString:@"989898"];
        _circleHeaderLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMyCircle)];
        [_circleHeaderLabel addGestureRecognizer:tap];
        [self.labelView addSubview:_circleHeaderLabel];
    }
    return _circleHeaderLabel;
}

- (UILabel *)followHeaderLabel
{
    if (!_followHeaderLabel) {
        _followHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceWidth + labelWidth, 0, labelWidth, klabelViewHeight)];
        _followHeaderLabel.textAlignment = NSTextAlignmentCenter;
        _followHeaderLabel.numberOfLines = 0;
        _followHeaderLabel.font = [UIFont systemFontOfSize:11.0f * FontFactor];
        _followHeaderLabel.textColor = [UIColor colorWithHexString:@"989898"];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToFollowList)];
        [_followHeaderLabel addGestureRecognizer:tap];
        _followHeaderLabel.userInteractionEnabled = YES;

        [self.labelView addSubview:_followHeaderLabel];
    }

    return _followHeaderLabel;
}


- (UILabel *)fansHeaderLabel
{
    if (!_fansHeaderLabel) {
        _fansHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceWidth + labelWidth*2, 0, labelWidth, klabelViewHeight)];
        _fansHeaderLabel.textAlignment = NSTextAlignmentCenter;
        _fansHeaderLabel.textColor = [UIColor colorWithHexString:@"989898"];
        _fansHeaderLabel.numberOfLines = 0;
        _fansHeaderLabel.font = [UIFont systemFontOfSize:11.0f * FontFactor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToFansList)];
        [_fansHeaderLabel addGestureRecognizer:tap];
        _fansHeaderLabel.userInteractionEnabled = YES;
        [self.labelView addSubview:_fansHeaderLabel];
    }

    return _fansHeaderLabel;
}

- (UIButton *)authButton
{
    if (!_authButton) {
        _authButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _authButton.frame = CGRectMake(spaceWidth + labelWidth * 3.0f, 0, labelWidth, self.labelView.height);
        [_authButton setImage:[UIImage imageNamed:@"me_unAuth"] forState:UIControlStateNormal];
        [_authButton addTarget:self action:@selector(actionAuth:) forControlEvents:UIControlEventTouchUpInside];
        [self.labelView addSubview:_authButton];
    }

    return _authButton;
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
    MyFollowViewController *vc = [[MyFollowViewController alloc] init];
    vc.relationShip = 1;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToFansList
{
    MyFollowViewController *vc = [[MyFollowViewController alloc] init];
    vc.relationShip = 2;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end