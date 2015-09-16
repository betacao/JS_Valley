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

@interface MeViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,ModifyInfoDelegate>
{
}
@property (weak, nonatomic) IBOutlet UITableView	*tableView;
@property (weak, nonatomic) IBOutlet UIView		*headerView;
@property (weak, nonatomic) IBOutlet UIImageView	*headerBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (strong, nonatomic) SettingsViewController *vc;
@property (strong, nonatomic) UILabel	*circleHeaderLabel;  //动态lable
@property (strong, nonatomic) UILabel	*followHeaderLabel;  //关注label
@property (strong, nonatomic) UILabel	*fansHeaderLabel;  //粉丝label
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;  //职位
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UITextField *txtNickName;
@property (weak, nonatomic) IBOutlet UILabel *companyName; //公司名称
@property (weak, nonatomic) IBOutlet UIImageView *btnUserPic;
@property (weak, nonatomic) IBOutlet UIImageView *VImageView;

@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *department;
@property (strong, nonatomic) NSString *company;

@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;
@property (assign, nonatomic) BOOL shouldRefresh;
@property (strong ,nonatomic) SHGModifyInfoViewController *modifyInfoController;

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
    NSString *headImage = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_HEAD_IMAGE];
    self.btnUserPic.contentMode = UIViewContentModeScaleAspectFit;
    [self.btnUserPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,headImage]] placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    self.tableView.tableHeaderView = self.headerView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:NOTIFI_CHANGE_UPDATE_AUTO_STATUE object:nil];
    self.circleHeaderLabel.text = @"0\n动态";
    self.followHeaderLabel.text = @"0\n关注";
    self.fansHeaderLabel.text	= @"0\n粉丝";
    UIView *spaceView1 = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/3,15, 1, 30)];
    UIView *spaceView2 = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/3*2,15, 1, 30)];
    spaceView1.backgroundColor = [[UIColor alloc]initWithHue:0 saturation:0 brightness:0 alpha:0.2];
    spaceView2.backgroundColor = [[UIColor alloc]initWithHue:0 saturation:0 brightness:0 alpha:0.2];
    
    [self.labelView addSubview:spaceView1];
    [self.labelView addSubview:spaceView2];
    
    //处理tableView左边空白
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)refreshHeader
{
    [self getMyselfMaterial];
}
-(UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        _titleLabel.font = [UIFont fontWithName:@"Palatino" size:17];
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_txtNickName resignFirstResponder];
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
-(void)refreshData
{
    [self getMyselfMaterial];
}
- (void)getMyselfMaterial
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"personaluser"] parameters:@{@"uid":uid}success:^(MOCHTTPResponse *response) {
        
        NSString *circleCount = [response.dataDictionary valueForKey:@"circles"];
        NSString *followCount = [response.dataDictionary valueForKey:@"attention"];
        NSString *fansCount = [response.dataDictionary valueForKey:@"fans"];
        
        NSString *circleString = [NSString stringWithFormat:@"%@\n动态",circleCount];
        NSString *followString = [NSString stringWithFormat:@"%@\n关注",followCount];
        NSString *fansString = [NSString stringWithFormat:@"%@\n粉丝",fansCount];
        
        NSMutableAttributedString *circleAttributedString = [[NSMutableAttributedString alloc] initWithString:circleString];
        NSMutableAttributedString *followAttributedString = [[NSMutableAttributedString alloc] initWithString:followString];
        NSMutableAttributedString *fansAttributedString = [[NSMutableAttributedString alloc] initWithString:fansString];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5.0];//调整行间距
        
        [circleAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, circleString.length)];
        [followAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, followString.length)];
        [fansAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, fansString.length)];
        
        self.circleHeaderLabel.attributedText = circleAttributedString;
        self.followHeaderLabel.attributedText = followAttributedString;
        self.fansHeaderLabel.attributedText = fansAttributedString;
        
        self.circleHeaderLabel.textAlignment = NSTextAlignmentCenter;
        self.followHeaderLabel.textAlignment = NSTextAlignmentCenter;
        self.fansHeaderLabel.textAlignment = NSTextAlignmentCenter;
        
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
        
        if([response.dataDictionary valueForKey:@"userstatus"]){
            NSString *userStatus = [response.dataDictionary valueForKey:@"userstatus"];
            if(userStatus && [userStatus isEqualToString:@"true"]){
                self.VImageView.hidden = YES;
            } else{
                self.VImageView.hidden = YES;
            }
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
    self.btnUserPic.layer.borderWidth = 2;
    self.btnUserPic.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnUserPic.layer.borderColor = [[UIColor whiteColor] CGColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUserHeadImage)];
    tap.cancelsTouchesInView = YES;
    [self.btnUserPic addGestureRecognizer:tap];
    self.btnUserPic.userInteractionEnabled = YES;
    self.VImageView.hidden = YES;
}
-(void)loadUI
{
    CGSize size = [self.txtNickName.text sizeWithFont:self.txtNickName.font constrainedToSize:CGSizeMake(200, 25)];
    CGRect rect = self.btnEdit.frame;
    rect.origin.x = self.txtNickName.frame.origin.x + size.width + 15;
    self.btnEdit.frame = rect;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [Hud showLoadingWithMessage:@"正在上传图片..."];
    [[AFHTTPRequestOperationManager manager] POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/base"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
#pragma mark -邀请好友

- (IBAction)actionInvite:(id)sender {
    
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:[UIImage imageNamed:@"80"]];
    
    NSString *contentOther =[NSString stringWithFormat:@"%@",@"诚邀您加入金融大牛圈！金融从业人员的家！"];
    
    NSString *content =[NSString stringWithFormat:@"%@%@",@"诚邀您加入大牛圈APP！金融从业人员的家！这里有干货资讯、人脉嫁接、业务互助！赶快加入吧！",[NSString stringWithFormat:@"%@?uid=%@",SHARE_YAOQING_URL,[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID]]];
    id<ISSShareActionSheetItem> item3 = [ShareSDK shareActionSheetItemWithTitle:@"短信"
                                                                           icon:[UIImage imageNamed:@"sns_icon_19"]
                                                                   clickHandler:^{
                                                                       [self shareToSMS:content];
                                                                   }];
    id<ISSShareActionSheetItem> item0 = [ShareSDK shareActionSheetItemWithTitle:@"新浪微博"
                                                                           icon:[UIImage imageNamed:@"sns_icon_1"]
                                                                   clickHandler:^{
                                                                       [self shareToWeibo:content rid:contentOther];
                                                                   }];
    NSString *shareUrl =[NSString stringWithFormat:@"%@?uid=%@",SHARE_YAOQING_URL,[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID]];
    id<ISSShareActionSheetItem> item4 = [ShareSDK shareActionSheetItemWithTitle:@"微信朋友圈"
                                                                           icon:[UIImage imageNamed:@"sns_icon_23"]
                                                                   clickHandler:^{
                                                                       [[AppDelegate currentAppdelegate] wechatShareWithText:contentOther shareUrl:shareUrl shareType:1];
                                                                   }];
    id<ISSShareActionSheetItem> item5 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友"
                                                                           icon:[UIImage imageNamed:@"sns_icon_22"]
                                                                   clickHandler:^{
                                                                       [[AppDelegate currentAppdelegate] wechatShareWithText:contentOther shareUrl:shareUrl shareType:0];
                                                                   }];
    NSArray *shareList = [ShareSDK customShareListWithType:
                          item3,
                          item5,
                          item4,
                          SHARE_TYPE_NUMBER(ShareTypeQQ),
                          nil];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:contentOther
                                       defaultContent:SHARE_DEFAULT_CONTENT
                                                image:image
                                                title:SHARE_TITLE_INVITE
                                                  url:shareUrl
                                          description:SHARE_DEFAULT_CONTENT
                                            mediaType:SHARE_TYPE];
    //创建弹出菜单容器
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    [MobClick event:@"ActionInviteFriend" label:@"onClick"];
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    [Hud showMessageWithText:@"分享失败"];
                                    
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
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.txtNickName) {
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
        [[AFHTTPRequestOperationManager manager] PUT:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"modifyuser"] parameters:@{@"uid":uid,@"type":@"name",@"value":self.txtNickName.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",operation);
            NSLog(@"%@",responseObject);
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                self.nickName = self.txtNickName.text;
            }else{
                self.txtNickName.text = self.nickName;
                [Hud showMessageWithText:@"修改失败"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.txtNickName.text = self.nickName;
            [Hud showMessageWithText:@"修改失败"];
        }];
    }
    
    return YES;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    view.backgroundColor = RGB(234, 234, 234);
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MeCell";
    MeTableViewCell *cell = (MeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell =   [[[NSBundle mainBundle] loadNibNamed:@"MeTableViewCell" owner:self options:nil] lastObject];
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
        _circleHeaderLabel.font = [UIFont fontWithName:@"Palatino" size:13.0f] ;
        _circleHeaderLabel.textColor = TEXT_COLOR;
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
        _followHeaderLabel.font = [UIFont fontWithName:@"Palatino" size:13.0f];
        _followHeaderLabel.textColor = TEXT_COLOR;
        
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
        _fansHeaderLabel.textColor = TEXT_COLOR;
        _fansHeaderLabel.numberOfLines = 0;
        _fansHeaderLabel.font = [UIFont fontWithName:@"Palatino" size:13.0f];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_SENDPOST object:nil];
            
        }else{
            [Hud showMessageWithText:@"修改失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Hud showMessageWithText:@"修改失败"];
    }];
}



@end
