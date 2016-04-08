//
//  SHGEquityInvestNextViewController.m
//  Finance
//
//  Created by weiqiankun on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGEquityInvestNextViewController.h"
#import "EMTextView.h"
#import "SHGBusinessMargin.h"
#import "UIButton+EnlargeEdge.h"
@interface SHGEquityInvestNextViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
//资金来源
@property (strong, nonatomic) IBOutlet UIView *capitalSourceView;
@property (weak, nonatomic) IBOutlet UILabel *capitalSourceLabel;
@property (weak, nonatomic) IBOutlet UIView *capitalSourceButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *capitalSourceSelectImage;

//投资期限
@property (strong, nonatomic) IBOutlet UIView *investTimeView;
@property (weak, nonatomic) IBOutlet UILabel *investTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *investTimeButtonView;

//参股比例
@property (strong, nonatomic) IBOutlet UIView *retributionView;
@property (weak, nonatomic) IBOutlet UILabel *retributionTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *retributionTextField;
@property (weak, nonatomic) IBOutlet UILabel *retributionNumLabel;

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
@property (strong, nonatomic) UIImage *buttonBgImage;
@property (strong, nonatomic) UIImage *buttonSelectBgImage;

@property (strong, nonatomic) UIButton *timeCurrentButton;
@property (strong, nonatomic) UIButton *requireCurrentButton;

@property (strong, nonatomic) id currentContext;
@end

@implementation SHGEquityInvestNextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布股权投资";
    self.scrollView.delegate = self;
    self.retributionTextField.delegate = self;
    self.marketExplainTextView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    self.buttonBgImage = [UIImage imageNamed:@"business_SendButtonBg"];
    self.buttonBgImage = [self.buttonBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f) resizingMode:UIImageResizingModeStretch];
    
    self.buttonSelectBgImage = [UIImage imageNamed:@"business_SendButtonSelectBg"];
    self.buttonSelectBgImage = [self.buttonSelectBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f) resizingMode:UIImageResizingModeStretch];

    [self.scrollView addSubview:self.capitalSourceView];
    [self.scrollView addSubview:self.investTimeView];
    [self.scrollView addSubview:self.retributionView];
    [self.scrollView addSubview:self.marketExplainView];
    [self.scrollView addSubview:self.addImageView];
    [self.scrollView addSubview:self.authorizeButton];
    [self addSdLayout];
    [self initView];

 
}

