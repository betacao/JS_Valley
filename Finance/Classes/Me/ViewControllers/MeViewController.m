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
#import "SHGModifyInfoViewController.h"
#import "SHGUserTagModel.h"

//为标签弹出框定义的值
#define kItemTopMargin  18.0f * XFACTOR
#define kItemMargin 14.0f * XFACTOR
#define kItemHeight 25.0f * XFACTOR

@interface MeViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,ModifyInfoDelegate>

@property (weak, nonatomic) IBOutlet UITableView	*tableView;
@property (weak, nonatomic) IBOutlet UIView		*headerView;
@property (weak, nonatomic) IBOutlet UIView     *labelView;
@property (weak, nonatomic) IBOutlet UILabel    *moneyLabel;  //职位
@property (weak, nonatomic) IBOutlet UIButton   *btnEdit;
@property (weak, nonatomic) IBOutlet UILabel    *txtNickName;
@property (weak, nonatomic) IBOutlet UILabel    *companyName; //公司名称
@property (weak, nonatomic) IBOutlet UIImageView *btnUserPic;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UIButton *tagButton;
@property (weak, nonatomic) IBOutlet UIButton *invateButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (strong, nonatomic) SettingsViewController *vc;
@property (strong, nonatomic) UILabel	*circleHeaderLabel;  //动态lable
@property (strong, nonatomic) UILabel	*followHeaderLabel;  //关注label
@property (strong, nonatomic) UILabel	*fansHeaderLabel;  //粉丝label
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *department;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) SHGTagsView *tagsView;

@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;
@property (strong ,nonatomic) SHGModifyInfoViewController *modifyInfoController;
@property (assign, nonatomic) BOOL shouldRefresh;

- (IBAction)actionInvite:(id)sender;
- (IBAction)actionAuth:(id)sender;
- (IBAction)actionEdit:(id)sender;
- (void)changeUserHeadImage;

@end

#define spaceWidth  0
#define labelWidth  (SCREENWIDTH - spaceWidth*2)/3

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shouldRefresh = YES;
    self.nickName = @"";
    self.department = @"";
    self.company = @"";
    [self initUI];

    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:NO];
    self.tableView.tableHeaderView = self.headerView;
    
    //处理tableView左边空白
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self downloadUserSelectedInfo];
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
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:17.0f];
        _titleLabel.textColor = TEXT_COLOR;
        _titleLabel.text = @"个人中心";
    }
    return _titleLabel;
}
- (UIBarButtonItem *)rightBarButtonItem
{
    if (!_rightBarButtonItem) {

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [button addTarget:self action:@selector(goToSettings) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"me_settings"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"me_settings"] forState:UIControlStateHighlighted];

        self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    }
    return _rightBarButtonItem;
}

- (SHGModifyInfoViewController *)modifyInfoController
{
    if(!_modifyInfoController){
        _modifyInfoController = [[SHGModifyInfoViewController alloc] initWithNibName:@"SHGModifyInfoViewController" bundle:nil];
        _modifyInfoController.delegate = self;
    }
    return _modifyInfoController;
}

-(void)refreshData
{
    [self getMyselfMaterial];
}

-(void)refreshHeader
{
    [self getMyselfMaterial];
}

- (void)downloadUserSelectedInfo
{
    __weak typeof(self)weakSelf = self;
    [[SHGGloble sharedGloble] downloadUserTagInfo:^{
        //宽度设置和弹出框的线一样宽
        weakSelf.tagsView = [[SHGTagsView alloc] initWithFrame:CGRectMake(kLineViewLeftMargin, 0.0f, kAlertWidth - 2 * kLineViewLeftMargin, 0.0f)];
    }];
}

