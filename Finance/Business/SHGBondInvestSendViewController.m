//
//  SHGBondFinancingSendViewController.m
//  Finance
//
//  Created by weiqiankun on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBondInvestSendViewController.h"
#import "SHGBondInvestNextViewController.h"
#import "SHGBusinessMargin.h"
#import "SHGBusinessSelectView.h"
#import "SHGBusinessLocationView.h"
#import "SHGBusinessButtonContentView.h"
#import "CCLocationManager.h"
#import "SHGBusinessLocationViewController.h"
@interface SHGBondInvestSendViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate>
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

//业务类型
@property (strong, nonatomic) IBOutlet UIView *marketCategoryView;
@property (weak, nonatomic) IBOutlet UILabel *marketCategoryLabel;
@property (weak, nonatomic) IBOutlet SHGBusinessButtonContentView *marketCategoryButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *marketCategorySelctImage;

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

//资金来源
@property (strong, nonatomic) IBOutlet UIView *capitalSourceView;
@property (weak, nonatomic) IBOutlet UILabel *capitalSourceLabel;
@property (weak, nonatomic) IBOutlet SHGBusinessButtonContentView *capitalSourceButtonView;

@property (strong, nonatomic) UIImage *buttonBgImage;
@property (strong, nonatomic) UIImage *buttonSelectBgImage;

@property (strong, nonatomic) id currentContext;
@property (assign, nonatomic) CGFloat keyBoardOrginY;
@property (strong, nonatomic) SHGBondInvestNextViewController *bondInvestNextViewController;
@property (strong, nonatomic) SHGBusinessLocationView *locationView;
@property (strong, nonatomic) SHGBusinessSelectView *selectViewController;


@property (strong, nonatomic) NSMutableArray *industrySelectArray;
@property (strong, nonatomic) NSString *moneyButtonString;
@property (strong, nonatomic) NSArray *editIndustryArray;
@end

