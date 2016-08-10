//
//  SHGAuthenticationViewController.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/17.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGAuthenticationViewController.h"
#import "SHGProvincesViewController.h"
#import "CCLocationManager.h"
#import "SHGAuthenticationWarningView.h"
#import "SHGIndustrySelectView.h"
@interface SHGAuthenticationViewController ()<UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SHGAreaDelegate>
//
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *stateNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authTipView;
@property (weak, nonatomic) IBOutlet UIImageView *authImageView;
@property (weak, nonatomic) IBOutlet UILabel *authTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
//
@property (weak, nonatomic) IBOutlet UIScrollView *authScrollView;
@property (weak, nonatomic) IBOutlet UITextField *departmentField;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UIView *roundCornerView;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) UIButton *currentButton;
//
@property (strong, nonatomic) SHGAuthenticationWarningView *warningView;
@property (strong, nonatomic) UIImage *headerImage;
@property (strong, nonatomic) NSString *state;//认证状态
@property (strong, nonatomic) NSString *authImageUrl;//已经上传的图片链接
@property (strong, nonatomic) UIImage *authImage;//认证的图片
@property (strong, nonatomic) NSString *departmentCode;
@property (strong, nonatomic) NSString *company;//保存一下 没什么用
@property (strong, nonatomic) NSString *rejectReason;//
@end

@implementation SHGAuthenticationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"身份认证";
    [self initView];
    [self addAutoLayout];
    self.authScrollView.alpha = 0.0f;
    [self loadUserState];
}

- (void)initView
{
    //
    self.view.backgroundColor = Color(@"f7f8f9");
    self.topView.backgroundColor = [UIColor whiteColor];
    self.stateNameLabel.font = self.stateLabel.font = FontFactor(16.0f);
    self.stateNameLabel.textColor = Color(@"828282");
    self.stateNameLabel.text = @"当前状态：";

    self.stateLabel.textColor = Color(@"3588c8");

    self.authImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.authImageView.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;

    self.authTipLabel.font = FontFactor(13.0f);
    self.authTipLabel.textColor = Color(@"999999");
    self.authTipLabel.isAttributedContent = YES;

    //
    WEAK(self, weakSelf);
    self.warningView = [[SHGAuthenticationWarningView alloc] init];
    self.warningView.text = @"完成个人认证每日可查看5条业务联系方式";
    self.warningView.block = ^{
        [UIView animateWithDuration:0.25f animations:^{
            weakSelf.warningView.sd_layout
            .heightIs(0.0f);
            [weakSelf.warningView updateLayout];
        }];
    };
    [self.authScrollView addSubview:self.warningView];

    self.authScrollView.backgroundColor = Color(@"f7f8f9");
    self.departmentField.textColor = self.locationField.textColor = Color(@"161616");
    self.departmentField.font = self.locationField.font = FontFactor(15.0f);
    self.departmentField.layer.borderColor = self.locationField.layer.borderColor = [UIColor lightGrayColor].CGColor;

    self.departmentField.layer.borderWidth = self.locationField.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    [self.departmentField setValue:Color(@"bebebe")forKeyPath:@"_placeholderLabel.textColor"];
    [self.locationField setValue:Color(@"bebebe") forKeyPath:@"_placeholderLabel.textColor"];

    self.roundCornerView.backgroundColor = Color(@"eeeff0");

    self.tipLabel.text = @"请上传您的名片、工牌或公司邮箱后台截图等任一材料";
    self.tipLabel.textColor = Color(@"8f8f8f");
    self.tipLabel.font = FontFactor(14.0f);

    self.submitButton.titleLabel.font = FontFactor(15.0f);
    self.submitButton.backgroundColor = Color(@"f04241");
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)addAutoLayout
{
    //
    self.topView.sd_layout
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f)
    .topSpaceToView(self.scrollView, 0.0f)
    .heightIs(MarginFactor(50.0f));

    self.stateNameLabel.sd_layout
    .centerYEqualToView(self.topView)
    .leftSpaceToView(self.topView, MarginFactor(15.0f))
    .heightRatioToView(self.topView, 1.0f);
    [self.stateNameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.stateLabel.sd_layout
    .centerYEqualToView(self.topView)
    .leftSpaceToView(self.stateNameLabel, MarginFactor(5.0f))
    .heightRatioToView(self.topView, 1.0f);
    [self.stateLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.authTipView.sd_layout
    .centerXEqualToView(self.scrollView)
    .topSpaceToView(self.scrollView, MarginFactor(116.0f))
    .widthIs(self.authTipView.image.size.width)
    .heightIs(self.authTipView.image.size.height);

    self.authImageView.sd_layout
    .topSpaceToView(self.authTipView, MarginFactor(72.0f))
    .leftSpaceToView(self.scrollView, MarginFactor(30.0f))
    .rightSpaceToView(self.scrollView, MarginFactor(30.0f))
    .heightIs(MarginFactor(184.0f));

    self.authTipLabel.sd_layout
    .topSpaceToView(self.authImageView, MarginFactor(15.0f))
    .leftEqualToView(self.authImageView)
    .rightEqualToView(self.authImageView)
    .autoHeightRatio(0.0f);

    //
    self.warningView.sd_layout
    .leftSpaceToView(self.authScrollView, 0.0f)
    .rightSpaceToView(self.authScrollView, 0.0f)
    .topSpaceToView(self.authScrollView, 0.0f)
    .heightIs(MarginFactor(39.0f));

    self.headerButton.sd_layout
    .topSpaceToView(self.warningView, MarginFactor(46.0f))
    .centerXEqualToView(self.authScrollView)
    .widthIs(self.headerButton.currentImage.size.width)
    .heightIs(self.headerButton.currentImage.size.height);

    self.departmentField.sd_layout
    .topSpaceToView(self.headerButton, MarginFactor(46.0f))
    .leftSpaceToView(self.authScrollView, MarginFactor(15.0f))
    .rightSpaceToView(self.authScrollView, MarginFactor(15.0f))
    .heightIs(MarginFactor(42.0f));

    self.locationField.sd_layout
    .topSpaceToView(self.departmentField, MarginFactor(20.0f))
    .leftEqualToView(self.departmentField)
    .rightEqualToView(self.departmentField)
    .heightIs(MarginFactor(42.0f));

    self.roundCornerView.sd_layout
    .topSpaceToView(self.locationField, MarginFactor(38.0f))
    .leftEqualToView(self.departmentField)
    .rightEqualToView(self.departmentField)
    .heightIs(MarginFactor(150.0f));
    self.roundCornerView.sd_cornerRadius = @(10.0f);

    self.plusButton.sd_layout
    .centerYEqualToView(self.roundCornerView)
    .leftSpaceToView(self.roundCornerView, MarginFactor(30.0f))
    .widthIs(self.plusButton.currentImage.size.width)
    .heightIs(self.plusButton.currentImage.size.height);

    self.tipLabel.sd_layout
    .centerYEqualToView(self.roundCornerView)
    .leftSpaceToView(self.plusButton, MarginFactor(22.0f))
    .rightSpaceToView(self.roundCornerView, MarginFactor(30.0f))
    .autoHeightRatio(0.0f);

    self.submitButton.sd_layout
    .leftSpaceToView(self.view, MarginFactor(15.0f))
    .rightSpaceToView(self.view, MarginFactor(15.0f))
    .bottomSpaceToView(self.view, MarginFactor(19.0f))
    .heightIs(MarginFactor(40.0f));

    self.scrollView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.submitButton, 0.0f);
    [self.scrollView setupAutoContentSizeWithBottomView:self.authImageView bottomMargin:MarginFactor(10.0f)];

    self.authScrollView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.submitButton, 0.0f);
    [self.authScrollView setupAutoContentSizeWithBottomView:self.roundCornerView bottomMargin:MarginFactor(10.0f)];
}