- (void)addSdLayout
{
    
    UIImage *image = [UIImage imageNamed:@"biXuan"];
    CGSize size = image.size;

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
    
    //资金来源
    self.capitalSourceView.sd_layout
    .topSpaceToView(self.scrollView, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.capitalSourceLabel.sd_layout
    .topSpaceToView(self.capitalSourceView, ktopToView)
    .leftSpaceToView(self.capitalSourceView, kLeftToView)
    .autoHeightRatio(0.0f);
    [self.capitalSourceLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.capitalSourceSelectImage.sd_layout
    .leftSpaceToView(self.capitalSourceLabel, kLeftToView)
    .centerYEqualToView(self.capitalSourceLabel)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.capitalSourceButtonView.sd_layout
    .leftSpaceToView(self.capitalSourceView, 0.0f)
    .rightSpaceToView(self.capitalSourceView, 0.0f)
    .topSpaceToView(self.capitalSourceLabel, ktopToView)
    .heightIs(kButtonHeight);
    
    [self.capitalSourceView setupAutoHeightWithBottomView:self.capitalSourceButtonView bottomMargin:ktopToView];
    //参股比例
    self.retributionView.sd_layout
    .topSpaceToView(self.capitalSourceView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.retributionTitleLabel.sd_layout
    .topSpaceToView(self.retributionView, ktopToView)
    .leftSpaceToView(self.retributionView, kLeftToView)
    .autoHeightRatio(0.0f);
    [self.retributionTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.retributionTextField.sd_layout
    .leftEqualToView(self.retributionTitleLabel)
    .topSpaceToView(self.retributionTitleLabel, ktopToView)
    .widthIs(MarginFactor(212.0f))
    .heightIs(kButtonHeight);
    
    self.retributionNumLabel.sd_layout
    .leftSpaceToView(self.retributionTextField, kLeftToView)
    .centerYEqualToView(self.retributionTextField)
    .autoHeightRatio(0.0f);
    [self.retributionNumLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    [self.retributionView setupAutoHeightWithBottomView:self.retributionTextField bottomMargin:ktopToView];
    
    //投资期限
    self.investTimeView.sd_layout
    .topSpaceToView(self.retributionView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.investTimeTitleLabel.sd_layout
    .topSpaceToView(self.investTimeView, ktopToView)
    .leftSpaceToView(self.investTimeView, kLeftToView)
    .autoHeightRatio(0.0f);
    [self.investTimeTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.investTimeButtonView.sd_layout
    .leftSpaceToView(self.investTimeView, 0.0f)
    .rightSpaceToView(self.investTimeView, 0.0f)
    .topSpaceToView(self.investTimeTitleLabel, ktopToView)
    .heightIs(kButtonHeight);
    
    [self.investTimeView setupAutoHeightWithBottomView:self.investTimeButtonView bottomMargin:ktopToView];
    //业务说明
    
    self.marketExplainView.sd_layout
    .topSpaceToView(self.investTimeView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.marketExplainTitleLabel.sd_layout
    .topSpaceToView(self.marketExplainView, ktopToView)
    .leftSpaceToView(self.marketExplainView, kLeftToView)
    .autoHeightRatio(0.0f);
    [self.marketExplainTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
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
    UIImage *addImage = [UIImage imageNamed:@"addImageButton"];
    CGSize addSize = addImage.size;
    
    self.addImageView.sd_layout
    .topSpaceToView(self.marketExplainView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.addImageTitleLabel.sd_layout
    .topSpaceToView(self.addImageView, ktopToView)
    .leftSpaceToView(self.addImageView, kLeftToView)
    .autoHeightRatio(0.0f);
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
    
    [self.scrollView setupAutoHeightWithBottomView:self.authorizeButton bottomMargin:MarginFactor(20.0f)];
    
    
    
}

- (void)initView
{
    self.sureButton.titleLabel.font = FontFactor(19.0f);
    [self.sureButton setTitleColor:Color(@"ffffff") forState:UIControlStateNormal];
    [self.sureButton setBackgroundColor:Color(@"f04241")];
    
    self.retributionTextField.layer.borderColor = Color(@"cecece").CGColor;
    self.retributionTextField.layer.borderWidth = 0.5f;

    self.marketExplainTextView.layer.borderColor = Color(@"cecece").CGColor;
    self.marketExplainTextView.layer.borderWidth = 0.5f;
    
    self.capitalSourceLabel.textColor = Color(@"161616");
    self.capitalSourceLabel.font = FontFactor(13.0f);
    
    self.investTimeTitleLabel.textColor = Color(@"161616");
    self.investTimeTitleLabel.font = FontFactor(13.0f);
    
    self.retributionTitleLabel.textColor = Color(@"161616");
    self.retributionTitleLabel.font = FontFactor(13.0f);
    
    self.marketExplainTitleLabel.textColor = Color(@"161616");
    self.marketExplainTitleLabel.font = FontFactor(13.0f);
    
    self.addImageTitleLabel.textColor = Color(@"161616");
    self.addImageTitleLabel.font = FontFactor(13.0f);
    
    self.retributionNumLabel.font = FontFactor(15.0f);
    self.retributionNumLabel.textColor = Color(@"161616");
    
    self.retributionTextField.font = FontFactor(15.0f);
    self.retributionTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 6.0f, 0.0f)];
    self.retributionTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.retributionTextField setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    
    NSArray *investTimeArray = @[@"不限",@"3年以上",@"3~5年",@"5年以上"];
    for (NSInteger i = 0; i < investTimeArray.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = FontFactor(15.0f);
        button.adjustsImageWhenHighlighted = NO;
        [button setTitle:[investTimeArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        [button setBackgroundImage:self.buttonBgImage forState:UIControlStateNormal];
        [button setTitleColor:Color(@"ff8d65") forState:UIControlStateSelected];
        [button setBackgroundImage:self.buttonSelectBgImage forState:UIControlStateSelected];
        button.frame = CGRectMake(kLeftToView + i * (kFourButtonWidth + kButtonLeftMargin), 0.0f, kFourButtonWidth, kCategoryButtonHeight);
        [button addTarget:self action:@selector(investTimeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.investTimeButtonView addSubview:button];
    }
    
    NSArray *addRequireArray = @[@"个人资金",@"企业资金",@"金融机构"];
    for (NSInteger j = 0; j < addRequireArray.count; j ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = FontFactor(15.0f);
        button.adjustsImageWhenHighlighted = NO;
        [button setTitle:[addRequireArray objectAtIndex:j] forState:UIControlStateNormal];
        [button setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        [button setBackgroundImage:self.buttonBgImage forState:UIControlStateNormal];
        [button setTitleColor:Color(@"ff8d65") forState:UIControlStateSelected];
        [button setBackgroundImage:self.buttonSelectBgImage forState:UIControlStateSelected];
        button.frame = CGRectMake(kLeftToView + j * (kThreeButtonWidth + kButtonLeftMargin),0.0f, kThreeButtonWidth, kCategoryButtonHeight);
        [button addTarget:self action:@selector(addRequireButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.capitalSourceButtonView addSubview:button];
    }
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

- (void)investTimeButtonClick:(UIButton *)btn
{
    if(btn != self.timeCurrentButton){
        self.timeCurrentButton.selected = NO;
        self.timeCurrentButton = btn;
    }
    self.timeCurrentButton.selected = YES;}

- (void)addRequireButtonClick:(UIButton *)btn
{
    if(btn != self.requireCurrentButton){
        self.requireCurrentButton.selected = NO;
        self.requireCurrentButton = btn;
    }
    self.requireCurrentButton.selected = YES;
}

- (IBAction)authorizeButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (IBAction)sureButtonClick:(UIButton *)sender
{
    
}
- (BOOL)checkInputMessage
{
    if (self.requireCurrentButton.selected  == YES) {
        [Hud showMessageWithText:@"请选择资金来源"];
        return NO;
    }
    if (self.marketExplainTextView.text.length == 0) {
        [Hud showMessageWithText:@"请填写业务说明"];
        return NO;
    }
    
    return YES;
}


//键盘消失

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentContext = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    NSDictionary* info = [notificaiton userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    CGRect viewFrame = [self.scrollView frame];
    viewFrame.size.height -= keyboardSize.height;
    self.scrollView.frame = viewFrame;
    CGRect textFieldRect = [self.currentContext frame];
    [self.scrollView scrollRectToVisible:textFieldRect animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 
}


@end
