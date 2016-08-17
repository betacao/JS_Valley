//
//  SHGSameAndCommixtureSendViewController.m
//  Finance
//
//  Created by weiqiankun on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGSameAndCommixtureSendViewController.h"
#import "SHGSameAndCommixtureNextViewController.h"
#import "SHGBusinessMargin.h"
#import "SHGBusinessLocationView.h"
#import "SHGBusinessButtonContentView.h"
#import "CCLocationManager.h"
#import "SHGForbidCopyTextField.h"
#import "SHGCitySelectViewController.h"
#import "SHGCompanyManager.h"
#import "SHGCompanyObject.h"
#import "SHGCompanyDisplayViewController.h"


@interface SHGSameAndCommixtureSendViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
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

//业务公司名称
@property (strong, nonatomic) IBOutlet UIView *businessCompanyNameView;
@property (weak, nonatomic) IBOutlet UIImageView *companyNameImage;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *companyNametextField;

//业务类型
@property (strong, nonatomic) IBOutlet UIView *marketCategoryView;
@property (weak, nonatomic) IBOutlet UILabel *marketCategoryLabel;
@property (weak, nonatomic) IBOutlet SHGBusinessButtonContentView *marketCategoryButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *marketCategorySelctImage;

//金额
@property (strong, nonatomic) IBOutlet UIView *monenyView;
@property (weak, nonatomic) IBOutlet UILabel *monenyLabel;
@property (weak, nonatomic) IBOutlet SHGForbidCopyTextField *monenyTextField;
@property (weak, nonatomic) IBOutlet UILabel *moneyMonad;
@property (weak, nonatomic) IBOutlet SHGForbidCopyTextField *leftMoneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *leftMoneyMonad;

//地区
@property (strong, nonatomic) IBOutlet UIView *areaView;
@property (weak, nonatomic) IBOutlet UIButton *areaSelectButton;
@property (weak, nonatomic) IBOutlet UIImageView *areaSelectImage;
@property (weak, nonatomic) IBOutlet UILabel *areaTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *areaNewSelectButton;

@property (strong, nonatomic) UIImage *buttonBgImage;
@property (strong, nonatomic) UIImage *buttonSelectBgImage;

@property (strong, nonatomic) id currentContext;
@property (assign, nonatomic) CGFloat keyBoardOrginY;
@property (strong, nonatomic) SHGSameAndCommixtureNextViewController *sameAndCommixtureNextViewController;
@property (strong, nonatomic) SHGBusinessLocationView *locationView;

@property (strong, nonatomic) SHGCitySelectViewController*selectCityViewController;
@end

@implementation SHGSameAndCommixtureSendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapAction:)];
    [self.scrollView addGestureRecognizer:tap];
    if (self.object) {
        self.title = @"编辑银证业务";
        self.sendType = 1;
        self.companyNametextField.text = self.object.businessCompanyName;
        if ([self.object.position isEqualToString:self.object.cityName]) {
            [self.areaSelectButton setTitle:self.object.cityName forState:UIControlStateNormal];
        } else{
            [self.areaSelectButton setTitle:[NSString stringWithFormat:@"%@ %@",self.object.position,self.object.cityName] forState:UIControlStateNormal];
        }
        [self.areaSelectButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
    } else{
        self.title = @"发布银证业务";
        self.sendType = SHGSameAndCommixtureSendTypeNew;
        WEAK(self, weakSelf);
        weakSelf.companyNametextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_COMPANYNAME];
        __block NSString *provineceName = @"";
        __block NSString *cityName = @"";
        if ([[SHGGloble sharedGloble].provinceName isEqualToString:@""]) {
            [[CCLocationManager shareLocation] getCity:^{
                provineceName = [SHGGloble sharedGloble].provinceName;
                cityName = [SHGGloble sharedGloble].cityName;
                if ([provineceName isEqualToString:cityName]) {
                    [weakSelf.areaSelectButton setTitle:cityName forState:UIControlStateNormal];
                } else{
                    [weakSelf.areaSelectButton setTitle:[NSString stringWithFormat:@"%@ %@",provineceName,cityName] forState:UIControlStateNormal];
                }
                [weakSelf.areaSelectButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
            }];
        } else{
            provineceName = [SHGGloble sharedGloble].provinceName;
            cityName = [SHGGloble sharedGloble].cityName;
            if ([provineceName isEqualToString:cityName]) {
                [weakSelf.areaSelectButton setTitle:cityName forState:UIControlStateNormal];
            } else{
                [weakSelf.areaSelectButton setTitle:[NSString stringWithFormat:@"%@ %@",provineceName,cityName] forState:UIControlStateNormal];
            }
            [weakSelf.areaSelectButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        }
    }
    self.scrollView.delegate = self;
    self.nameTextField.delegate = self;
    self.phoneNumTextField.delegate = self;
    self.monenyTextField.delegate = self;
    self.leftMoneyTextField.delegate = self;
    self.marketCategoryButtonView.showMode = SHGBusinessButtonShowModeMultipleChoice;
    self.buttonBgImage = [UIImage imageNamed:@"business_SendButtonBg"];
    self.buttonBgImage = [self.buttonBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f) resizingMode:UIImageResizingModeStretch];
    
    self.buttonSelectBgImage = [UIImage imageNamed:@"business_SendButtonSelectBg"];
    self.buttonSelectBgImage = [self.buttonSelectBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f) resizingMode:UIImageResizingModeStretch];
    [self.scrollView addSubview:self.nameView];
    [self.scrollView addSubview:self.phoneNumView];
    [self.scrollView addSubview:self.businessCompanyNameView];
    [self.scrollView addSubview:self.marketCategoryView];
    [self.scrollView addSubview:self.monenyView];
    [self.scrollView addSubview:self.areaView];
    [self addSdLayout];
    [self initView];
    [self editObject];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (NSDictionary *)firstDic
{
    NSDictionary *dictonary = [NSDictionary dictionary];
    NSDictionary *businessSelectDic = [[SHGGloble sharedGloble] getBusinessKeysAndValues];
    NSArray *array = [self.marketCategoryButtonView selectedArray];
    //业务类型多选字段
    NSString *businessType = [businessSelectDic objectForKey:[array objectAtIndex:0]];
    for (NSInteger i = 1 ;i < array.count ; i++) {
        businessType = [NSString stringWithFormat:@"%@;%@",businessType,[businessSelectDic objectForKey:[array objectAtIndex:i]]];
    }
    NSInteger leftTextFieldString = [self.leftMoneyTextField.text  integerValue];
    NSInteger rightTextFieldString = [self.monenyTextField.text integerValue];
    NSInteger  money=10000 * leftTextFieldString + rightTextFieldString;
    NSLog(@"%@",businessType);
    dictonary = @{@"uid":UID, @"type": @"trademixed", @"contact": self.phoneNumTextField.text, @"investAmount": [NSString stringWithFormat:@"%ld",money], @"area":self.areaSelectButton.titleLabel.text,@"title":self.nameTextField.text ,@"businessType":businessType,@"companyName":self.companyNametextField.text};

    return dictonary;
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
    .heightIs(ceilf(self.nameLabel.font.lineHeight));
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
    
    //公司名称
    self.businessCompanyNameView.sd_layout
    .topSpaceToView(self.nameView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.companyNameLabel.sd_layout
    .topSpaceToView(self.businessCompanyNameView, ktopToView)
    .leftSpaceToView(self.businessCompanyNameView, kLeftToView)
    .heightIs(ceilf(self.companyNameLabel.font.lineHeight));
    [self.companyNameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.companyNameImage.sd_layout
    .leftSpaceToView(self.companyNameLabel, kLeftToView)
    .centerYEqualToView(self.companyNameLabel)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.companyNametextField.sd_layout
    .leftEqualToView(self.companyNameLabel)
    .rightSpaceToView(self.businessCompanyNameView, kLeftToView)
    .topSpaceToView(self.companyNameLabel, ktopToView)
    .heightIs(kCategoryButtonHeight);
    
    
    [self.businessCompanyNameView setupAutoHeightWithBottomView:self.companyNametextField bottomMargin:ktopToView];
    

    //联系电话
    self.phoneNumView.sd_layout
    .topSpaceToView(self.businessCompanyNameView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.phoneNumLabel.sd_layout
    .topSpaceToView(self.phoneNumView, ktopToView)
    .leftSpaceToView(self.phoneNumView, kLeftToView)
    .heightIs(ceilf(self.phoneNumLabel.font.lineHeight));
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
    .heightIs(ceilf(self.marketCategoryLabel.font.lineHeight));
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
    .heightIs(3 * kButtonHeight + 2 * kButtonTopMargin);
    
    [self.marketCategoryView setupAutoHeightWithBottomView:self.marketCategoryButtonView bottomMargin:ktopToView];
    
    //金额
    self.monenyView.sd_layout
    .topSpaceToView(self.marketCategoryView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.monenyLabel.sd_layout
    .topSpaceToView(self.monenyView, ktopToView)
    .leftSpaceToView(self.monenyView, kLeftToView)
    .heightIs(ceilf(self.monenyLabel.font.lineHeight));
    [self.monenyLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    
    self.leftMoneyTextField.sd_layout
    .leftEqualToView(self.monenyLabel)
    .topSpaceToView(self.monenyLabel, ktopToView)
    .widthIs(MarginFactor(96.0f))
    .heightIs(kCategoryButtonHeight);
    
    self.leftMoneyMonad.sd_layout
    .leftSpaceToView(self.leftMoneyTextField, MarginFactor(12.0f))
    .centerYEqualToView(self.leftMoneyTextField)
    .heightIs(MarginFactor(15.0f));
    [self.leftMoneyMonad setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.monenyTextField.sd_layout
    .leftSpaceToView(self.leftMoneyMonad, MarginFactor(12.0f))
    .centerYEqualToView(self.leftMoneyTextField)
    .widthIs(MarginFactor(96.0f))
    .heightIs(kCategoryButtonHeight);
    
    self.moneyMonad.sd_layout
    .leftSpaceToView(self.monenyTextField, kLeftToView)
    .centerYEqualToView(self.monenyTextField)
    .heightIs(MarginFactor(15.0f));
    [self.moneyMonad setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    [self.monenyView setupAutoHeightWithBottomView:self.leftMoneyTextField bottomMargin:ktopToView];
    
    //地区
    self.areaView.sd_layout
    .topSpaceToView(self.monenyView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.areaTitleLabel.sd_layout
    .topSpaceToView(self.areaView, ktopToView)
    .leftSpaceToView(self.areaView, kLeftToView)
    .heightIs(ceilf(self.areaTitleLabel.font.lineHeight));
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
    
    //[self.scrollView setupAutoHeightWithBottomView:self.areaView bottomMargin:0.0f];
    [self.scrollView setupAutoContentSizeWithBottomView:self.areaView bottomMargin:MarginFactor(55.0f)];
    
}

- (void)editObject
{
    if (self.object) {
        
        self.nameTextField.text = self.object.businessTitle;
        NSString *result = [[SHGGloble sharedGloble] businessKeysForValues:self.object.middleContent showEmptyKeys:YES];
        NSArray *nameArray = @[@"联系方式",@"类型",@"金额",@"地区"];
        NSArray *resultArray = [result componentsSeparatedByString:@"\n"];
        NSMutableArray * array = [[SHGGloble sharedGloble] editBusinessKeysForValues:nameArray middleContentArray:resultArray];
        NSLog(@"%@", array);
        //金额
        self.phoneNumTextField.text = [array objectAtIndex:3];
        
//        NSString *money = [array objectAtIndex:1];
//        NSString *str = [money substringWithRange:NSMakeRange(money.length - 1, 1)];
//        if ([money isEqualToString:@"暂未说明"]) {
//            self.monenyTextField.text = @"";
//        } else if ([str isEqualToString:@"亿"]){
//            self.monenyTextField.text = [[money substringToIndex:money.length - 1] stringByAppendingString:@"0000"];
//        } else{
//            self.monenyTextField.text = [money substringWithRange:NSMakeRange(0, money.length - 1)];
//        }
        NSInteger money = [self.object.investmoney integerValue];
        NSString *leftText= [NSString stringWithFormat:@"%ld",money/10000];
        NSString *rightText= [NSString stringWithFormat:@"%ld",money%10000];
        if (![leftText isEqualToString:@"0"]) {
            self.leftMoneyTextField.text = leftText;
        } else{
            self.leftMoneyTextField.text = @"";
        }
        
        if ([rightText isEqualToString:@"0"]) {
            self.monenyTextField.text = @"";
        } else{
            self.monenyTextField.text = rightText;
        }
        
        //地区
        [self.areaSelectButton setTitle:[array objectAtIndex:2] forState:UIControlStateNormal];
        [self.areaSelectButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        //类型
        NSString *category = [array objectAtIndex:0];
        NSArray *marketCategoryArray = [category componentsSeparatedByString:@"，"];
        for (NSInteger i = 0; i < self.marketCategoryButtonView.buttonArray.count; i ++) {
            UIButton *button = [self.marketCategoryButtonView.buttonArray objectAtIndex:i];
            for (NSInteger j = 0; j < marketCategoryArray.count; j ++ ) {
                if ([button.titleLabel.text isEqualToString:[marketCategoryArray objectAtIndex:j]]) {
                    button.selected = YES;
                }
            }
            
        }

//        for (NSInteger i = 0; i < self.marketCategoryButtonView.buttonArray.count; i ++) {
//            UIButton *button = [self.marketCategoryButtonView.buttonArray objectAtIndex:i];
//            if ([button.titleLabel.text isEqualToString:category]) {
//                button.selected = YES;
//            }
//        }
//        
    }
}
- (void)initView
{
    self.companyNameLabel.textColor = Color(@"161616");
    self.companyNameLabel.font = FontFactor(13.0f);
    self.companyNametextField.font = FontFactor(15.0f);
    self.companyNametextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 6.0f, 0.0f)];
    self.companyNametextField.leftViewMode = UITextFieldViewModeAlways;
    [self.companyNametextField setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];

    self.leftMoneyTextField.keyboardType = self.monenyTextField.keyboardType = UIKeyboardTypeNumberPad;
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
    
    self.nameTextField.font = FontFactor(15.0f);
    self.nameTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 6.0f, 0.0f)];
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.nameTextField setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.phoneNumTextField.font = FontFactor(15.0f);
    self.phoneNumTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 6.0f, 0.0f)];
    self.phoneNumTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.phoneNumTextField setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.leftMoneyTextField.font = self.monenyTextField.font = FontFactor(15.0f);
    self.monenyTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 6.0f, 0.0f)];
    self.leftMoneyTextField.leftViewMode = self.monenyTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.monenyTextField setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    self.leftMoneyTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 6.0f, 0.0f)];
    [self.leftMoneyTextField setValue:[UIColor colorWithHexString:@"bebebe"] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.leftMoneyMonad.font = self.moneyMonad.font = FontFactor(15.0f);
    self.leftMoneyMonad.textColor = self.moneyMonad.textColor = Color(@"161616");
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    self.areaSelectButton.titleLabel.font = FontFactor(15.0f);
    [self.areaSelectButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
    self.areaNewSelectButton.titleLabel.font = FontFactor(15.0f);
    [self.areaNewSelectButton setTitleColor:Color(@"0078ee") forState:UIControlStateNormal];
    self.companyNametextField.layer.borderColor = Color(@"cecece").CGColor;
    self.companyNametextField.layer.borderWidth = 1.0 / scale;
    self.nameTextField.layer.borderColor = Color(@"cecece").CGColor;
    self.nameTextField.layer.borderWidth = 1.0f / scale;
    
    self.leftMoneyTextField.layer.borderColor = self.monenyTextField.layer.borderColor = Color(@"cecece").CGColor;
    self.leftMoneyTextField.layer.borderWidth = self.monenyTextField.layer.borderWidth = 1.0f / scale;
    
    self.phoneNumTextField.layer.borderColor = Color(@"cecece").CGColor;
    self.phoneNumTextField.layer.borderWidth = 1.0f / scale;
    
    self.areaSelectButton.layer.borderColor = Color(@"cecece").CGColor;
    self.areaSelectButton.layer.borderWidth = 1.0f / scale;
    self.areaSelectButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 0.0f);
     NSArray *marketCategoryArray = @[@"票据类",@"债券类",@"理财&资产类",@"委投&通道类",@"质押融资&配资类",@"同业拆借&存款类"];
    for (NSInteger i = 0; i < marketCategoryArray.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = FontFactor(15.0f);
        button.adjustsImageWhenHighlighted = NO;
        [button setTitle:[marketCategoryArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        [button setBackgroundImage:self.buttonBgImage forState:UIControlStateNormal];
        [button setTitleColor:Color(@"ff8d65") forState:UIControlStateSelected];
        [button setBackgroundImage:self.buttonSelectBgImage forState:UIControlStateSelected];

        button.frame = CGRectMake(kLeftToView + i%2 * (kTwoButtonWidth + kButtonLeftMargin), i/2 * (kButtonHeight + kButtonTopMargin), kTwoButtonWidth, kCategoryButtonHeight);
        [button addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.marketCategoryButtonView addSubview:button];
    }
    
}

- (void)categoryButtonClick:(UIButton *)btn
{
    SHGBusinessButtonContentView *superView = (SHGBusinessButtonContentView *)btn.superview;
    [superView didClickButton:btn];

}

- (IBAction)locationSelectClick:(UIButton *)sender
{
    if (!self.selectCityViewController) {
        self.selectCityViewController = [[SHGCitySelectViewController alloc] init];
    }
    WEAK(self, weakSelf);
    weakSelf.selectCityViewController.returnCityBlock = ^(NSString *string){
        [weakSelf.areaSelectButton setTitle:string forState:UIControlStateNormal];
    };
    self.selectCityViewController.superController = self;
    [self.navigationController pushViewController:self.selectCityViewController animated:YES];
}

- (IBAction)nextButtonClick:(UIButton *)sender
{
    if ([self checkInputMessage]) {
        void(^block)(void) = ^() {
            if (!self.sameAndCommixtureNextViewController) {
                self.sameAndCommixtureNextViewController = [[SHGSameAndCommixtureNextViewController alloc] init];
            }
            self.sameAndCommixtureNextViewController.superController = self;
            [self.navigationController pushViewController:self.sameAndCommixtureNextViewController animated:YES];
        };
        WEAK(self, weakSelf);
        [SHGCompanyManager loadBlurCompanyInfo:@{@"companyName":self.companyNametextField.text, @"page":@(1), @"pageSize":@(10)} success:^(NSArray *array) {
            if (array.count == 0) {
                SHGAlertView *alertView = [[SHGAlertView alloc] initWithTitle:@"请确认公司名称" contentText:@"您输入的公司名称没有查询到，是否继续？" leftButtonTitle:@"取消" rightButtonTitle:@"确认"];
                alertView.rightBlock = block;
                [alertView show];
            } else if (array.count == 1) {
                SHGCompanyObject *object = [array firstObject];
                weakSelf.companyNametextField.text = object.companyName;
                block();
            } else {
                SHGCompanyDisplayViewController *controller = [[SHGCompanyDisplayViewController alloc] init];
                controller.companyName = weakSelf.companyNametextField.text;
                WEAK(controller, weakController);
                controller.block = ^(NSString *companyName){
                    weakSelf.companyNametextField.text = companyName;
                    [weakController.navigationController popViewControllerAnimated:YES];
                };
                [self.navigationController pushViewController:controller animated:YES];
            }
        }];
    }
}

- (void)btnBackClick:(id)sender
{
    [self.currentContext resignFirstResponder];
    WEAK(self, weakSelf);
    if ([weakSelf checkInputEmpty]) {
    SHGAlertView *alertView = [[SHGAlertView alloc] initWithTitle:@"提示" contentText:@"退出此次编辑?" leftButtonTitle:@"取消" rightButtonTitle:@"退出"];
    alertView.rightBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [alertView show];
    } else{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)checkInputEmpty
{
    if (self.nameTextField.text.length == 0 && self.phoneNumTextField.text.length == 0 && [self.marketCategoryButtonView selectedArray].count == 0 && self.monenyTextField.text.length == 0  && self.leftMoneyTextField.text.length == 0 ){
        return NO;
    } else{
        return YES;
    }
}


- (BOOL)checkInputMessage
{
    if (self.nameTextField.text.length == 0) {
        [Hud showMessageWithText:@"请填写业务名称"];
        return NO;
    } else if (self.nameTextField.text.length > 20){
        [Hud showMessageWithText:@"业务名称最多可输入20个字"];
        return NO;
    }
    if (self.companyNametextField.text.length == 0 ) {
        [Hud showMessageWithText:@"请填写公司名称"];
        return NO;
    }
    if (self.phoneNumTextField.text.length == 0) {
        [Hud showMessageWithText:@"请填写联系方式"];
        return NO;
    }
    if (self.companyNametextField.text.length == 0) {
        [Hud showMessageWithText:@"请填写公司名称"];
        return NO;
    }
    if (self.marketCategoryButtonView.selectedArray.count == 0) {
        [Hud showMessageWithText:@"请选择业务类型"];
        return NO;
    }
    if (self.areaSelectButton.titleLabel.text.length == 0) {
        [Hud showMessageWithText:@"请选择业务地区"];
        return NO;
    }
    NSString *string = [[SHGGloble sharedGloble] checkPhoneNumber:self.phoneNumTextField.text];
    if (string.length > 0) {
        [Hud showMessageWithText:string];
        return NO;
    }
  
    return YES;
}


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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.leftMoneyTextField || textField == self.monenyTextField) {
        if (string.length == 0) {
            return YES;
        }
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (range.location > 1 && [toBeString floatValue] > 9999) {
            [Hud showMessageWithText:@"抱歉，您输入的数字不可超过9999"];
            return NO;
        }
    }
    
    return YES;
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
    CGPoint point = CGPointMake(0.0f, CGRectGetMinY(view.frame) + kNavigationBarHeight);
    point = [view.superview convertPoint:point toView:self.scrollView];
    point.y = MAX(0.0f, keyboardSize.height + point.y - CGRectGetHeight(self.view.frame));
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.scrollView setContentOffset:point animated:YES];
        
    });
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
