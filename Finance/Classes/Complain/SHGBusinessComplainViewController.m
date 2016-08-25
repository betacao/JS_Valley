//
//  SHGBusinessComplainViewController.m
//  Finance
//
//  Created by weiqiankun on 16/8/8.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessComplainViewController.h"
#import "CPTextViewPlaceholder.h"
#import "TWEmojiKeyBoard.h"
#import "ZYQAssetPickerController.h"
#import "SHGCircleSendViewController.h"

#define kTextViewMinHeight MarginFactor(82.0f)
#define kImageViewWidth MarginFactor(105.0f)
#define kImageViewHeight MarginFactor(105.0f)
#define kImageViewLeftMargin MarginFactor(12.0f)
#define kImageViewMargin MarginFactor(18.0f)
@interface SHGBusinessComplainViewController ()<UITextViewDelegate, UIActionSheetDelegate, ZYQAssetPickerControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet CPTextViewPlaceholder *textView;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (assign, nonatomic) BOOL isEmoji;
@property (strong, nonatomic) TWEmojiKeyBoard *emojiKeyBoard;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *bottom_emoji;
@property (weak, nonatomic) IBOutlet UIButton *bottom_url;
@property (weak, nonatomic) IBOutlet UIView *bottomLine1;
@property (weak, nonatomic) IBOutlet UIView *bottomLine2;


@property (strong, nonatomic) IBOutlet UIView *inputAccessoryView;
@property (weak, nonatomic) IBOutlet UIButton *accessory_emoji;
@property (weak, nonatomic) IBOutlet UIButton *accessory_url;
@property (weak, nonatomic) IBOutlet UIView *accessoryLine1;
@property (weak, nonatomic) IBOutlet UIView *accessoryLine2;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (weak, nonatomic) SHGCircleSendImageView *selectedImageView;

@end

@implementation SHGBusinessComplainViewController

- (void)viewDidLoad
{
    self.leftItemtitleName = @"取消";
    self.rightItemtitleName = @"提交";
    [super viewDidLoad];
    self.title = @"投诉";
    self.textView.delegate = self;
    [self initView];
    [self addSDLayout];
}
- (void)addSDLayout
{
    //底部
    self.bottomView.sd_layout
    .bottomSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(54.0f);
    
    CGSize size = self.bottom_emoji.currentImage.size;
    self.bottom_emoji.sd_layout
    .leftSpaceToView(self.bottomView, MarginFactor(12.0f))
    .centerYEqualToView(self.bottomView)
    .widthIs(size.width)
    .heightIs(size.height);
    
    size = self.bottom_url.currentImage.size;
    self.bottom_url.sd_layout
    .leftSpaceToView(self.bottom_emoji, MarginFactor(29.0f))
    .centerYEqualToView(self.bottomView)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.bottomLine1.sd_layout
    .leftSpaceToView(self.bottomView, 0.0f)
    .topSpaceToView(self.bottomView, 0.0f)
    .widthRatioToView(self.bottomView, 1.0f)
    .heightIs(1 / SCALE);
    
    self.bottomLine2.sd_layout
    .leftSpaceToView(self.bottomView, 0.0f)
    .bottomSpaceToView(self.bottomView, 0.0f)
    .widthRatioToView(self.bottomView, 1.0f)
    .heightIs(1 / SCALE);
    
    //scrollView
    self.scrollView.sd_layout
    .topSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.bottomView, 0.0f);
    
    self.textView.sd_layout
    .topSpaceToView(self.scrollView, MarginFactor(15.0f))
    .leftSpaceToView(self.scrollView, kImageViewLeftMargin)
    .rightSpaceToView(self.scrollView, kImageViewLeftMargin)
    .heightIs(kTextViewMinHeight);
    
    self.photoView.sd_layout
    .topSpaceToView(self.textView, MarginFactor(25.0f))
    .leftEqualToView(self.textView)
    .rightEqualToView(self.textView)
    .heightIs(2.0f * kImageViewHeight + kImageViewMargin);
    
    WEAK(self, weakSelf);
    self.photoView.didFinishAutoLayoutBlock = ^(CGRect rect){
        CGFloat maxY = MAX(CGRectGetMaxY(rect), CGRectGetHeight(self.scrollView.frame) + 1.0f);
        if (weakSelf.scrollView.contentSize.height != maxY) {
            weakSelf.scrollView.contentSize = CGSizeMake(0.0f, maxY);
        }
    };
    
    size = self.addButton.currentBackgroundImage.size;
    self.addButton.sd_layout
    .widthIs(size.width)
    .heightIs(size.height);
    
    //asscessView
    self.inputAccessoryView.sd_layout
    .bottomSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(54.0f);
    
    size = self.accessory_emoji.currentImage.size;
    self.accessory_emoji.sd_layout
    .leftSpaceToView(self.inputAccessoryView, MarginFactor(12.0f))
    .centerYEqualToView(self.inputAccessoryView)
    .widthIs(size.width)
    .heightIs(size.height);
    
    size = self.accessory_url.currentImage.size;
    self.accessory_url.sd_layout
    .leftSpaceToView(self.accessory_emoji, MarginFactor(29.0f))
    .centerYEqualToView(self.inputAccessoryView)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.accessoryLine1.sd_layout
    .leftSpaceToView(self.inputAccessoryView, 0.0f)
    .topSpaceToView(self.inputAccessoryView, 0.0f)
    .widthRatioToView(self.inputAccessoryView, 1.0f)
    .heightIs(0.5f);
    
    self.accessoryLine2.sd_layout
    .leftSpaceToView(self.inputAccessoryView, 0.0f)
    .bottomSpaceToView(self.inputAccessoryView, 0.0f)
    .widthRatioToView(self.inputAccessoryView, 1.0f)
    .heightIs(0.5f);
    
    
}

