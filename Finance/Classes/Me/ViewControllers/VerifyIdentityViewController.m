//
//  VerifyIdentityViewController.m
//  Finance
//
//  Created by Okay Hoo on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "VerifyIdentityViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface VerifyIdentityViewController ()
 <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UITableViewCell *statusCell;
@property (nonatomic, strong) NSString *status;
@property (weak, nonatomic) IBOutlet UILabel *status_statuLabel;

@property (nonatomic, strong) IBOutlet UITableViewCell *industryCell;
@property (nonatomic, strong) NSString *industryName;
@property (nonatomic, strong) NSString *industryCode;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UITableViewCell *identifyCell;
@property (nonatomic, strong) NSString *identifyImageName;
@property (nonatomic, strong) UIImage  *identifyImage;
@property (nonatomic, strong) IBOutlet UIImageView *identifyImageView;
- (void)selectIdentifyImageViewTapped;

@property (nonatomic, strong) IBOutlet UILabel *tipsLabel;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
- (IBAction)submitButtonClicked:(id)sender;

@property (nonatomic, assign) BOOL isWantToChange;

@property (nonatomic, strong) IBOutlet UIImageView *noImageView;
@property (nonatomic, strong) IBOutlet UILabel	   *noImageLabel;
@property (nonatomic, assign) BOOL	isSelectImage;
@end

@implementation VerifyIdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title  = @"身份认证";
	self.isWantToChange = NO;
	self.isSelectImage = NO;
    self.view.backgroundColor= [UIColor whiteColor];
    
    self.identifyImageView.layer.cornerRadius = 5;
    self.identifyImageView.layer.masksToBounds = YES;
    //自适应图片宽高比例
    self.identifyImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.identifyImageView.clipsToBounds = YES;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"认证可获实时业务资讯及优质人脉关注"];
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"3588c8"] range:NSMakeRange(0, 4)];
    [self.titleLabel setAttributedText:noteStr];
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"3588c8"] range:NSMakeRange(10,1)];
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"f8514b"] range:NSMakeRange(4, 6)];
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"f8514b"] range:NSMakeRange(11, 6)];
    [self.titleLabel setAttributedText:noteStr];
    [self.titleLabel setAttributedText:noteStr];
    self.titleLabel.attributedText = noteStr;
    
	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
	[MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"myidentity"] parameters:@{@"uid":uid}success:^(MOCHTTPResponse *response) {
		
		self.status = [response.dataDictionary valueForKey:@"state"];
		self.identifyImageName = [response.dataDictionary valueForKey:@"potname"];
		[self resetView];
		NSLog(@"%@",response.data);
		NSLog(@"%@",response.errorMessage);
		
	} failed:^(MOCHTTPResponse *response) {
	}];
    self.identifyImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress)];
    [self.identifyImageView addGestureRecognizer:singleTap1];
    
    //[myScrollView addSubview:self.identifyImageView];

}
-(void)buttonpress
{
    [self selectIdentifyImageViewTapped];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"VerifyIdentityViewController" label:@"onClick"];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	// 输出点击的view的类名
	NSLog(@"%@", NSStringFromClass([touch.view class]));
	
	// 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
	if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
		return NO;
	}
	return  YES;
}
- (void)resetView
{
	self.noImageLabel.hidden = YES;
	self.noImageView.hidden = YES;
	self.identifyImageView.hidden = NO;
	if ([self.status isEqualToString:@"0"]) {
		self.status_statuLabel.text = @"未认证";
		
		[self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
		[self.submitButton setTitle:@"提交" forState:UIControlStateHighlighted];
		self.tipsLabel.hidden = YES;
		if (!self.isSelectImage) {
			self.noImageLabel.hidden = NO;
			self.noImageView.hidden = NO;
//			self.identifyImageView.hidden = YES;
		}
	}else if ([self.status isEqualToString:@"1"]){
		self.status_statuLabel.text = @"审核中";
		[self.submitButton setTitle:@"更新" forState:UIControlStateNormal];
		[self.submitButton setTitle:@"更新" forState:UIControlStateHighlighted];
		self.submitButton.hidden = YES;
		self.tipsLabel.hidden = NO;
	}else if ([self.status isEqualToString:@"2"]){
		self.status_statuLabel.text = @"已认证";
		
		if (self.isWantToChange) {
//            self.submitButton.hidden = YES;
			[self.submitButton setTitle:@"更新" forState:UIControlStateNormal];
			[self.submitButton setTitle:@"更新" forState:UIControlStateHighlighted];
			if (!self.isSelectImage) {
				self.noImageLabel.hidden = NO;
				self.noImageView.hidden = NO;
			}
		}else{
			[self.submitButton setTitle:@"更新" forState:UIControlStateNormal];
			[self.submitButton setTitle:@"更新" forState:UIControlStateHighlighted];
		}
		
		self.tipsLabel.hidden = YES;
	}else if ([self.status isEqualToString:@"3"]){
		self.status_statuLabel.text = @"审核被拒";

		if (self.isWantToChange) {
			[self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
			[self.submitButton setTitle:@"提交" forState:UIControlStateHighlighted];
			if (!self.isSelectImage) {
				self.noImageLabel.hidden = NO;
				self.noImageView.hidden = NO;
			}
		}else{
			[self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
			[self.submitButton setTitle:@"提交" forState:UIControlStateHighlighted];
		}

	}
	if (IsStrEmpty(self.identifyImageName)) {
		
	}else{
			[self.identifyImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.identifyImageName]] placeholderImage:[UIImage imageNamed:@"default_head"]];
	}
}

- (IBAction)submitButtonClicked:(id)sender
{
	if ([self.status isEqualToString:@"0"]) {
		
	}else if ([self.status isEqualToString:@"1"]){
		return;
	}else if ([self.status isEqualToString:@"2"]){
		if (self.isWantToChange == NO) {
			self.isWantToChange = YES;
			self.identifyImageName = @"";
			[self.identifyImageView setImage:nil];
			[self resetView];
			return;
		}else{
			
		}
	}else if ([self.status isEqualToString:@"3"]){
		if (self.isWantToChange == NO) {
			self.isWantToChange = YES;
			self.identifyImageName = @"";
			[self.identifyImageView setImage:nil];
			[self resetView];
			return;
		}else{
			
		}
	}
	if (self.identifyImage) {
		[Hud showLoadingWithMessage:@"正在上传图片..."];
		[[AFHTTPRequestOperationManager manager] POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/base"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
			NSData *imageData = UIImageJPEGRepresentation(self.identifyImage, 0.1);
			[formData appendPartWithFileData:imageData name:@"haha.jpg" fileName:@"haha.jpg" mimeType:@"image/jpeg"];
		} success:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSLog(@"%@",responseObject);
			
			NSDictionary *dic = [(NSString *)[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
			
			self.identifyImageName = [(NSArray *)[dic valueForKey:@"pname"] objectAtIndex:0];
			
			[Hud hideHud];
			[self submitMaterial];
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"%@",error);
			[Hud hideHud];
			[Hud showMessageWithText:@"上传图片失败"];

		}];

	}else{
		[Hud showMessageWithText:@"请选择图片"];
	}
}

