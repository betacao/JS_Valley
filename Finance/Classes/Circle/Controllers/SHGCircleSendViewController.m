//
//  SHGCircleSendViewController.m
//  Finance
//
//  Created by changxicao on 16/3/8.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCircleSendViewController.h"
#import "CPTextViewPlaceholder.h"
#import "TWEmojiKeyBoard.h"
#import "ZYQAssetPickerController.h"
#import "CCLocationManager.h"
#define kTextViewMinHeight MarginFactor(100.0f)
#define kImageViewWidth MarginFactor(105.0f)
#define kImageViewHeight MarginFactor(105.0f)
#define kImageViewLeftMargin MarginFactor(12.0f)
#define kImageViewMargin MarginFactor(18.0f)
#define MAX_TEXT_LENGTH         2000
#define MAX_STRING_LENGTH         2000
#define MAX_STARWORDS_LENGTH 18
#define kFourButtonWidth floorf((SCREENWIDTH - 2 * MarginFactor(12.0f) - 3 * MarginFactor(19.0f)) / 4.0)
@interface SHGCircleSendViewController ()<UITextViewDelegate, UIActionSheetDelegate, ZYQAssetPickerControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (assign, nonatomic) BOOL isTextField;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) BOOL isEmoji;
@property (strong, nonatomic) TWEmojiKeyBoard *emojiKeyBoard;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *bottom_emoji;
@property (weak, nonatomic) IBOutlet UIButton *bottom_url;
@property (weak, nonatomic) IBOutlet UIView *bottomLine1;
@property (weak, nonatomic) IBOutlet UIView *bottomLine2;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UIScrollView *typeButtonScrollerView;
@property (weak, nonatomic) IBOutlet UILabel *typeTitleLabel;
//@property (weak, nonatomic) IBOutlet UIView *typeButtonView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet CPTextViewPlaceholder *textView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (strong, nonatomic) IBOutlet UIView *inputAccessoryView;
@property (weak, nonatomic) IBOutlet UIButton *accessory_emoji;
@property (weak, nonatomic) IBOutlet UIButton *accessory_url;
@property (weak, nonatomic) IBOutlet UIView *accessoryLine1;
@property (weak, nonatomic) IBOutlet UIView *accessoryLine2;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (weak, nonatomic) SHGCircleSendImageView *selectedImageView;

@property(strong, nonatomic) UIImage *buttonBgImage;
@property(strong, nonatomic) UIImage *buttonSelectBgImage;

@property (strong, nonatomic) UIButton *currentButton;


@end

@implementation SHGCircleSendViewController