- (TWEmojiKeyBoard *)emojiKeyBoard
{
    if (!_emojiKeyBoard) {
        _emojiKeyBoard = [[TWEmojiKeyBoard alloc] init];
        [_emojiKeyBoard createEmojiKeyBoard];
    }
    return _emojiKeyBoard;
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)initView
{
    self.textView.placeholder = @"请写下您的投诉理由";
    self.textView.bounces = NO;
    self.textView.placeholderColor = [UIColor colorWithHexString:@"919291"];
    self.textView.textColor = [UIColor colorWithHexString:@"161616"];
    self.textView.font = FontFactor(16.0f);
    self.textView.inputAccessoryView = self.inputAccessoryView;
    
    self.inputAccessoryView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.accessoryLine1.backgroundColor = [UIColor colorWithHexString:@"b7b7b7"];
    self.accessoryLine1.backgroundColor = [UIColor colorWithHexString:@"b7b7b7"];
    
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.bottomLine1.backgroundColor = [UIColor colorWithHexString:@"b7b7b7"];
    self.bottomLine2.backgroundColor = [UIColor colorWithHexString:@"b7b7b7"];
    
}

- (void)rightItemClick:(id)sender
{
    [self.textView resignFirstResponder];
    if (self.textView.text.length == 0){
        [Hud showMessageWithText:@"请填写投诉理由"];
        return;
    } else if (self.textView.text.length > 2000){
        [Hud showMessageWithText:@"内容不能超过2000"];
        return;
    }
    
    SHGAlertView *alertView = [[SHGAlertView alloc] initWithTitle:@"投诉确认" contentText:@"请确认您的投诉，我们将在一个工作日内进行审核，感谢您对大牛圈的支持！" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
    alertView.rightBlock = ^{
        if (self.imageArray.count == 0){
            //无图片
            [self sendComplainWithPhotos:nil];
        } else{
            [self sendPhotos];
        }
    };
    [alertView show];

}

- (void)sendPhotos
{
    WEAK(self, weakSelf);
    [MOCHTTPRequestOperationManager POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/uploadPhotoCompress"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSInteger i = 0; i < weakSelf.imageArray.count; i++){
            RecommendTypeObj *obj = weakSelf.imageArray[i];
            NSData *imgData = obj.content;
            [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"%ld.jpg",(long)(i + 1)] fileName:[NSString stringWithFormat:@"%ld.jpg",(long)i] mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [(NSString *)[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
        NSArray *pname = (NSArray *)[dic valueForKey:@"pname"];
        [weakSelf sendComplainWithPhotos:pname];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [Hud hideHud];
        [Hud showMessageWithText:error.domain];
    }];
}
- (void)sendComplainWithPhotos:(NSArray *)photos
{
    WEAK(self, weakSelf);
    NSDictionary *param = @{};
    if (!IsArrEmpty(photos)){
        NSString *photoStr = [photos componentsJoinedByString:@","];
        NSString *size = @"";
        for (RecommendTypeObj *obj in self.imageArray){
            UIImage *image = [UIImage imageWithData:obj.content];
            NSInteger width = (int)image.size.width;
            NSInteger height = (int)image.size.height;
            
            NSString *imageSize = [NSString stringWithFormat:@"%ld*%ld",(long)width,(long)height];
            size = [NSString stringWithFormat:@"%@,%@",size,imageSize];
        }
        size = [size substringFromIndex:1];
        param  = @{@"uid":UID, @"content":self.textView.text, @"url":photoStr?:@"", @"type":@"photo", @"sizes":size,@"phone":weakSelf.object.contact,@"businessId":weakSelf.object.businessID,@"businessType":weakSelf.object.type};
    } else{
        param = @{@"uid":UID, @"content":self.textView.text, @"type":@"", @"sizes":@"",@"phone":weakSelf.object.contact,@"businessId":weakSelf.object.businessID,@"businessType":weakSelf.object.type};
    }
    [Hud showWait];
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"complain/business/save"] class:nil parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        id code = [response.data valueForKey:@"code"];
        if ([code intValue] == 0){
            [Hud showMessageWithText:@"投诉成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:response.errorMessage];
    }];
}

-  (void)btnBackClick:(id)sender
{
    [self.textView resignFirstResponder];
    if (self.textView.text.length == 0 && self.imageArray.count == 0) {
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:0.25f];
    } else{
        SHGAlertView *alertView = [[SHGAlertView alloc] initWithTitle:@"提示" contentText:@"退出此次编辑？" leftButtonTitle:@"取消" rightButtonTitle:@"退出"];
        alertView.rightBlock = ^{
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:0.25f];
        };
        [alertView show];
    }

}