- (void)submitMaterial
{
	[Hud showLoadingWithMessage:@"正在上传资料..."];
	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
	[[AFHTTPRequestOperationManager manager] PUT:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"identity"] parameters:@{@"uid":uid,@"potname":self.identifyImageName} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"%@",operation);
		NSLog(@"%@",responseObject);
		NSString *code = [responseObject valueForKey:@"code"];
		if ([code isEqualToString:@"000"]) {
			[Hud hideHud];
			[Hud showMessageWithText:@"上传成功"];
            
            [self performSelector:@selector(popBack) withObject:nil afterDelay:1.0];
		}
		
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[Hud hideHud];
		[Hud showMessageWithText:@"上传资料失败"];

	}];

}

-(void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectIdentifyImageViewTapped
{
	if ([self.status isEqualToString:@"3"]&&!self.isWantToChange) {
		return;
	}

	if ([self.status isEqualToString:@"2"]&&!self.isWantToChange) {
		return;
	}
	
	if ( [self.status isEqualToString:@"1"]) {
		return;
	}

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
	[self presentViewController:pickerImage animated:YES completion:nil];
}

-(void)photosClick
{
	UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
	
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
	}
	pickerImage.delegate = self;
	[self.navigationController presentViewController:pickerImage animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	self.identifyImage = info[UIImagePickerControllerOriginalImage];
	[self.identifyImageView setImage:self.identifyImage];
	self.isSelectImage = YES;
	[self resetView];
	[picker dismissViewControllerAnimated:YES completion:nil];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (tableView == self.tableView) {
		return 3;
	}
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.tableView) {
		return 1;
	}
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (tableView == self.tableView)
	{
		if (section == 0) {
			return 0;
		}if (section == 1) {
			return 15;
		}else{
			return 0;
		}
	}
	
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{	if (tableView == self.tableView) {
	return 0.01;
}
	
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.tableView) {
		if (indexPath.section == 0) {
			return 55;
		}else if(indexPath.section == 1){
			return 90;
		}else if (indexPath.section == 2){
			return 410;
		}
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.tableView) {
		if (indexPath.section == 0) {
			return self.statusCell;
		}else if(indexPath.section == 1){
			return self.industryCell;
		}else if(indexPath.section == 2){
			return self.identifyCell;
		}
	}
	UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty"];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if (tableView == self.tableView) {
		if (indexPath.section == 0) {
			
		}else if(indexPath.section == 1){
			
		}else if(indexPath.section == 2){
		}
    }
	
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

@end