- (void)getMyselfMaterial
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"personaluser"] parameters:@{@"uid":uid}success:^(MOCHTTPResponse *response) {
        
        NSString *circleCount = [response.dataDictionary valueForKey:@"circles"];
        NSString *followCount = [response.dataDictionary valueForKey:@"attention"];
        NSString *fansCount = [response.dataDictionary valueForKey:@"fans"];
        
        NSString *circleString = [NSString stringWithFormat:@"动态 %@",circleCount];
        NSString *followString = [NSString stringWithFormat:@"关注 %@",followCount];
        NSString *fansString = [NSString stringWithFormat:@"粉丝 %@",fansCount];
        
        self.circleHeaderLabel.text = circleString;
        self.followHeaderLabel.text = followString;
        self.fansHeaderLabel.text = fansString;

        self.txtNickName.text = [response.dataDictionary valueForKey:@"name"];
        self.nickName = [response.dataDictionary valueForKey:@"name"];
        if([response.dataDictionary valueForKey:@"titles"]){
            self.moneyLabel.text = [response.dataDictionary valueForKey:@"titles"];
            self.department = self.moneyLabel.text;
        } else{
            self.moneyLabel.text = @"暂无职称";
        }
        if([response.dataDictionary valueForKey:@"companyname"]){
            self.companyName.text = [response.dataDictionary valueForKey:@"companyname"];
            self.company = self.companyName.text;
        } else{
            self.companyName.text = @"暂无公司名";
        }
        if([response.dataDictionary valueForKey:@"phone"]){
            self.phoneLabel.text = [response.dataDictionary valueForKey:@"phone"];
        } else{
            self.phoneLabel.text = @"";
        }

        if([response.dataDictionary valueForKey:@"position"]){
            self.locationLabel.text = [response.dataDictionary valueForKey:@"position"];
        } else{
            self.locationLabel.text = @"";
        }

        NSString *headImageUrl = [response.dataDictionary valueForKey:@"head_img"];
        if (!IsStrEmpty(headImageUrl)) {
            UIImage *placeImage = self.btnUserPic.image;
            if(!placeImage){
                placeImage = [UIImage imageNamed:@"default_head"];
            }
            [self.btnUserPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,headImageUrl]] placeholderImage:placeImage];
        }
        
        [self.tableView.header endRefreshing];
        NSLog(@"%@",response.dataDictionary);
        NSLog(@"%@",response.data);
        NSLog(@"%@",response.errorMessage);
        
    } failed:^(MOCHTTPResponse *response) {
        [self.tableView.header endRefreshing];
        
    }];
}
-(SettingsViewController *)vc
{
    if (!_vc) {
        _vc = [[SettingsViewController alloc] init];
        _vc.hidesBottomBarWhenPushed = YES;
        
    }
    return _vc;
}
#pragma mark -设置
- (void)goToSettings
{
    [self.navigationController	pushViewController:self.vc animated:YES];
}

-(void)initUI
{
    self.btnUserPic.layer.masksToBounds = YES;
    self.btnUserPic.layer.cornerRadius = CGRectGetHeight(self.btnUserPic.frame) / 2.0f;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUserHeadImage)];
    tap.cancelsTouchesInView = YES;
    [self.btnUserPic addGestureRecognizer:tap];
    self.btnUserPic.userInteractionEnabled = YES;

    NSString *headImage = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_HEAD_IMAGE];
    [self.btnUserPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,headImage]] placeholderImage:[UIImage imageNamed:@"default_head"]];

    self.circleHeaderLabel.text = @"动态 0";
    self.followHeaderLabel.text = @"关注 0";
    self.fansHeaderLabel.text	= @"粉丝 0";

    UIView *spaceView1 = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH / 3.0f, 10.0f, 0.5f, 30)];
    UIView *spaceView2 = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH / 3.0f * 2.0f,10.0f, 0.5f, 30)];
    spaceView1.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
    spaceView2.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.labelView.frame) - 1.0f, SCREENHEIGHT, 0.5f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
    [self.labelView addSubview:lineView];
    [self.labelView addSubview:spaceView1];
    [self.labelView addSubview:spaceView2];

    UIImage *image = [[UIImage imageNamed:@"me_line"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0f, 100.0f, 40.0f, 100.0f) resizingMode:UIImageResizingModeStretch];
    self.lineImageView.image = image;

    CGRect frame = self.verifyButton.frame;
    CGFloat margin = (SCREENWIDTH - CGRectGetWidth(frame) * 4.0f) / 8.0f;
    frame.origin.x = margin;
    self.verifyButton.frame = frame;

    frame = self.btnEdit.frame;
    frame.origin.x = 3.0f * margin + CGRectGetWidth(frame);
    self.btnEdit.frame = frame;

    frame = self.tagButton.frame;
    frame.origin.x = 5.0f * margin + 2.0f * CGRectGetWidth(frame);
    self.tagButton.frame = frame;

    frame = self.invateButton.frame;
    frame.origin.x = 7.0f * margin + 3.0f * CGRectGetWidth(frame);
    self.invateButton.frame = frame;

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