- (IBAction)plusButtonClick:(UIButton *)sender
{
    
    if (self.imageArray.count >= 6) {
        [Hud showMessageWithText:@"亲最多只能选6张哦~"];
        return;
    }
    [self.textView resignFirstResponder];
    UIActionSheet *takeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选图", nil];
    [takeSheet showInView:self.view];
}

- (IBAction)emojiButtonClick:(UIButton *)sender
{
    [self.textView resignFirstResponder];
    if (!self.isEmoji){
        self.isEmoji = YES;
        [self.emojiKeyBoard bindKeyBoardWithTextField:(UITextField *)self.textView];
    } else{
        [self.emojiKeyBoard unbindKeyBoard];
        self.isEmoji = NO;
    }
    [self.textView becomeFirstResponder];
}

- (IBAction)urlButtonClick:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"将您复制的信息粘贴在此" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
    
    UITextField *textfield = [alertView textFieldAtIndex:0];
    textfield.placeholder = @"粘贴地址";
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        return;
    } else {
        UITextField *textfield = [alertView textFieldAtIndex:0];
        [self.textView insertText:textfield.text];
    }
}

- (void)takePhoto
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    [self presentViewController:pickerImage animated:YES completion:nil];
}

- (void)choosePhoto
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 6 - self.imageArray.count;
    picker.assetsFilter = ZYQAssetsFilterAllPhotos;
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark ------ 函数

