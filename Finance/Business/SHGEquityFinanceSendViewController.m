//
//  SHGEquityFinanceSendViewController.m
//  Finance
//
//  Created by weiqiankun on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGEquityFinanceSendViewController.h"
#import "SHGEquityFinanceNextViewController.h"
#import "SHGBusinessMargin.h"

@interface SHGEquityFinanceSendViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

//业务名称
@property (strong, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *nameSelectImage;

//联系电话
@property (strong, nonatomic) IBOutlet UIView *phoneNumView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UIImageView *phoneNumSelectImage;

//融资阶段
@property (strong, nonatomic) IBOutlet UIView *bondStageView;
@property (weak, nonatomic) IBOutlet UILabel *bondStageLabel;
@property (weak, nonatomic) IBOutlet UIView *bondStageButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *bondStageSelctImage;

//金额
@property (strong, nonatomic) IBOutlet UIView *monenyView;
@property (weak, nonatomic) IBOutlet UILabel *monenyLabel;
@property (weak, nonatomic) IBOutlet UITextField *monenyTextField;
@property (weak, nonatomic) IBOutlet UILabel *moneyMonad;

//地区
@property (strong, nonatomic) IBOutlet UIView *areaView;
@property (weak, nonatomic) IBOutlet UIButton *areaSelectButton;
@property (weak, nonatomic) IBOutlet UIImageView *areaSelectImage;
@property (weak, nonatomic) IBOutlet UILabel *areaTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *areaNewSelectButton;

//行业
@property (strong, nonatomic) IBOutlet UIView *industryView;
@property (weak, nonatomic) IBOutlet UILabel *industryLabel;
@property (weak, nonatomic) IBOutlet UIButton *industrySelectButton;
@property (weak, nonatomic) IBOutlet UIImageView *industrySelectImage;
@end

@implementation SHGEquityFinanceSendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布股权融资";
    [self.scrollView addSubview:self.nameView];
    [self.scrollView addSubview:self.phoneNumView];
    [self.scrollView addSubview:self.bondStageView];
    [self.scrollView addSubview:self.monenyView];
    [self.scrollView addSubview:self.areaView];
    [self.scrollView addSubview:self.industryView];
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
    
    self.nextButton.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(50.0f));
    //业务名称
    self.nameView.sd_layout
    .topSpaceToView(self.scrollView, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.nameLabel.sd_layout
    .topSpaceToView(self.nameView, ktopToView)
    .leftSpaceToView(self.nameView, kLeftToView)
    .autoHeightRatio(0.0f);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.nameSelectImage.sd_layout
    .leftSpaceToView(self.nameLabel, kLeftToView)
    .centerYEqualToView(self.nameLabel)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.nameTextField.sd_layout
    .leftEqualToView(self.nameLabel)
    .rightSpaceToView(self.nameView, kLeftToView)
    .topSpaceToView(self.nameLabel, ktopToView)
    .heightIs(kButtonHeight);
    [self.nameView setupAutoHeightWithBottomView:self.nameTextField bottomMargin:ktopToView];
    
    //联系电话
    self.phoneNumView.sd_layout
    .topSpaceToView(self.nameView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.phoneNumLabel.sd_layout
    .topSpaceToView(self.phoneNumView, ktopToView)
    .leftSpaceToView(self.phoneNumView, kLeftToView)
    .autoHeightRatio(0.0f);
    [self.phoneNumLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.phoneNumSelectImage.sd_layout
    .leftSpaceToView(self.phoneNumLabel, kLeftToView)
    .centerYEqualToView(self.phoneNumLabel)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.phoneNumTextField.sd_layout
    .leftEqualToView(self.phoneNumLabel)
    .rightSpaceToView(self.phoneNumView, kLeftToView)
    .topSpaceToView(self.phoneNumLabel, ktopToView)
    .heightIs(kButtonHeight);
    [self.phoneNumView setupAutoHeightWithBottomView:self.phoneNumTextField bottomMargin:ktopToView];
    
    //融资阶段
    self.bondStageView.sd_layout
    .topSpaceToView(self.phoneNumView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.bondStageLabel.sd_layout
    .topSpaceToView(self.bondStageView, ktopToView)
    .leftSpaceToView(self.bondStageView, kLeftToView)
    .autoHeightRatio(0.0f);
    [self.bondStageLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.bondStageSelctImage.sd_layout
    .leftSpaceToView(self.bondStageLabel, kLeftToView)
    .centerYEqualToView(self.bondStageLabel)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.bondStageButtonView.sd_layout
    .leftSpaceToView(self.bondStageView, 0.0f)
    .rightSpaceToView(self.bondStageView, 0.0f)
    .topSpaceToView(self.bondStageLabel, ktopToView)
    .heightIs(kButtonHeight);
    
    [self.bondStageView setupAutoHeightWithBottomView:self.bondStageButtonView bottomMargin:ktopToView];
    
    //金额
    self.monenyView.sd_layout
    .topSpaceToView(self.bondStageView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.monenyLabel.sd_layout
    .topSpaceToView(self.monenyView, ktopToView)
    .leftSpaceToView(self.monenyView, kLeftToView)
    .autoHeightRatio(0.0f);
    [self.monenyLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.monenyTextField.sd_layout
    .leftEqualToView(self.monenyLabel)
    .topSpaceToView(self.phoneNumLabel, ktopToView)
    .widthIs(MarginFactor(212.0f))
    .heightIs(kButtonHeight);
    
    self.moneyMonad.sd_layout
    .leftSpaceToView(self.monenyTextField, kLeftToView)
    .centerYEqualToView(self.monenyTextField)
    .heightIs(MarginFactor(15.0f));
    [self.moneyMonad setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    [self.monenyView setupAutoHeightWithBottomView:self.monenyTextField bottomMargin:ktopToView];
    
    //地区
    self.areaView.sd_layout
    .topSpaceToView(self.monenyView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.areaTitleLabel.sd_layout
    .topSpaceToView(self.areaView, ktopToView)
    .leftSpaceToView(self.areaView, kLeftToView)
    .autoHeightRatio(0.0f);
    [self.areaTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.areaSelectImage.sd_layout
    .leftSpaceToView(self.areaTitleLabel, kLeftToView)
    .centerYEqualToView(self.areaTitleLabel)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.areaSelectButton.sd_layout
    .leftEqualToView(self.monenyLabel)
    .topSpaceToView(self.phoneNumLabel, ktopToView)
    .widthIs(MarginFactor(278.0f))
    .heightIs(kButtonHeight);
    
    self.areaNewSelectButton.sd_layout
    .topSpaceToView(self.areaTitleLabel, ktopToView)
    .leftSpaceToView(self.areaSelectButton, kLeftToView)
    .widthIs(MarginFactor(70.0f))
    .centerYEqualToView(self.areaSelectButton);
    
    
    [self.areaView setupAutoHeightWithBottomView:self.areaSelectButton bottomMargin:ktopToView];
    
    
    //意向行业
    self.industryView.sd_layout
    .topSpaceToView(self.areaView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.industryLabel.sd_layout
    .topSpaceToView(self.industryView, ktopToView)
    .leftSpaceToView(self.industryView, kLeftToView)
    .autoHeightRatio(0.0f);
    [self.industryLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.industrySelectImage.sd_layout
    .leftSpaceToView(self.industryLabel, kLeftToView)
    .centerYEqualToView(self.industryLabel)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.industrySelectButton.sd_layout
    .leftEqualToView(self.industryLabel)
    .rightSpaceToView(self.industryView, kLeftToView)
    .topSpaceToView(self.industryLabel, ktopToView)
    .heightIs(kButtonHeight);
    
    [self.industryView setupAutoHeightWithBottomView:self.industrySelectButton bottomMargin:ktopToView];
    
    [self.scrollView setupAutoHeightWithBottomView:self.industryView bottomMargin:0.0f];
    
}

- (void)initView
{
    self.nextButton.titleLabel.font = FontFactor(19.0f);
    [self.nextButton setTitleColor:Color(@"ffffff") forState:UIControlStateNormal];
    [self.nextButton setBackgroundColor:Color(@"f04241")];
    
    self.nameLabel.textColor = Color(@"161616");
    self.nameLabel.font = FontFactor(13.0f);
    
    self.phoneNumLabel.textColor = Color(@"161616");
    self.phoneNumLabel.font = FontFactor(13.0f);
    
    self.bondStageLabel.textColor = Color(@"161616");
    self.bondStageLabel.font = FontFactor(13.0f);
    
    self.monenyLabel.textColor = Color(@"161616");
    self.monenyLabel.font = FontFactor(13.0f);
    
    self.areaTitleLabel.textColor = Color(@"161616");
    self.areaTitleLabel.font = FontFactor(13.0f);
    
    self.industryLabel.textColor = Color(@"161616");
    self.industryLabel.font = FontFactor(13.0f);
    
    self.nameTextField.font = FontFactor(15.0f);
    self.nameTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 6.0f, 0.0f)];
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.nameTextField setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.phoneNumTextField.font = FontFactor(15.0f);
    self.phoneNumTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 6.0f, 0.0f)];
    self.phoneNumTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.phoneNumTextField setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.monenyTextField.font = FontFactor(15.0f);
    self.monenyTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 6.0f, 0.0f)];
    self.monenyTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.monenyTextField setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.moneyMonad.font = FontFactor(15.0f);
    self.moneyMonad.textColor = Color(@"161616");
    
    self.areaSelectButton.titleLabel.font = FontFactor(15.0f);
    [self.areaSelectButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
    self.areaNewSelectButton.titleLabel.font = FontFactor(15.0f);
    [self.areaNewSelectButton setTitleColor:Color(@"0078ee") forState:UIControlStateNormal];
    
    self.industrySelectButton.titleLabel.font = FontFactor(15.0f);
    [self.industrySelectButton setTitleColor:Color(@"bebebe") forState:UIControlStateNormal];
    [self.industrySelectButton setTitleColor:Color(@"161616") forState:UIControlStateSelected];
    
    self.nameTextField.layer.borderColor = Color(@"cecece").CGColor;
    self.nameTextField.layer.borderWidth = 0.5f;
    
    self.monenyTextField.layer.borderColor = Color(@"cecece").CGColor;
    self.monenyTextField.layer.borderWidth = 0.5f;
    
    self.phoneNumTextField.layer.borderColor = Color(@"cecece").CGColor;
    self.phoneNumTextField.layer.borderWidth = 0.5f;
    
    self.areaSelectButton.layer.borderColor = Color(@"cecece").CGColor;
    self.areaSelectButton.layer.borderWidth = 0.5f;
    self.areaSelectButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 0.0f);
    self.industrySelectButton.layer.borderColor = Color(@"cecece").CGColor;
    self.industrySelectButton.layer.borderWidth = 0.5f;
    self.industrySelectButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 0.0f);
    
    NSArray *marketCategoryArray = @[@"天使",@"PE/VC",@"定增并购",@"三板定增"];
    for (int i = 0; i < marketCategoryArray.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = FontFactor(15.0f);
        button.adjustsImageWhenHighlighted = NO;
        [button setTitle:[marketCategoryArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"marketSendButtonBg"] forState:UIControlStateNormal];
        button.frame = CGRectMake(kLeftToView + i * (kFourButtonWidth + kButtonLeftMargin), 0.0f, kFourButtonWidth, kCategoryButtonHeight);
        [button addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bondStageButtonView addSubview:button];
    }
    
}

- (void)categoryButtonClick:(UIButton *)btn
{
    if (!btn.selected) {
        [btn setTitleColor:Color(@"ff8d65") forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"marketSendButtonSelectBg"] forState:UIControlStateNormal];
    }
}


- (IBAction)nextButtonClick:(UIButton *)sender
{
    SHGEquityFinanceNextViewController *vc = [[SHGEquityFinanceNextViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
