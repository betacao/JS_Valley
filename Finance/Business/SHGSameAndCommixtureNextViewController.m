//
//  SHGSameAndCommixtureNextViewController.m
//  Finance
//
//  Created by weiqiankun on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGSameAndCommixtureNextViewController.h"
#import "EMTextView.h"
#import "SHGBusinessMargin.h"
#import "UIButton+EnlargeEdge.h"
#import "SHGBusinessManager.h"
#import "SHGBusinessListViewController.h"
#import "SHGBusinessSendSuccessViewController.h"
@interface SHGSameAndCommixtureNextViewController ()<UIScrollViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
//业务说明
@property (strong, nonatomic) IBOutlet UIView *marketExplainView;
@property (weak, nonatomic) IBOutlet UILabel *marketExplainTitleLabel;
@property (weak, nonatomic) IBOutlet EMTextView *marketExplainTextView;
@property (weak, nonatomic) IBOutlet UIImageView *marketExplainSelectImage;

//添加图片
@property (strong, nonatomic) IBOutlet UIView *addImageView;
@property (weak, nonatomic) IBOutlet UILabel *addImageTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;

@property (strong, nonatomic) IBOutlet UIButton *authorizeButton;
@property (strong, nonatomic) id currentContext;
@property (assign, nonatomic) CGFloat keyBoardOrginY;

@property (assign, nonatomic) BOOL hasImage;
@property (strong, nonatomic) NSString *imageName;
@property (nonatomic, strong) SHGBusinessObject *obj;
@end

@implementation SHGSameAndCommixtureNextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapAction:)];
    [self.scrollView addGestureRecognizer:tap];
    if (((SHGSameAndCommixtureSendViewController *)self.superController).object) {
        self.title = @"修改同业混业";
        ((SHGSameAndCommixtureSendViewController *)self.superController).sendType = 1;
        self.obj = ((SHGSameAndCommixtureSendViewController *)self.superController).object;
    } else{
        self.title = @"发布同业混业";
        ((SHGSameAndCommixtureSendViewController *)self.superController).sendType = 0;
    }
    self.scrollView.delegate = self;
    self.marketExplainTextView.delegate = self;
    [self.scrollView addSubview:self.marketExplainView];
    [self.scrollView addSubview:self.addImageView];
    [self.scrollView addSubview:self.authorizeButton];
    [self addSdLayout];
    [self initView];


}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeText:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)addSdLayout
{
    self.scrollView.sd_layout
    .topSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, MarginFactor(50.0f));
    
    self.sureButton.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(50.0f));
    //业务说明
    
    self.marketExplainView.sd_layout
    .topSpaceToView(self.scrollView, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.marketExplainTitleLabel.sd_layout
    .topSpaceToView(self.marketExplainView, ktopToView)
    .leftSpaceToView(self.marketExplainView, kLeftToView)
    .heightIs(ceilf(self.marketExplainTitleLabel.font.lineHeight));
    [self.marketExplainTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    UIImage *image = [UIImage imageNamed:@"biXuan"];
    CGSize size = image.size;
    
    self.marketExplainSelectImage.sd_layout
    .leftSpaceToView(self.marketExplainTitleLabel, kLeftToView)
    .centerYEqualToView(self.marketExplainTitleLabel)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.marketExplainTextView.sd_layout
    .leftEqualToView(self.marketExplainTitleLabel)
    .topSpaceToView(self.marketExplainTitleLabel,ktopToView)
    .rightSpaceToView(self.marketExplainView, kLeftToView)
    .heightIs(MarginFactor(144.0f));
    
    [self.marketExplainView setupAutoHeightWithBottomView:self.marketExplainTextView bottomMargin:ktopToView];
    //添加图片
    UIImage *addImage = [UIImage imageNamed:@"circle_plus"];
    CGSize addSize = addImage.size;
    
    self.addImageView.sd_layout
    .topSpaceToView(self.marketExplainView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.addImageTitleLabel.sd_layout
    .topSpaceToView(self.addImageView, ktopToView)
    .leftSpaceToView(self.addImageView, kLeftToView)
    .heightIs(ceilf(self.addImageTitleLabel.font.lineHeight));
    [self.addImageTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.addImageButton.sd_layout
    .leftEqualToView(self.addImageTitleLabel)
    .topSpaceToView(self.addImageTitleLabel, ktopToView)
    .widthIs(addSize.width)
    .heightIs(addSize.height);
    
    [self.addImageView setupAutoHeightWithBottomView:self.addImageButton bottomMargin:ktopToView];
    
    self.authorizeButton.sd_layout
    .topSpaceToView(self.addImageView, MarginFactor(20.0f))
    .leftSpaceToView(self.scrollView, kLeftToView)
    .rightSpaceToView(self.scrollView, kLeftToView)
    .heightRatioToView(self.addImageTitleLabel, 1.0f);
    
    //CGFloat y = self.scrollView.size.height - self.marketExplainView.size.height -self.addImageView.height - self.authorizeButton.size.height  + MarginFactor(55.0f);
    [self.scrollView setupAutoContentSizeWithBottomView:self.authorizeButton bottomMargin:MarginFactor(200.0f)];

    
}


- (void)initView
{
    if (((SHGSameAndCommixtureSendViewController *)self.superController).sendType == 1)
    {
        [self.sureButton setTitle:@"完成" forState:UIControlStateNormal];
        self.marketExplainTextView.text = self.obj.detail;
        if ([self.obj.anonymous isEqualToString:@"1"]) {
            self.authorizeButton.selected = YES;
        } else{
            self.authorizeButton.selected = NO;
        }
        
        if (self.obj.url && self.obj.url.length > 0) {
            self.hasImage = YES;
            __weak typeof(self) weakSelf = self;
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.obj.url]] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [weakSelf.addImageButton setImage:image forState:UIControlStateNormal];
           }];
       }

   }
    self.sureButton.titleLabel.font = FontFactor(19.0f);
    [self.sureButton setTitleColor:Color(@"ffffff") forState:UIControlStateNormal];
    [self.sureButton setBackgroundColor:Color(@"f04241")];
    self.marketExplainTitleLabel.textColor = Color(@"161616");
    self.marketExplainTitleLabel.font = FontFactor(13.0f);
    
    self.addImageTitleLabel.textColor = Color(@"161616");
    self.addImageTitleLabel.font = FontFactor(13.0f);
    self.marketExplainTextView.font = FontFactor(15.0f);
    self.marketExplainTextView.textColor = Color(@"161616");
    self.marketExplainTextView.placeholder = @" 请描述您的业务详情或将您的业务信息拍照上传";
    self.marketExplainTextView.placeholderColor = Color(@"bebebe");
    
    self.authorizeButton.backgroundColor = [UIColor clearColor];
    self.authorizeButton.titleLabel.font = FontFactor(14.0f);
    [self.authorizeButton setTitleColor:Color(@"8b8b8b") forState:UIControlStateNormal];
    [self.authorizeButton setImage:[UIImage imageNamed:@"business_authorizeUnselect"] forState:UIControlStateNormal];
    [self.authorizeButton setImage:[UIImage imageNamed:@"business_authorizeSelect"] forState:UIControlStateSelected];
    [self.authorizeButton setEnlargeEdgeWithTop:10.0f right:10.0f bottom:10.0f left:10.0f];
}