- (void)reloadPhotoView
{
    [self.textView resignFirstResponder];
    [self.photoView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            [obj removeFromSuperview];
        }
    }];
    if (self.imageArray.count == 6) {
        self.addButton.hidden = YES;
    } else{
        self.addButton.hidden = NO;
    }
    
    NSInteger row = 0;
    NSInteger col = 0;
    CGRect frame = CGRectZero;
    for (NSInteger i = 0; i < self.imageArray.count; i++) {
        row = i / 3;
        col = i % 3;
        frame = CGRectMake(col * (kImageViewWidth + kImageViewMargin), row * (kImageViewHeight + kImageViewMargin), kImageViewWidth, kImageViewHeight);
        SHGCircleSendImageView *imageView = [[SHGCircleSendImageView alloc] initWithFrame:frame];
        RecommendTypeObj *obj = [self.imageArray objectAtIndex:i];
        imageView.object = obj;
        
        [self.photoView addSubview:imageView];
        
        UILongPressGestureRecognizer *longTapGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap:)];
        longTapGes.minimumPressDuration = 0.4;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:longTapGes];
    }
    
    row = self.imageArray.count / 3;
    col = self.imageArray.count % 3;
    //更改+号位置
    frame = CGRectMake(col * (kImageViewWidth + kImageViewMargin), row * (kImageViewHeight + kImageViewMargin), kImageViewWidth, kImageViewHeight);
    self.addButton.frame = frame;
}

- (void)longTap:(UILongPressGestureRecognizer *)recognizer
{
    [self.textView resignFirstResponder];
    self.selectedImageView = (SHGCircleSendImageView *)recognizer.view;
    if(recognizer.state == UIGestureRecognizerStateBegan){
        UIActionSheet *deleteAction = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
        [deleteAction showInView:self.view];
    }
}


#pragma mark ------代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"拍照"]) {
        [self takePhoto];
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"选图"]) {
        [self choosePhoto];
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"删除"]) {
        [self.imageArray removeObject:self.selectedImageView.object];
        [self reloadPhotoView];
    }
}


- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    WEAK(self, weakSelf);
    NSInteger count = assets.count;
    __block NSInteger temp = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i < assets.count; i++){
            ZYQAsset *asset = [assets objectAtIndex:i];
            asset.getFullScreenImage = ^(UIImage *result){
                if (result){
                    CGSize size = CGSizeMake(CGRectGetWidth(self.view.frame) * 2.0f, CGRectGetWidth(self.view.frame) * 2.0f / result.size.width * result.size.height);
                    UIImage *imageNew = [result reSizeImagetoSize:size];
                    NSData *dataImage = UIImageJPEGRepresentation(imageNew, 0.5f);//压缩
                    RecommendTypeObj *detailObj = [[RecommendTypeObj alloc] init];
                    detailObj.image = result;
                    detailObj.type = RECOMMENDPICOBJTYPEPIC;
                    detailObj.content = dataImage;
                    [self.imageArray addObject:detailObj];
                    temp++;
                    if (temp >= count) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf reloadPhotoView];
                        });
                    }
                }
            };
        }
    });
}

//点击相册中的图片 或照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (image) {
        
        CGSize size = CGSizeMake(CGRectGetWidth(self.view.frame) * 2.0f, CGRectGetWidth(self.view.frame) * 2.0f / image.size.width * image.size.height);
        UIImage *imageNew = [image reSizeImagetoSize: size];
        
        UIImage *imageData = [UIImage fixOrientation:image];
        NSData *dataImage = UIImageJPEGRepresentation(imageData, 0.5f);//压缩
        
        RecommendTypeObj *detailObj = [[RecommendTypeObj alloc] init];
        detailObj.image = [UIImage fixOrientation:imageNew];;
        detailObj.type = RECOMMENDPICOBJTYPEPIC;
        detailObj.content = dataImage;
        [self.imageArray addObject:detailObj];
        
        [self reloadPhotoView];
    }
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    CGRect frame = textView.frame;
    frame.size.height = size.height > kTextViewMinHeight ? size.height : kTextViewMinHeight;
    textView.frame = frame;
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textView resignFirstResponder];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
