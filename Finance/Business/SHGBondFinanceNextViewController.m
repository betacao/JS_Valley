//
//  SHGBondFinanceNextViewController.m
//  Finance
//
//  Created by weiqiankun on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBondFinanceNextViewController.h"
#import "EMTextView.h"
#import "SHGBusinessMargin.h"

@interface SHGBondFinanceNextViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
//增信方式
@property (strong, nonatomic) IBOutlet UIView *addRequireView;
@property (weak, nonatomic) IBOutlet UILabel *addRequireTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *addRequireButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *addRequireImage;

//投资期限
@property (strong, nonatomic) IBOutlet UIView *investTimeView;
@property (weak, nonatomic) IBOutlet UILabel *investTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *investTimeButtonView;
//最低回报要求
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

@end

@implementation SHGBondFinanceNextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布债券融资";
    [self.scrollView addSubview:self.addRequireView];
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
    
    //增信要求
    self.addRequireView.sd_layout
    .topSpaceToView(self.scrollView, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.addRequireTitleLabel.sd_layout
    .topSpaceToView(self.addRequireView, ktopToView)
    .leftSpaceToView(self.addRequireView, kLeftToView)
    .autoHeightRatio(0.0f);
    [self.addRequireTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.addRequireImage.sd_layout
    .leftSpaceToView(self.addRequireTitleLabel, kLeftToView)
    .centerYEqualToView(self.addRequireTitleLabel)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.addRequireButtonView.sd_layout
    .leftSpaceToView(self.addRequireView, 0.0f)
    .rightSpaceToView(self.addRequireView, 0.0f)
    .topSpaceToView(self.addRequireTitleLabel, ktopToView)
    .heightIs(MarginFactor(36.0f));
    
    [self.addRequireView setupAutoHeightWithBottomView:self.addRequireButtonView bottomMargin:ktopToView];
    //最低回报要求
    self.retributionView.sd_layout
    .topSpaceToView(self.addRequireView, kLeftToView)
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
    
    self.addRequireTitleLabel.textColor = Color(@"161616");
    self.addRequireTitleLabel.font = FontFactor(13.0f);
    
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
    
    self.retributionTextField.layer.borderColor = Color(@"cecece").CGColor;
    self.retributionTextField.layer.borderWidth = 0.5f;
    self.retributionTextField.font = FontFactor(15.0f);
    self.retributionTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 6.0f, 0.0f)];
    self.retributionTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.retributionTextField setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    
    NSArray *investTimeArray = @[@"一年以内",@"1~3年",@"3年以上"];
    for (int i = 0; i < investTimeArray.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = FontFactor(15.0f);
        button.adjustsImageWhenHighlighted = NO;
        [button setTitle:[investTimeArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"marketSendButtonBg"] forState:UIControlStateNormal];
        button.frame = CGRectMake(kLeftToView + i * (kThreeButtonWidth + kButtonLeftMargin), 0.0f, kThreeButtonWidth, kCategoryButtonHeight);
        [button addTarget:self action:@selector(investTimeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.investTimeButtonView addSubview:button];
    }
    
    NSArray *addRequireArray = @[@"抵押",@"质押",@"保证",@"信用"];
    for (int j = 0; j < addRequireArray.count; j ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = FontFactor(15.0f);
        button.adjustsImageWhenHighlighted = NO;
        [button setTitle:[addRequireArray objectAtIndex:j] forState:UIControlStateNormal];
        [button setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"marketSendButtonBg"] forState:UIControlStateNormal];
        button.frame = CGRectMake(kLeftToView + j * (kFourButtonWidth + kButtonLeftMargin), 0.0f, kFourButtonWidth, kCategoryButtonHeight);
        [button addTarget:self action:@selector(addRequireButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.addRequireButtonView addSubview:button];
    }
    self.marketExplainTextView.font = FontFactor(15.0f);
    self.marketExplainTextView.textColor = Color(@"161616");
    self.marketExplainTextView.placeholder = @" 请描述您的业务详情或将您的业务信息拍照上传";
    self.marketExplainTextView.placeholderColor = Color(@"bebebe");
    self.marketExplainTextView.layer.borderColor = Color(@"cecece").CGColor;
    self.marketExplainTextView.layer.borderWidth = 0.5f;
    self.authorizeButton.backgroundColor = [UIColor clearColor];
    self.authorizeButton.titleLabel.font = FontFactor(14.0f);
    [self.authorizeButton setTitleColor:Color(@"8b8b8b") forState:UIControlStateNormal];
    [self.authorizeButton setImage:[UIImage imageNamed:@"market_unselect"] forState:UIControlStateNormal];
    [self.authorizeButton setImage:[UIImage imageNamed:@"market_select"] forState:UIControlStateSelected];
}

- (void)investTimeButtonClick:(UIButton *)btn
{
    if (!btn.selected) {
        [btn setTitleColor:Color(@"ff8d65") forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"marketSendButtonSelectBg"] forState:UIControlStateNormal];
    }
}

- (void)addRequireButtonClick:(UIButton *)btn
{
    
    if (!btn.selected) {
        [btn setTitleColor:Color(@"ff8d65") forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"marketSendButtonSelectBg"] forState:UIControlStateNormal];
    }
}

- (IBAction)sureButtonClick:(UIButton *)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end