#pragma mark －修改名字
- (IBAction)actionEdit:(id)sender {
    if(!self.modifyInfoController.view.superview){
        [self.modifyInfoController loadInitInfo:@{kNickName:self.nickName, kDepartment:self.department, kCompany:self.company}];
        [self.view.window addSubview:self.modifyInfoController.view];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101){
        if (buttonIndex == 1) {
            
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
            NSString *newNicName = [alertView textFieldAtIndex:0].text;
            if (IsStrEmpty(newNicName)) {
                [Hud showMessageWithText:@"名字不能不为空"];
                return;
            }
            if (newNicName.length > 12) {
                [Hud showMessageWithText:@"名字过长，最大长度为12个字"];
                return;
            }
            [[AFHTTPRequestOperationManager manager] PUT:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"modifyuser"] parameters:@{@"uid":uid,@"type":@"name",@"value":newNicName} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",operation);
                NSLog(@"%@",responseObject);
                NSString *code = [responseObject valueForKey:@"code"];
                if ([code isEqualToString:@"000"]) {
                    self.txtNickName.text = newNicName;
                    [MobClick event:@"ActionEditName" label:@"onClick"];
                    self.nickName = self.txtNickName.text;
                    [[NSUserDefaults standardUserDefaults] setObject:self.nickName forKey:KEY_USER_NAME];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_SENDPOST object:nil];
                    
                }else{
                    [Hud showMessageWithText:@"修改失败"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Hud showMessageWithText:@"修改失败"];
            }];
        }
        
    }
}


#pragma mark -身份认证
- (IBAction)actionAuth:(id)sender {
    VerifyIdentityViewController *vc = [[VerifyIdentityViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------标签

- (IBAction)changeTags:(id)sender
{
    if(self.tagsView){
        __weak typeof(self) weakSelf = self;
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"选择喜欢的标签方向" customView:self.tagsView leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        alert.rightBlock = ^{
            NSArray *array = [weakSelf.tagsView userSelectedTags];
            [[SHGGloble sharedGloble] uploadUserSelectedInfo:array completion:^(BOOL finished) {
               
            }];
        };
        [[SHGGloble sharedGloble] downloadUserSelectedInfo:^{
            [weakSelf.tagsView updateSelectedArray];
            [alert customShow];
        }];
    } else{
        [Hud showMessageWithText:@"正在拉取标签列表"];
    }
}
#pragma mark -邀请好友

- (IBAction)actionInvite:(id)sender {

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
    NSArray *shareList = [ShareSDK customShareListWithType:item3, item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), nil];

    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:contentOther defaultContent:SHARE_DEFAULT_CONTENT image:image title:SHARE_TITLE_INVITE url:shareUrl description:SHARE_DEFAULT_CONTENT mediaType:SHARE_TYPE];

    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:shareList content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess){
            [MobClick event:@"ActionInviteFriend" label:@"onClick"];
            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
        }
        else if (state == SSResponseStateFail){
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
            [Hud showMessageWithText:@"请您先安装手机QQ再分享动态"];

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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    }else if (indexPath.row == 1) {
        cell.lblName.text = @"我的佣金";
    }else if (indexPath.row == 2) {
        cell.lblName.text = @"我的订单";
    }else if (indexPath.row == 3) {
        cell.lblName.text = @"我的收藏";
    }else if (indexPath.row == 4) {
        cell.lblName.text = @"我的地址";
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
    }
    else if (indexPath.row == 1) {
        MyMoneyViewController *vc = [[MyMoneyViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [MobClick event:@"MyMoneyViewController" label:@"onClick"];
        [self.navigationController pushViewController:vc animated:YES];

    }else if (indexPath.row == 2) {
        MyAppointmentViewController *vc = [[MyAppointmentViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [MobClick event:@"MyAppointmentViewController" label:@"onClick"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3) {
        MyCollectionViewController *vc = [[MyCollectionViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [MobClick event:@"MyCollectionViewController" label:@"onClick"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4) {
        MyAddressViewController *vc = [[MyAddressViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [MobClick event:@"MyAddressViewController" label:@"onClick"];
        [self.navigationController pushViewController:vc animated:YES];
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
        _circleHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceWidth, 0, labelWidth, self.labelView.height)];
        _circleHeaderLabel.textAlignment = NSTextAlignmentCenter;
        _circleHeaderLabel.numberOfLines = 0;
        _circleHeaderLabel.font = [UIFont systemFontOfSize:13.0f] ;
        _circleHeaderLabel.textColor = [UIColor colorWithHexString:@"434343"];
        _circleHeaderLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMyCircle)];
        [_circleHeaderLabel addGestureRecognizer:tap];
        [self.labelView addSubview:_circleHeaderLabel];
    }
    return _circleHeaderLabel;
}
-(void)goToMyCircle
{
    CircleSomeOneViewController *vc = [[CircleSomeOneViewController alloc] initWithNibName:@"CircleSomeOneViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userId =[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    vc.userName = @"我";
    [self.navigationController pushViewController:vc animated:YES];
}


- (UILabel *)followHeaderLabel
{
    if (!_followHeaderLabel) {
        _followHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceWidth + labelWidth, 0, labelWidth, self.labelView.height)];
        _followHeaderLabel.textAlignment = NSTextAlignmentCenter;
        _followHeaderLabel.numberOfLines = 0;
        _followHeaderLabel.font = [UIFont systemFontOfSize:13.0f];
        _followHeaderLabel.textColor = [UIColor colorWithHexString:@"434343"];
        
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
        _fansHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceWidth + labelWidth*2, 0, labelWidth, self.labelView.height)];
        _fansHeaderLabel.textAlignment = NSTextAlignmentCenter;
        _fansHeaderLabel.textColor = [UIColor colorWithHexString:@"434343"];
        _fansHeaderLabel.numberOfLines = 0;
        _fansHeaderLabel.font = [UIFont systemFontOfSize:13.0f];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToFansList)];
        [_fansHeaderLabel addGestureRecognizer:tap];
        _fansHeaderLabel.userInteractionEnabled = YES;
        [self.labelView addSubview:_fansHeaderLabel];
    }
    
    return _fansHeaderLabel;
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

- (void)didModifyUserInfo:(NSDictionary *)dictionary
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *newNicName = [dictionary objectForKey:kNickName];
    NSString *department = [dictionary objectForKey:kDepartment];
    NSString *company = [dictionary objectForKey:kCompany];
    
    [[AFHTTPRequestOperationManager manager] PUT:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"modifyuser"] parameters:@{@"uid":uid,@"type":@"name",@"value":newNicName, @"title":department, @"company":company} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        NSLog(@"%@",responseObject);
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            self.txtNickName.text = newNicName;
            self.moneyLabel.text = department;
            self.companyName.text = company;
            [MobClick event:@"ActionEditName" label:@"onClick"];
            self.nickName = newNicName;
            self.department = department;
            self.company = company;
            [[NSUserDefaults standardUserDefaults] setObject:self.nickName forKey:KEY_USER_NAME];
            [Hud showMessageWithText:@"修改个人信息成功"];
            [self performSelector:@selector(delayPostNotification) withObject:nil afterDelay:1.2f];
        }else{
            [Hud showMessageWithText:@"修改个人信息失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Hud showMessageWithText:@"修改个人信息失败"];
    }];
}