@implementation SHGBondInvestSendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    self.nameTextField.delegate = self;
    self.phoneNumTextField.delegate = self;
    self.monenyTextField.delegate = self;

    
    if (self.object) {
        self.title = @"编辑债权投资";
        self.sendType = 1;
        [self.areaSelectButton setTitle:self.object.area forState:UIControlStateNormal];
        [self.areaSelectButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
    } else{
        self.title = @"发布债权投资";
        __weak typeof(self) weakSelf = self;
        [[CCLocationManager shareLocation] getCity:^{
            NSString * provinceName = [SHGGloble sharedGloble].provinceName;
            [weakSelf.areaSelectButton setTitle:provinceName forState:UIControlStateNormal];
             [weakSelf.areaSelectButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        }];
        self.sendType = 0;
    }
    self.marketCategoryButtonView.showMode = 2;
    self.capitalSourceButtonView.showMode = 1;

    
    self.buttonBgImage = [[UIImage imageNamed:@"business_SendButtonBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f) resizingMode:UIImageResizingModeStretch];
    
    self.buttonSelectBgImage = [[UIImage imageNamed:@"business_SendButtonSelectBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f) resizingMode:UIImageResizingModeStretch];
    
    [self.scrollView addSubview:self.nameView];
    [self.scrollView addSubview:self.phoneNumView];
    [self.scrollView addSubview:self.marketCategoryView];
    [self.scrollView addSubview:self.monenyView];
    [self.scrollView addSubview:self.areaView];
    [self.scrollView addSubview:self.industryView];
    [self.scrollView addSubview:self.capitalSourceView];
    [self addSdLayout];
    [self initView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)industrySelectArray
{
    if (!_industrySelectArray) {
        _industrySelectArray = [[NSMutableArray alloc] init];
    }
    return _industrySelectArray;
}

- (NSArray *)editIndustryArray
{
    if (!_editIndustryArray) {
        _editIndustryArray = [[NSArray alloc] init];
    }
    return _editIndustryArray;
}
- (NSDictionary *)firstDic
{
    NSDictionary *dictionary = [NSDictionary dictionary];
    
    NSDictionary *businessSelectDic = [[SHGGloble sharedGloble] getBusinessKeysAndValues];
    //行业多选字段
    
    if (self.capitalSourceButtonView.selectedArray.count > 0) {
       self.moneyButtonString = [self.capitalSourceButtonView.selectedArray objectAtIndex:0];
    } else{
        
        self.moneyButtonString = @"";
    }
    
    NSString *industry = [businessSelectDic objectForKey:[self.industrySelectArray objectAtIndex:0]];
    if ([[self.industrySelectArray objectAtIndex:0] isEqualToString:@"不限"]) {
        industry = @"";
    } else{
        for (NSInteger i = 1 ;i < self.industrySelectArray.count ; i ++) {
            industry = [NSString stringWithFormat:@"%@;%@",industry,[businessSelectDic objectForKey:[self.industrySelectArray objectAtIndex:i]]];
        }
        
    }
    NSArray *array = [self.marketCategoryButtonView selectedArray];
    //业务类型多选字段
    NSString *businesstype = [businessSelectDic objectForKey:[array firstObject]];
    if ([[array firstObject] isEqualToString:@"不限"]) {
        businesstype = @"";
    } else{
        for (NSInteger i = 1 ;i < array.count ; i++) {
            businesstype = [NSString stringWithFormat:@"%@;%@",businesstype,[businessSelectDic objectForKey:[array objectAtIndex:i]]];
        }
    }
    
    dictionary = @{@"uid":UID, @"type": @"moneyside", @"contact": self.phoneNumTextField.text, @"investAmount": self.monenyTextField.text, @"area": self.areaSelectButton.titleLabel.text, @"industry":industry ,@"title":self.nameTextField.text ,@"businessType":businesstype,@"fundSource":self.moneyButtonString};
    return dictionary;
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

    //业务类型
    self.marketCategoryView.sd_layout
    .topSpaceToView(self.phoneNumView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.marketCategoryLabel.sd_layout
    .topSpaceToView(self.marketCategoryView, ktopToView)
    .leftSpaceToView(self.marketCategoryView, kLeftToView)
    .autoHeightRatio(0.0f);
    [self.marketCategoryLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.marketCategorySelctImage.sd_layout
    .leftSpaceToView(self.marketCategoryLabel, kLeftToView)
    .centerYEqualToView(self.marketCategoryLabel)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.marketCategoryButtonView.sd_layout
    .leftSpaceToView(self.marketCategoryView, 0.0f)
    .rightSpaceToView(self.marketCategoryView, 0.0f)
    .topSpaceToView(self.marketCategoryLabel, ktopToView)
    .heightIs(MarginFactor(36.0f));
    
    [self.marketCategoryView setupAutoHeightWithBottomView:self.marketCategoryButtonView bottomMargin:ktopToView];
    
    //金额
    self.monenyView.sd_layout
    .topSpaceToView(self.marketCategoryView, kLeftToView)
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
    .heightRatioToView(self.areaSelectButton, 1.0f);
    
    
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

    //资金来源
    self.capitalSourceView.sd_layout
    .topSpaceToView(self.industryView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.capitalSourceLabel.sd_layout
    .topSpaceToView(self.capitalSourceView, ktopToView)
    .leftSpaceToView(self.capitalSourceView, kLeftToView)
    .autoHeightRatio(0.0f);
    [self.capitalSourceLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.capitalSourceButtonView.sd_layout
    .leftSpaceToView(self.capitalSourceView, 0.0f)
    .rightSpaceToView(self.capitalSourceView, 0.0f)
    .topSpaceToView(self.capitalSourceLabel, ktopToView)
    .heightIs(MarginFactor(36.0f));
    
    [self.capitalSourceView setupAutoHeightWithBottomView:self.capitalSourceButtonView bottomMargin:ktopToView];
    
    [self.scrollView setupAutoHeightWithBottomView:self.capitalSourceView bottomMargin:0.0f];
    
}

- (void)initView
{
    NSString *bondType = @"";
    NSString *source = @"";
    NSString *industry = @"";
    NSArray *bondTypeArray = [NSArray array];
    NSArray *key = [[[SHGGloble sharedGloble] getBusinessKeysAndValues] allKeys];
    NSArray *value = [[[SHGGloble sharedGloble] getBusinessKeysAndValues] allValues];
    if (self.sendType == 1) {
        self.nameTextField.text = self.object.businessTitle;
        self.phoneNumTextField.text = self.object.contact;
        self.monenyTextField.text = self.object.investAmount;
        bondType = self.object.bondType;
        source = self.object.fundSource;
        if (source.length > 0) {
            source = [key objectAtIndex:[value indexOfObject:source]];
        } else{
            source = @"";
        }
        
        if(bondType.length == 0){
            bondType = @"不限";
        } else{
            bondTypeArray = [self.object.bondType componentsSeparatedByString:@";"];

        }
        
        industry = self.object.industry;
        if (industry.length > 0) {
            NSArray *industryArray = [industry componentsSeparatedByString:@";"];
            self.editIndustryArray = industryArray;
            NSString * str = [key objectAtIndex:[value indexOfObject:[industryArray objectAtIndex:0]]];
            for (NSInteger  i = 0; i < industryArray.count ; i ++ ) {
                str = [NSString stringWithFormat:@"%@/%@",str,[key objectAtIndex:[value indexOfObject:[industryArray objectAtIndex:i]]]];
            }
            
            [self.industrySelectButton setTitle:str forState:UIControlStateNormal];
            [self.industrySelectButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        } else{
            [self.industrySelectButton setTitle:@"不限" forState:UIControlStateNormal];
            [self.industrySelectButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        }

       
        
   }
    self.monenyTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.nextButton.titleLabel.font = FontFactor(19.0f);
    [self.nextButton setTitleColor:Color(@"ffffff") forState:UIControlStateNormal];
    [self.nextButton setBackgroundColor:Color(@"f04241")];

    self.nameLabel.textColor = Color(@"161616");
    self.nameLabel.font = FontFactor(13.0f);
    
    self.phoneNumLabel.textColor = Color(@"161616");
    self.phoneNumLabel.font = FontFactor(13.0f);
    
    self.marketCategoryLabel.textColor = Color(@"161616");
    self.marketCategoryLabel.font = FontFactor(13.0f);
    
    self.monenyLabel.textColor = Color(@"161616");
    self.monenyLabel.font = FontFactor(13.0f);
    
    self.areaTitleLabel.textColor = Color(@"161616");
    self.areaTitleLabel.font = FontFactor(13.0f);
    
    self.industryLabel.textColor = Color(@"161616");
    self.industryLabel.font = FontFactor(13.0f);
    
    self.capitalSourceLabel.textColor = Color(@"161616");
    self.capitalSourceLabel.font = FontFactor(13.0f);
    
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
    NSArray *marketCategoryArray = @[@"不限",@"企业",@"平台",@"证券"];
    for (NSInteger i = 0; i < marketCategoryArray.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = FontFactor(15.0f);
        button.adjustsImageWhenHighlighted = NO;
        [button setTitle:[marketCategoryArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        [button setBackgroundImage:self.buttonBgImage forState:UIControlStateNormal];
        [button setTitleColor:Color(@"ff8d65") forState:UIControlStateSelected];
        [button setBackgroundImage:self.buttonSelectBgImage forState:UIControlStateSelected];

        if ([bondType isEqualToString:@"不限"]) {
            if ([button.titleLabel.text isEqualToString:bondType]) {
                button.selected = YES;
            }
        } else{
            for (NSInteger i = 0 ; i < bondTypeArray.count; i ++ ) {
                
                NSString *str = [key objectAtIndex:[value indexOfObject:[bondTypeArray objectAtIndex:i]]];
                if ([button.titleLabel.text isEqualToString:str]) {
                    button.selected = YES;
                }
            }
            
        }
        button.frame = CGRectMake(kLeftToView + i * (kFourButtonWidth + kButtonLeftMargin), 0.0f, kFourButtonWidth, kCategoryButtonHeight);
        [button addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.marketCategoryButtonView addSubview:button];
    }
    
    NSArray *moneoyOriginArray = @[@"个人资金",@"企业资金",@"金融机构"];
    for (NSInteger j = 0; j < moneoyOriginArray.count; j ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = FontFactor(15.0f);
        button.adjustsImageWhenHighlighted = NO;
        [button setTitle:[moneoyOriginArray objectAtIndex:j] forState:UIControlStateNormal];
        [button setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        [button setBackgroundImage:self.buttonBgImage forState:UIControlStateNormal];
        [button setTitleColor:Color(@"ff8d65") forState:UIControlStateSelected];
        [button setBackgroundImage:self.buttonSelectBgImage forState:UIControlStateSelected];
        if ([button.titleLabel.text isEqualToString:source]) {
            button.selected = YES;
        }
        button.frame = CGRectMake(kLeftToView + j * (kThreeButtonWidth + kButtonLeftMargin), 0.0f, kThreeButtonWidth, kCategoryButtonHeight);
        NSLog(@"1111111%f",kThreeButtonWidth);
        [button addTarget:self action:@selector(capitalButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.capitalSourceButtonView addSubview:button];
    }
}


- (void)categoryButtonClick:(UIButton *)btn
{
    SHGBusinessButtonContentView *superView = (SHGBusinessButtonContentView *)btn.superview;
    [superView didClickButton:btn];
}

- (IBAction)locationSelectClick:(UIButton *)sender
{
    if (!self.locationView) {
        self.locationView = [[SHGBusinessLocationView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT) locationString:self.areaSelectButton.titleLabel.text];
    }
    __weak typeof (self)weakSelf = self;
    self.locationView.returnLocationBlock = ^(NSString *string){
        [weakSelf.areaSelectButton setTitle:string forState:UIControlStateNormal];
        [weakSelf.areaSelectButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
    };
    [self.view.window addSubview:self.locationView];

}

- (void)capitalButtonClick:(UIButton *)btn
{
    SHGBusinessButtonContentView *superView = (SHGBusinessButtonContentView *)btn.superview;
    [superView didClickButton:btn];

}


- (IBAction)businessClick:(UIButton *)sender
{
    NSArray *array =  @[@"不限",@"金融投资",@"能源化工",@"互联网",@"地产基建",@"制造业",@"大健康",@"TMT",@"服务业",@"冶金采掘",@"农林牧渔",@"其他行业"];

    if (!self.selectViewController) {
        self.selectViewController = [[SHGBusinessSelectView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT) array:array statu:YES industryArray:self.editIndustryArray];
        }
    __weak typeof(self)weakSelf = self;
    weakSelf.selectViewController.returnTextBlock = ^(NSString *string, NSMutableArray *array){
        weakSelf.industrySelectArray = array;
        weakSelf.industrySelectButton.titleLabel.text = string;
        [weakSelf.industrySelectButton setTitle:string forState:UIControlStateNormal];
        [weakSelf.industrySelectButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
    };
    [self.view.window addSubview:self.selectViewController];
}


- (IBAction)nextButtonClick:(UIButton *)sender
{
    [self.currentContext resignFirstResponder];
    if ([self checkInputMessage]) {
        if (!self.bondInvestNextViewController) {
            self.bondInvestNextViewController = [[SHGBondInvestNextViewController alloc] init];
        }
        self.bondInvestNextViewController.superController = self;
        [self.navigationController pushViewController:self.bondInvestNextViewController animated:YES];
    }
}

- (BOOL)checkInputMessage
{
    if (self.nameTextField.text.length == 0) {
        [Hud showMessageWithText:@"请填写业务名称"];
        return NO;
    }
    if (self.phoneNumTextField.text.length == 0) {
        [Hud showMessageWithText:@"请填写联系方式"];
        return NO;
    }
    if ([self.marketCategoryButtonView selectedArray].count == 0) {
        [Hud showMessageWithText:@"请选择业务类型"];
        return NO;
    }
    if (self.areaSelectButton.titleLabel.text.length == 0) {
        [Hud showMessageWithText:@"请选择业务地区"];
        return NO;
    }
    if (self.industrySelectArray.count == 0 || [self.industrySelectButton.titleLabel.text isEqualToString:@"请选择行业"]) {
        [Hud showMessageWithText:@"请填写意向行业"];
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


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     [self.currentContext resignFirstResponder];
}

- (void)keyBoardDidShow:(NSNotification *)notificaiton
{
    NSDictionary* info = [notificaiton userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGPoint keyboardOrigin = [value CGRectValue].origin;
    self.keyBoardOrginY = keyboardOrigin.y;
    UIView *view = (UIView *)self.currentContext;
    CGPoint point = CGPointMake(0.0f, CGRectGetMinX(view.frame));
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.scrollView setContentOffset:point animated:YES];
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