- (NSString *)departmentCode
{
    NSString *string = [self.departmentField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [self industryToCode:string];
    return string;
}

- (void)resetView
{
    self.authScrollView.alpha = [self.state isEqualToString:@"0"] ? 1.0f : 0.0f;
    self.authTipLabel.hidden = YES;
    if ([self.state isEqualToString:@"0"]) {
        self.stateLabel.text = @"未认证";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"f04241"];
        [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    }else if ([self.state isEqualToString:@"1"]){
        self.stateLabel.text = @"审核中";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"f04241"];
        [self.submitButton setTitle:@"更新" forState:UIControlStateNormal];
        self.submitButton.hidden = YES;
        self.authTipLabel.hidden = NO;
        self.authTipLabel.textAlignment = NSTextAlignmentCenter;
        self.authTipLabel.text = @"大牛正在认证您的用户信息，我们将在一个工作日内通知您认证结果！感谢您对大牛圈的支持！";
    }else if ([self.state isEqualToString:@"2"]){
        self.stateLabel.text = @"已认证";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"3588c8"];
        [self.submitButton setTitle:@"更新" forState:UIControlStateNormal];
    }else if ([self.state isEqualToString:@"3"]){
        self.stateLabel.text = @"认证失败";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"f04241"];
        [self.submitButton setTitle:@"更新" forState:UIControlStateNormal];
        self.authTipLabel.hidden = NO;
        self.authTipLabel.textAlignment = NSTextAlignmentLeft;
        NSString *string = [@"驳回原因：\n" stringByAppendingFormat:@"%@", self.rejectReason];
        NSMutableAttributedString *reason = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:FontFactor(13.0f), NSForegroundColorAttributeName:Color(@"999999")}];
        [reason addAttributes:@{NSForegroundColorAttributeName:Color(@"dc4437")} range:[string rangeOfString:@"驳回原因："]];
        self.authTipLabel.attributedText = reason;
    }
    [self.stateLabel updateLayout];
    __weak typeof(self) weakSelf = self;
    if (!IsStrEmpty(self.authImageUrl)) {
        [self.authImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.authImageUrl]] placeholder:[UIImage imageNamed:@"default_head"] options:kNilOptions completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            weakSelf.authImage = image;
            [weakSelf.plusButton setImage:image forState:UIControlStateNormal];
        }];
    }
}

