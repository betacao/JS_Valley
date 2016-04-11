//
//  SHGAuthenticationViewController.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/17.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGAuthenticationViewController.h"
#import "UIButton+WebCache.h"
#import "SHGItemChooseView.h"

@interface SHGAuthenticationViewController ()<UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SHGItemChooseDelegate>
//
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *stateNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authTipView;
@property (weak, nonatomic) IBOutlet UIImageView *authImageView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
//
@property (weak, nonatomic) IBOutlet UIScrollView *authScrollView;
@property (weak, nonatomic) IBOutlet UITextField *departmentField;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UIView *roundCornerView;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) UIButton *currentButton;
//
@property (strong, nonatomic) NSString *state;//认证状态
@property (strong, nonatomic) NSString *authImage;//认证的图片
@property (strong, nonatomic) NSString *departmentCode;
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
    self.authImageView.layer.borderWidth = 0.5f;
    //
    self.authScrollView.backgroundColor = Color(@"f7f8f9");
    self.departmentField.textColor = self.locationField.textColor = Color(@"161616");
    self.departmentField.font = self.locationField.font = FontFactor(15.0f);
    self.departmentField.layer.borderColor = self.locationField.layer.borderColor = [UIColor lightGrayColor].CGColor;

    self.departmentField.layer.borderWidth = self.locationField.layer.borderWidth = 0.5f;
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

    //
    self.headerButton.sd_layout
    .topSpaceToView(self.authScrollView, MarginFactor(58.0f))
    .centerXEqualToView(self.authScrollView)
    .widthIs(self.headerButton.currentImage.size.width)
    .heightIs(self.headerButton.currentImage.size.height);

    self.departmentField.sd_layout
    .topSpaceToView(self.headerButton, MarginFactor(58.0f))
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

- (void)resetView
{
    self.authScrollView.alpha = [self.state isEqualToString:@"0"] ? 1.0f : 0.0f;
    if ([self.state isEqualToString:@"0"]) {
        self.stateLabel.text = @"未认证";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"f04241"];
        [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    }else if ([self.state isEqualToString:@"1"]){
        self.stateLabel.text = @"审核中";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"f04241"];
        [self.submitButton setTitle:@"更新" forState:UIControlStateNormal];
        self.submitButton.hidden = YES;
    }else if ([self.state isEqualToString:@"2"]){
        self.stateLabel.text = @"已认证";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"3588c8"];
        [self.submitButton setTitle:@"更新" forState:UIControlStateNormal];
    }else if ([self.state isEqualToString:@"3"]){
        self.stateLabel.text = @"认证失败";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"f04241"];
        [self.submitButton setTitle:@"更新" forState:UIControlStateNormal];

    }
    [self.stateLabel updateLayout];
    if (!IsStrEmpty(self.authImage)) {
        [self.authImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.authImage]] placeholderImage:[UIImage imageNamed:@"default_head"]];
    }
}

- (void)loadUserState
{
    __weak typeof(self)weakSelf = self;
    [Hud showWait];
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"myidentity"] parameters:@{@"uid":UID}success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        weakSelf.state = [response.dataDictionary valueForKey:@"state"];
        weakSelf.authImage = [response.dataDictionary valueForKey:@"potname"];
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
        weakSelf.locationField.text = [response.dataDictionary objectForKey:@"position"];
        weakSelf.departmentField.text = [self codeToIndustry:[response.dataDictionary objectForKey:@"industrycode"]];
        NSString *head_img = [response.dataDictionary objectForKey:@"head_img"];
        [weakSelf.headerButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,head_img]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head"]];
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
    return YES;
}

- (void)uploadHeaderImage
{

}

- (void)uploadAuthImage
{

}

- (void)submitMaterial
{

}


- (void)showIndustryChoiceView
{
    SHGItemChooseView *view = [[SHGItemChooseView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT) lineNumber:9];
    view.delegate = self;
    view.dataArray = @[@"银行机构", @"证券公司", @"PE/VC",@"公募基金",@"信托公司",@"三方理财", @"担保小贷", @"上市公司", @"其他"];
    [self.view.window addSubview:view];
}


- (NSString *)industryToCode:(NSString *)industry
{
    if ([industry isEqualToString:@"银行机构"]) {
        return  @"bank";
    } else if ([industry isEqualToString:@"证券公司"]) {
        return @"bond";
    } else if ([industry isEqualToString:@"PE/VC"]) {
        return  @"pevc";
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
    }
    pickerImage.delegate = self;
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
    [self.navigationController presentViewController:pickerImage animated:YES completion:nil];
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
    } else {
        [self showIndustryChoiceView];
    }
    return NO;
}

#pragma mark ------ 选择行业代理
- (void)didSelectItem:(NSString *)item
{
    self.departmentField.text = item;
    self.departmentCode = [self industryToCode:item];

}

#pragma mark ------选图代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.currentButton setImage:image forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
