//
//  SHGBusinessShareToDynamicViewController.m
//  Finance
//
//  Created by weiqiankun on 16/7/6.
//  Copyright © 2016年 HuMin. All rights reserved.
//
#import "SHGBusinessShareToDynamicViewController.h"
#import "CPTextViewPlaceholder.h"
#import "TWEmojiKeyBoard.h"
#import "SHGMainPageTableViewCell.h"
#import "SHGBusinessListViewController.h"
#import "SHGBusinessNewDetailViewController.h"
#import "SHGBusinessSendSuccessViewController.h"
#define kTextViewMinHeight MarginFactor(82.0f)
#define kImageViewWidth MarginFactor(105.0f)
#define kImageViewHeight MarginFactor(105.0f)
#define kImageViewLeftMargin MarginFactor(12.0f)
#define kImageViewMargin MarginFactor(18.0f)
#define MAX_TEXT_LENGTH         18

@interface SHGBusinessShareToDynamicViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet CPTextViewPlaceholder *textView;
@property (weak, nonatomic) IBOutlet SHGMainPageBusinessView *detailView;
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
@end

@implementation SHGBusinessShareToDynamicViewController

- (void)viewDidLoad
{
    self.rightItemtitleName = @"发送";
    [super viewDidLoad];
    self.title = @"分享业务至动态";
    self.textView.delegate = self;
    [self initView];
    [self addSDLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
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
    .heightIs(0.5f);
    
    self.bottomLine2.sd_layout
    .leftSpaceToView(self.bottomView, 0.0f)
    .bottomSpaceToView(self.bottomView, 0.0f)
    .widthRatioToView(self.bottomView, 1.0f)
    .heightIs(0.5f);
    
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

    self.detailView.sd_layout
    .topSpaceToView(self.textView, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f)
    .heightIs(MarginFactor(59.0f));

    __weak typeof(self)weakSelf = self;
    self.detailView.didFinishAutoLayoutBlock = ^(CGRect rect){
        CGFloat maxY = MAX(CGRectGetMaxY(rect), CGRectGetHeight(self.scrollView.frame) + 1.0f);
        if (weakSelf.scrollView.contentSize.height != maxY) {
            weakSelf.scrollView.contentSize = CGSizeMake(0.0f, maxY);
        }
    };
    
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
- (void)initView
{

    self.detailView.object = self.object;
    self.textView.placeholder = @"说两句吧...";
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
    [self businessShareWithObj:self.object];
}

-(void)businessShareWithObj:(SHGBusinessObject *)obj
{
    NSString *uid = UID;
    NSString *title = self.textView.text;
//    if (self.textView.text.length == 0) {
//        title = @"业务分享";
//    }
    NSString *detail = obj.businessTitle;
    NSString *businessId =[NSString stringWithFormat:@"%@#%@",obj.businessID,obj.type];
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"businessTocircle"];
    NSDictionary *param = @{@"uid":uid, @"detail":detail ,@"title":title,@"businessId":businessId, @"currCity":[SHGGloble sharedGloble].cityName};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            [Hud showMessageWithText:@"业务分享成功"];
            if ([self.controller isKindOfClass:[SHGBusinessSendSuccessViewController class]]){
                [[SHGBusinessListViewController sharedController] didCreateOrModifyBusiness:obj];
                [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:@(YES) afterDelay:0.25f];
            } else{
                [self.navigationController popViewControllerAnimated:YES];
            }

        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];

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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""] && textView.text.length + text.length > MAX_TEXT_LENGTH){
        [textView resignFirstResponder];
        [Hud showMessageWithText:@"标题最多可输入18个字"];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    CGRect frame = textView.frame;
    frame.size.height = size.height > kTextViewMinHeight ? size.height : kTextViewMinHeight;
    textView.frame = frame;
    return YES;
}

- (void)keyBoardDidShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    CGFloat maxHeight = CGRectGetHeight(self.view.frame) - keyboardSize.height - CGRectGetHeight(self.inputAccessoryView.frame);
    
    CGFloat cursorPosition = [self.textView caretRectForPosition:self.textView.selectedTextRange.start].origin.y;
    
    if (cursorPosition > maxHeight) {
        [self.scrollView setContentOffset:CGPointMake(0.0f, cursorPosition - maxHeight) animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textView resignFirstResponder];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