- (void)delayPostNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_SENDPOST object:nil];
}

@end


#pragma mark ------tagsView

@interface SHGTagsView ()

@property (strong, nonatomic) NSMutableArray *selectedArray;
@property (strong, nonatomic) NSMutableArray *buttonArray;

@end



@implementation SHGTagsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.selectedArray = [NSMutableArray array];
        self.buttonArray = [NSMutableArray array];
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    NSArray *tagsArray = [SHGGloble sharedGloble].tagsArray;
    CGFloat width = (CGRectGetWidth(self.frame) - 2 * kItemMargin) / 3.0f;
    for(SHGUserTagModel *model in tagsArray){
        NSInteger index = [tagsArray indexOfObject:model];
        NSInteger row = index / 3;
        NSInteger col = index % 3;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = [UIColor colorWithHexString:@"D6D6D6"].CGColor;
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];

        [button setTitle:model.tagName forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"8c8c8c"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f95c53"]] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f95c53"]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(didSelectCategory:) forControlEvents:UIControlEventTouchUpInside];
        CGRect frame = CGRectMake((kItemMargin + width) * col, kItemTopMargin + (kItemMargin + kItemHeight) * row, width, kItemHeight);
        button.frame = frame;
        [self addSubview:button];
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(button.frame);
        self.frame = frame;
        [self.buttonArray addObject:button];
    }
}

- (void)updateSelectedArray
{
    NSArray *selectedArray = [SHGGloble sharedGloble].selectedTagsArray;
    NSArray *tagsArray = [SHGGloble sharedGloble].tagsArray;
    [self.selectedArray removeAllObjects];
    [self clearButtonState];
    for(SHGUserTagModel *model in selectedArray){
        NSInteger index = [tagsArray indexOfObject:model];
        NSLog(@"......%ld",(long)index);
        [self.selectedArray addObject:@(index)];
        UIButton *button = [self.buttonArray objectAtIndex:index];
        if(button){
            [button setSelected:YES];
        }
    }
}

- (void)didSelectCategory:(UIButton *)button
{
    BOOL isSelecetd = button.selected;
    NSInteger index = [self.buttonArray indexOfObject:button];
    if(!isSelecetd){
        if(self.selectedArray.count >= 3){
            [Hud showMessageWithText:@"最多选3项"];
        } else{
            button.selected = !isSelecetd;
            [self.selectedArray addObject:@(index)];
        }
    } else{
        button.selected = !isSelecetd;
        [self.selectedArray removeObject:@(index)];
    }
}

- (void)clearButtonState
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIButton class]]){
            UIButton *button = (UIButton *)obj;
            [button setSelected:NO];
        }
    }];
}

- (NSArray *)userSelectedTags
{
    return self.selectedArray;
}

@end