- (IBAction)authorizeButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
}


- (IBAction)sureButtonClick:(UIButton *)sender
{
 
    if ([self checkInputMessage]) {
        __weak typeof(self) weakSelf = self;
           NSDictionary *businessDic = ((SHGSameAndCommixtureSendViewController *)weakSelf.superController).firstDic;
        [self uploadImage:^(BOOL success) {
            if (success) {
                switch (((SHGSameAndCommixtureSendViewController *)weakSelf.superController).sendType) {
                    case 0:{
                        
                        NSString *anonymous = weakSelf.authorizeButton.isSelected ? @"1" : @"0";
                        
                        NSString *type = [businessDic objectForKey:@"type"];
                        NSString *contact = [businessDic objectForKey:@"contact"];
                        NSString *businessType = [businessDic objectForKey:@"businessType"];
                        NSString *investAmount = [businessDic objectForKey:@"investAmount"];
                        NSString *area = [businessDic objectForKey:@"area"];
                        NSString *title = [businessDic objectForKey:@"title"];
                        SHGBusinessObject *object = [[SHGBusinessObject alloc] init];
                        object.type = type;

                        NSDictionary *param = @{@"uid":UID,@"type": type, @"contact":contact, @"businessType":businessType, @"investAmount": investAmount, @"area": area, @"detail": weakSelf.marketExplainTextView.text,@"photo": weakSelf.imageName,@"anonymous": anonymous,@"title": title};
                        NSLog(@"%@",param);
                        NSLog(@"%@",weakSelf.marketExplainTextView.text);
                        [SHGBusinessManager createNewBusiness:param success:^(BOOL success , NSString *bussinessId) {
                            if (success) {
                                object.businessID = bussinessId;
                                object.businessTitle = title;
                                SHGBusinessSendSuccessViewController *viewController = [[SHGBusinessSendSuccessViewController alloc] init];
                                viewController.object = object;
                                [weakSelf.navigationController pushViewController:viewController animated:YES];
                            }
                        }];
                    }  break;
                        
                    case 1:{
                        NSString *anonymous = weakSelf.authorizeButton.isSelected ? @"1" : @"0";
                        NSString *businessId = self.obj.businessID;
                        NSString *type = [businessDic objectForKey:@"type"];
                        NSString *contact = [businessDic objectForKey:@"contact"];
                        NSString *businessType = [businessDic objectForKey:@"businessType"];
                        NSString *investAmount = [businessDic objectForKey:@"investAmount"];
                        NSString *area = [businessDic objectForKey:@"area"];
                        NSString *title = [businessDic objectForKey:@"title"];

                        SHGBusinessObject *object = [[SHGBusinessObject alloc] init];
                        object.type = type;
                        NSDictionary *param = @{@"uid":UID,@"businessId":businessId, @"type": type, @"contact":contact, @"businessType":businessType, @"investAmount": investAmount, @"area": area, @"detail": weakSelf.marketExplainTextView.text,@"photo": weakSelf.imageName,@"anonymous": anonymous,@"title": title};
                        NSLog(@"%@",param);
                        [SHGBusinessManager editBusiness:param success:^(BOOL success) {
                            if (success) {
                                [[SHGBusinessListViewController sharedController] didCreateOrModifyBusiness:object];
                                [weakSelf.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:@(YES) afterDelay:1.2f];
                            }
                        }];
                        
                        
                    }  break;
                    default:
                        break;
                }
   
            }
        }];
        
        
    }
}