- (void)loadUserState
{
    __weak typeof(self)weakSelf = self;
    [Hud showWait];
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"myidentity"] parameters:@{@"uid":UID}success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        weakSelf.state = [response.dataDictionary valueForKey:@"state"];
        weakSelf.authImageUrl = [response.dataDictionary valueForKey:@"potname"];
        weakSelf.rejectReason = [response.dataDictionary valueForKey:@"reason"];
        [weakSelf loadUserInfo];
        [weakSelf resetView];

    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"获取身份信息失败"];
    }];
}

- (void)loadUserInfo
{
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"personaluser"] parameters:@{@"uid":UID} success:^(MOCHTTPResponse *response) {
        weakSelf.company = [response.dataDictionary objectForKey:@"companyname"];
        if ([[response.dataDictionary objectForKey:@"position"] length] > 0) {
             weakSelf.locationField.text = [response.dataDictionary objectForKey:@"position"];
        } else{
            [[CCLocationManager shareLocation] getCity:^{
                NSString * cityName = [SHGGloble sharedGloble].cityName;
                weakSelf.locationField.text = cityName;
            }];
        }
       
        weakSelf.departmentField.text = [self codeToIndustry:[response.dataDictionary objectForKey:@"industrycode"]];
        NSString *head_img = [response.dataDictionary objectForKey:@"head_img"];

        [weakSelf.headerButton yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,head_img]] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"uploadHead"] options:kNilOptions completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            weakSelf.headerImage = image;
        }];
    }failed:^(MOCHTTPResponse *response) {
        
    }];
}

- (IBAction)headerButtonClicked:(UIButton *)sender
{
    self.currentButton = sender;
    UIActionSheet *takeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选图", nil];
    [takeSheet showInView:self.view];
}

- (IBAction)plusButtonClicked:(UIButton *)sender
{
    self.currentButton = sender;
    UIActionSheet *takeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选图", nil];
    [takeSheet showInView:self.view];
}

- (IBAction)submitButtonClicked:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"更新"]) {
        [UIView animateWithDuration:0.25f animations:^{
            self.authScrollView.alpha = 1.0f;
        }];
        [sender setTitle:@"提交" forState:UIControlStateNormal];
    } else {
        if ([self checkInputMessage]) {
            [self uploadHeaderImage];
        }
    }
}

- (BOOL)checkInputMessage
{
    NSString *string = [self.locationField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (string.length == 0) {
        [Hud showMessageWithText:@"请输入地理位置信息"];
        return NO;
    }
    string = [self.departmentField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (string.length == 0) {
        [Hud showMessageWithText:@"请输入行业信息"];
        return NO;
    }
    if (!self.authImage) {
        [Hud showMessageWithText:@"请上传您的名片"];
        return NO;
    }
    return YES;
}

- (void)uploadHeaderImage
{
    //头像需要压缩 跟其他的上传图片接口不一样了
    [Hud showWait];
    if (self.headerImage) {
        __weak typeof(self) weakSelf = self;
        [MOCHTTPRequestOperationManager POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/basephoto"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *imageData = UIImageJPEGRepresentation(weakSelf.headerImage, 0.1);
            [formData appendPartWithFileData:imageData name:@"hahaggg.jpg" fileName:@"hahaggg.jpg" mimeType:@"image/jpeg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            NSDictionary *dic = [(NSString *)[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
            NSString *newHeadImageName = [(NSArray *)[dic valueForKey:@"pname"] objectAtIndex:0];
            [[NSUserDefaults standardUserDefaults] setObject:newHeadImageName forKey:KEY_HEAD_IMAGE];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_SENDPOST object:nil];

            [weakSelf putHeadImage:newHeadImageName];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [Hud hideHud];
            [Hud showMessageWithText:@"上传图片失败"];
        }];
    } else {
        [self uploadAuthImage];
    }
}


//更新服务器端
- (void)putHeadImage:(NSString *)headImageName
{
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager putWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"modifyuser"] class:nil parameters:@{@"uid":UID, @"type":@"headimage", @"value":headImageName, @"title":self.departmentCode, @"company":self.company} success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            [Hud hideHud];
            [weakSelf uploadAuthImage];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
    }];
}