- (void)viewDidLoad
{
    self.leftItemtitleName = @"取消";
    self.rightItemtitleName = @"发送";
    [super viewDidLoad];
    self.buttonBgImage = [[UIImage imageNamed:@"circle_typeUnSelect"] resizableImageWithCapInsets:UIEdgeInsetsMake(MarginFactor(5.0f), MarginFactor(5.0f), MarginFactor(5.0f), MarginFactor(5.0f)) resizingMode:UIImageResizingModeStretch];
    
    self.buttonSelectBgImage = [[UIImage imageNamed:@"circle_typeSelect"] resizableImageWithCapInsets:UIEdgeInsetsMake(MarginFactor(5.0f), MarginFactor(5.0f), MarginFactor(5.0f), MarginFactor(5.0f)) resizingMode:UIImageResizingModeStretch];
    if ([[SHGGloble sharedGloble].cityName isEqualToString:@""]) {
        [[CCLocationManager shareLocation] getCity:nil];
    }
    [self.textField becomeFirstResponder];
    self.title = @"发帖";
    [self initView];
    [self addAutoLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)initView
{
    self.scrollView.delegate = self;
    self.typeButtonScrollerView.backgroundColor = [UIColor clearColor];
    self.typeButtonScrollerView.delegate = self;
    self.typeButtonScrollerView.showsHorizontalScrollIndicator = NO;
    
    NSArray *typeArray = @[@"债权融资",@"股权融资",@"资金",@"银证业务",@"其他"];
    for (NSInteger i = 0; i < typeArray.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = FontFactor(14.0f);
        button.adjustsImageWhenHighlighted = NO;
        [button setTitle:[typeArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:Color(@"8a8a8a") forState:UIControlStateNormal];
        [button setBackgroundImage:self.buttonBgImage forState:UIControlStateNormal];
        if (i == 0) {
            [button setBackgroundImage:self.buttonSelectBgImage forState:UIControlStateNormal];
            [button setTitleColor:Color(@"f33300") forState:UIControlStateNormal];
            self.currentButton = button;
        }
        
        button.frame = CGRectMake(MarginFactor(12.0f) + i * (kFourButtonWidth + MarginFactor(19.0f)), 0.0f, kFourButtonWidth, MarginFactor(26.0f));
        [button addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.typeButtonScrollerView addSubview:button];
    }
    
    self.typeButtonScrollerView.contentSize = CGSizeMake(5 * kFourButtonWidth + 4*MarginFactor(19.0f) + 2*MarginFactor(12.0f), MarginFactor(26.0f));
    self.typeTitleLabel.text = @"动态类型";
    self.typeTitleLabel.textColor = Color(@"bebebe");
    self.typeTitleLabel.font = FontFactor(15.0f);
    
    self.scrollView.backgroundColor = Color(@"f7f7f7");
    
    self.textField.placeholder = @"动态标题";
    self.textField.textColor = Color(@"161616");
    self.textField.font = FontFactor(15.0f);
    [self.textField setValue:Color(@"bebebe") forKeyPath:@"_placeholderLabel.textColor"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, MarginFactor(6.0f), 0.0f)];
    self.textField.leftView = view;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    
    self.textField.layer.borderWidth = 1/SCALE;
    self.textField.layer.borderColor = Color(@"e4e4e4").CGColor;
    
    self.textView.layer.borderWidth = 1/SCALE;
    self.textView.layer.borderColor = Color(@"e4e4e4").CGColor;
    
    self.textView.placeholder = @"动态描述";
    self.textView.bounces = NO;
    self.textView.placeholderColor = Color(@"bebebe");
    self.textView.textColor = Color(@"161616");
    self.textView.font = FontFactor(15.0f);
    self.textView.inputAccessoryView = self.inputAccessoryView;

    self.inputAccessoryView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.accessoryLine1.backgroundColor = [UIColor colorWithHexString:@"b7b7b7"];
    self.accessoryLine1.backgroundColor = [UIColor colorWithHexString:@"b7b7b7"];

    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.bottomLine1.backgroundColor = [UIColor colorWithHexString:@"b7b7b7"];
    self.bottomLine2.backgroundColor = [UIColor colorWithHexString:@"b7b7b7"];

}

- (void)categoryButtonClick:(UIButton *)btn
{
    if (btn != self.currentButton) {
        [self.currentButton setTitleColor:Color(@"8a8a8a") forState:UIControlStateNormal];
        [self.currentButton setBackgroundImage:self.buttonBgImage forState:UIControlStateNormal];
        
        [btn setBackgroundImage:self.buttonSelectBgImage forState:UIControlStateNormal];
        [btn setTitleColor:Color(@"f33300") forState:UIControlStateNormal];
        self.currentButton = btn;
    }
    
}
- (void)addAutoLayout
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

    self.typeView.sd_layout
    .topSpaceToView(self.scrollView, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.typeTitleLabel.sd_layout
    .topSpaceToView(self.typeView, MarginFactor(10.0f))
    .leftSpaceToView(self.typeView, MarginFactor(17.0f))
    .heightIs(self.typeTitleLabel.font.lineHeight);
    [self.typeTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.typeButtonScrollerView.sd_layout
    .topSpaceToView(self.typeTitleLabel,MarginFactor(10.0f))
    .leftSpaceToView(self.typeView, 0.0f)
    .rightSpaceToView(self.typeView, 0.0f)
    .heightIs(MarginFactor(26.0f));
    
    [self.typeView setupAutoHeightWithBottomView:self.typeButtonScrollerView bottomMargin:MarginFactor(10.0f)];
    
    
    self.titleView.sd_layout
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f)
    .topSpaceToView(self.typeView, MarginFactor(11.0f));
    
    self.textField.sd_layout
    .topSpaceToView(self.titleView, MarginFactor(10.0f))
    .leftSpaceToView(self.titleView, kImageViewLeftMargin)
    .rightSpaceToView(self.titleView, kImageViewLeftMargin)
    .heightIs(MarginFactor(48.0f));
    
    [self.titleView setupAutoHeightWithBottomView:self.textField bottomMargin:MarginFactor(10.0f)];


    self.detailView.sd_layout
    .topSpaceToView(self.titleView, MarginFactor(11.0f))
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.textView.sd_layout
    .topSpaceToView(self.detailView, MarginFactor(10.0f))
    .leftSpaceToView(self.detailView, kImageViewLeftMargin)
    .rightSpaceToView(self.detailView, kImageViewLeftMargin)
    .heightIs(kTextViewMinHeight);
    
    [self.detailView setupAutoHeightWithBottomView:self.textView bottomMargin:MarginFactor(10.0f)];

    self.photoView.sd_layout
    .topSpaceToView(self.detailView, MarginFactor(11.0f))
    .leftEqualToView(self.detailView)
    .rightEqualToView(self.detailView)
    .heightIs(2.0f * kImageViewHeight + kImageViewMargin + 2*MarginFactor(12.0f));

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
    .heightIs(1 / SCALE);

    self.accessoryLine2.sd_layout
    .leftSpaceToView(self.inputAccessoryView, 0.0f)
    .bottomSpaceToView(self.inputAccessoryView, 0.0f)
    .widthRatioToView(self.inputAccessoryView, 1.0f)
    .heightIs(1 / SCALE);

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

#pragma mark ------ 函数

- (void)reloadPhotoView
{
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
        frame = CGRectMake(MarginFactor(12.0f) + col * (kImageViewWidth + kImageViewMargin), MarginFactor(12.0f) + row * (kImageViewHeight + kImageViewMargin), kImageViewWidth, kImageViewHeight);
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
    frame = CGRectMake(MarginFactor(12.0f) + col * (kImageViewWidth + kImageViewMargin),MarginFactor(12.0f) + row * (kImageViewHeight + kImageViewMargin), kImageViewWidth, kImageViewHeight);
    self.addButton.frame = frame;
}

- (void)btnBackClick:(id)sender
{
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
    SHGAlertView *alertView = [[SHGAlertView alloc] initWithTitle:@"提示" contentText:@"退出此次编辑?" leftButtonTitle:@"取消" rightButtonTitle:@"退出"];
    alertView.rightBlock = ^{
        [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:@(YES) afterDelay:0.25f];
    };
    [alertView show];
}

- (void)rightItemClick:(id)sender
{
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
    if ([self isEmpty:self.textField.text] == YES) {
        [Hud showMessageWithText:@"标题不能为空"];
        return;
    }
    
    if (self.textField.text.length == 0) {
        [Hud showMessageWithText:@"标题不能为空"];
        return;
    } else if (self.textField.text.length > 18) {
        [Hud showMessageWithText:@"标题最多可输入18个字"];
        return;
    }
    
    if (self.textView.text.length > MAX_TEXT_LENGTH){
        [Hud showMessageWithText:@"帖子过长，不能超过2000个字"];
        return;
    }
    //把发送按钮的变成不可点
    //    self.navigationItem.rightBarButtonItem.userInteractionEnabled = NO;
    [Hud showWait];
    if (self.imageArray.count == 0){
        //无图片
        [self sendCircleWithPhotos:nil];
    } else{
        [self sendPhotos];
    }
}

- (BOOL)isEmpty:(NSString *)str {
    
    if (!str) {
        return YES;
    } else {
        NSString *trimedString = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (trimedString.length == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (void)sendPhotos
{
    WEAK(self, weakSelf);
    [MOCHTTPRequestOperationManager POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/base"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSInteger i = 0; i < weakSelf.imageArray.count; i++){
            RecommendTypeObj *obj = weakSelf.imageArray[i];
            NSData *imgData = obj.content;
            [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"%ld.jpg",(long)(i + 1)] fileName:[NSString stringWithFormat:@"%ld.jpg",(long)i] mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [(NSString *)[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
        NSArray *pname = (NSArray *)[dic valueForKey:@"pname"];
        [weakSelf sendCircleWithPhotos:pname];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [Hud hideHud];
        [Hud showMessageWithText:error.domain];
    }];
}

- (void)sendCircleWithPhotos:(NSArray *)photos
{
    WEAK(self, weakSelf);
    NSDictionary *businessSelectDic = [[SHGGloble sharedGloble] getBusinessKeysAndValues];
    NSString *busType = [businessSelectDic objectForKey:weakSelf.currentButton.titleLabel.text];
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
        param  = @{@"uid":UID, @"detail":self.textView.text, @"photos":photoStr?:@"", @"type":@"photo", @"sizes":size, @"currCity":[SHGGloble sharedGloble].cityName ,@"title":self.textField.text,@"busType":busType};
    } else{
        param = @{@"uid":UID, @"detail":self.textView.text, @"type":@"", @"sizes":@"", @"currCity":[SHGGloble sharedGloble].cityName, @"title":self.textField.text,@"busType":busType};
    }

    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,actioncircle] class:nil parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        id code = [response.data valueForKey:@"code"];
        if ([code intValue] == 0){
            [Hud showMessageWithText:@"发帖成功"];
            [MobClick event:@"ActionPost" label:@"onClick"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_SENDPOST object:nil];
            });
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:response.errorMessage];
    }];
}