- (void)uploadImage:(void(^)(BOOL success))block
{
    [Hud showWait];
    if (self.hasImage) {
        __weak typeof(self) weakSelf = self;
        [MOCHTTPRequestOperationManager POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/uploadPhotoCompress"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSData *imageData = UIImageJPEGRepresentation(self.addImageButton.imageView.image, 0.1);
            [formData appendPartWithFileData:imageData name:@"market.jpg" fileName:@"market.jpg" mimeType:@"image/jpeg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            [Hud hideHud];
            NSDictionary *dic = [(NSString *)[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
            weakSelf.imageName = [(NSArray *)[dic valueForKey:@"pname"] objectAtIndex:0];
            block(YES);
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            NSLog(@"%@",error);
            [Hud hideHud];
            [Hud showMessageWithText:@"上传图片失败"];
        }];
    } else{
        self.imageName = @"";
        block(YES);
    }
    
}

- (BOOL)checkInputMessage
{
    if (self.marketExplainTextView.text.length == 0) {
        [Hud showMessageWithText:@"请填写业务说明"];
        return NO;
    }
    return YES;
}

- (IBAction)addNewImage:(id)sender
{
    [self.currentContext resignFirstResponder];
    if (!self.hasImage) {
        UIActionSheet *takeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"选图", nil];
        [takeSheet showInView:self.view];
    } else{
        UIActionSheet *takeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
        [takeSheet showInView:self.view];
    }
}
#pragma mark ------actionSheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"拍照"]) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            pickerImage.delegate = self;
            pickerImage.allowsEditing = YES;
            [self presentViewController:pickerImage animated:YES completion:nil];
        }
    } else if ([title isEqualToString:@"选图"]){
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            pickerImage.delegate = self;
            pickerImage.allowsEditing = YES;
            [self presentViewController:pickerImage animated:YES completion:nil];
        }
    } else if ([title isEqualToString:@"删除"]){
        self.hasImage = NO;
        [self.addImageButton setImage:[UIImage imageNamed:@"circle_plus"] forState:UIControlStateNormal];
    }
}

#pragma mark ------pickviewcontroller代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.addImageButton setImage:image forState:UIControlStateNormal];
    self.hasImage = YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.currentContext = textView;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.currentContext resignFirstResponder];
}

- (void)keyBoardDidShow:(NSNotification *)notificaiton
{
    NSDictionary *info = [notificaiton userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    UIView *view = (UIView *)self.currentContext;
    CGPoint point = CGPointMake(0.0f, CGRectGetMidY(view.frame));
    point = [view.superview convertPoint:point toView:self.scrollView];
    point.y = MAX(0.0f, keyboardSize.height + point.y - CGRectGetHeight(self.view.frame));
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.scrollView setContentOffset:point animated:YES];
        
    });
}

- (void)textViewDidChangeText:(NSNotification *)notification
{
    UITextView *textView = notification.object;
    if ([textView isEqual:self.marketExplainTextView]) {
        if (textView.text.length > 600) {
            textView.text = [textView.text substringToIndex:600];
        }
    }
}

-(void)scrollerTapAction:(UITapGestureRecognizer *)ges
{
    [self.currentContext resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