- (void)uploadAuthImage
{
    [Hud showWait];
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/basephoto"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(weakSelf.authImage, 0.1);
        [formData appendPartWithFileData:imageData name:@"haha.jpg" fileName:@"haha.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = [(NSString *)[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
        weakSelf.authImageUrl = [(NSArray *)[dic valueForKey:@"pname"] objectAtIndex:0];
        [weakSelf submitMaterial];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error);
        [Hud hideHud];
        [Hud showMessageWithText:@"上传认证图片失败"];
    }];
}

- (void)submitMaterial
{
    __weak typeof(self)weakSelf = self;
    [MOCHTTPRequestOperationManager putWithURL:[rBaseAddressForHttp stringByAppendingString:@"/user/identityAuth"]class:nil parameters:@{@"uid":UID, @"potname":self.authImageUrl, @"industrycode": self.departmentCode, @"area":self.locationField.text} success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            [Hud hideHud];
            [Hud showMessageWithText:@"提交成功，我们将在一个工作日内\n通知您认证结果"];
            [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.20f];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
    }];
}


- (void)showIndustryChoiceView
{
    SHGIndustrySelectView *view = [[SHGIndustrySelectView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT) andSelctIndustry:self.departmentField.text];
    WEAK(self, weakSelf);
    view.returnTextBlock = ^(NSString *string){
        weakSelf.departmentField.text = string;
    };
    view.alpha = 0.0f;
    [weakSelf.view.window addSubview:view];
    [UIView animateWithDuration:0.25f animations:^{
        view.alpha = 1.0f;
    }];
}

- (void)showLocationChoiceView
{
    SHGProvincesViewController *controller = [[SHGProvincesViewController alloc] initWithNibName:@"SHGProvincesViewController" bundle:nil];
    if(controller){
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
}


- (NSString *)industryToCode:(NSString *)industry
{
    if ([industry isEqualToString:@"银行机构"]) {
        return  @"bank";
    } else if ([industry isEqualToString:@"证券公司"]) {
        return @"bond";
    } else if ([industry isEqualToString:@"PE/VC"]) {
        return  @"pevc";
    } else if ([industry isEqualToString:@"债权机构"]) {
        return @"bondAgency";
    } else if ([industry isEqualToString:@"公募基金"]) {
        return @"fund";
    } else if ([industry isEqualToString:@"信托公司"]) {
        return @"entrust";
    } else if ([industry isEqualToString:@"三方理财"]) {
        return @"manage";
    } else if ([industry isEqualToString:@"担保小贷"]) {
        return @"bonding";
    } else if ([industry isEqualToString:@"上市公司"]) {
        return @"public";
    } else if ([industry isEqualToString:@"融资企业"]) {
        return @"financingEnterprise";
    } else if ([industry isEqualToString:@"其他"]) {
        return @"other";
    }

    return nil;
}

- (NSString *)codeToIndustry:(NSString *)code
{
    if ([code isEqualToString:@"bank"]) {
        return  @"银行机构";
    } else if ([code isEqualToString:@"bond"]) {
        return @"证券公司";
    } else if ([code isEqualToString:@"pevc"]) {
        return  @"PE/VC";
    } else if ([code isEqualToString:@"bondAgency"]) {
        return @"债权机构";
    } else if ([code isEqualToString:@"fund"]) {
        return @"公募基金";
    } else if ([code isEqualToString:@"entrust"]) {
        return @"信托公司";
    } else if ([code isEqualToString:@"manage"]) {
        return @"三方理财";
    } else if ([code isEqualToString:@"bonding"]) {
        return @"担保小贷";
    } else if ([code isEqualToString:@"public"]) {
        return @"上市公司";
    } else if ([code isEqualToString:@"financingEnterprise"]) {
        return @"融资企业";
    } else if ([code isEqualToString:@"other"]) {
        return @"其他";
    }

    return nil;
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

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        [self.navigationController presentViewController:pickerImage animated:YES completion:nil];
    }
}

#pragma mark ------actionSheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"拍照");
        [self cameraClick];
    }  else if (buttonIndex == 1) {
        NSLog(@"选图");
        [self photosClick];
    } else if (buttonIndex == 2){
        NSLog(@"取消");
    }
}


#pragma mark ------textfield代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.locationField]) {
        [self showLocationChoiceView];
    } else {
        [self showIndustryChoiceView];
    }
    return NO;
}

#pragma mark ------ 选择城市代理
- (void)didSelectCity:(NSString *)city
{
    self.locationField.text = city;
}

#pragma mark ------选图代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self.currentButton setImage:image forState:UIControlStateNormal];
    if ([self.currentButton isEqual:self.plusButton]) {
        self.authImage = image;
    } else {
        self.headerImage = image;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