- (IBAction)plusButtonClick:(UIButton *)sender
{
    if (self.imageArray.count >= 6) {
        [Hud showMessageWithText:@"亲最多只能选6张哦~"];
        return;
    }
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
    UIActionSheet *takeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选图", nil];
    [takeSheet showInView:self.view];
}

- (IBAction)emojiButtonClick:(UIButton *)sender
{
    if ([self.textField isEditing]) {
        [self.textField resignFirstResponder];
        if (!self.isEmoji){
            self.isEmoji = YES;
            [self.emojiKeyBoard bindKeyBoardWithTextField:self.textField];
        } else {
            self.isEmoji = NO;
            [self.emojiKeyBoard unbindKeyBoard];
        }
        [self.textField becomeFirstResponder];
    } else{
        [self.textView resignFirstResponder];
        if (!self.isEmoji){
            self.isEmoji = YES;
            [self.emojiKeyBoard bindKeyBoardWithTextField:(UITextField *)self.textView];
        } else {
            self.isEmoji = NO;
            [self.emojiKeyBoard unbindKeyBoard];
        }
        [self.textView becomeFirstResponder];
    }
}

- (IBAction)urlButtonClick:(UIButton *)sender
{
    if ([self.textField isEditing]) {
        self.isTextField = YES;
        UITextPosition* beginning = self.textField.beginningOfDocument;
        UITextRange* selectedRange = self.textField.selectedTextRange;
        UITextPosition* selectionStart = selectedRange.start;
        NSInteger location = [self.textField offsetFromPosition:beginning toPosition:selectionStart];
        self.index = location;
    } else{
        self.isTextField = NO;
    }
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
        if (self.isTextField) {
            [self.textField becomeFirstResponder];
            NSMutableString *content = [[NSMutableString alloc] initWithString:self.textField.text];
            [content insertString:textfield.text atIndex:self.index];
            self.textField.text = content;
        } else{
            [self.textView becomeFirstResponder];
            [self.textView insertText:textfield.text];
        }
        
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

- (void)longTap:(UILongPressGestureRecognizer *)recognizer
{
    [self.textField resignFirstResponder];
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""] && textView.text.length + text.length > MAX_TEXT_LENGTH){
        [textView resignFirstResponder];
        [Hud showMessageWithText:@"帖子过长，不能超过2000个字"];
        return NO;
    }
    return YES;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textView resignFirstResponder];
        [self.textField resignFirstResponder];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end




@interface SHGCircleSendImageView()

@end

@implementation SHGCircleSendImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setObject:(RecommendTypeObj *)object
{
    _object = object;
    self.image = object.image;
}

@end

