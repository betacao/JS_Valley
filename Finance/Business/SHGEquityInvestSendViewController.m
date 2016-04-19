//
//  SHGEquityInvestSendViewController.m
//  Finance
//
//  Created by weiqiankun on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGEquityInvestSendViewController.h"
#import "SHGEquityInvestNextViewController.h"
#import "SHGBusinessMargin.h"
#import "SHGBusinessSelectView.h"
#import "SHGBusinessButtonContentView.h"
#import "SHGBusinessLocationView.h"
#import "CCLocationManager.h"
@interface SHGEquityInvestSendViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
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

//投资阶段
@property (strong, nonatomic) IBOutlet UIView *bondStageView;
@property (weak, nonatomic) IBOutlet UILabel *bondStageLabel;
@property (weak, nonatomic) IBOutlet SHGBusinessButtonContentView *bondStageButtonView;
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

@property (strong, nonatomic) UIImage *buttonBgImage;
@property (strong, nonatomic) UIImage *buttonSelectBgImage;

@property (strong, nonatomic) id currentContext;
@property (assign, nonatomic) CGFloat keyBoardOrginY;
@property (strong, nonatomic) SHGEquityInvestNextViewController *equityInvestNextViewController;
@property (strong, nonatomic) SHGBusinessSelectView *selectViewController;
@property (strong, nonatomic) SHGBusinessLocationView *locationView;

@property (strong, nonatomic) NSMutableArray *industrySelectArray;
@property (strong, nonatomic) NSArray *editIndustryArray;
@end

@implementation SHGEquityInvestSendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapAction:)];
    [self.scrollView addGestureRecognizer:tap];
    if (self.object) {
        self.title = @"编辑股权投资";
        [self.areaSelectButton setTitle:self.object.area forState:UIControlStateNormal];
        [self.areaSelectButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        self.sendType = SHGEquityInvestSendTypeReSet;

    } else{
        self.title = @"发布股权投资";
        __weak typeof(self) weakSelf = self;
        [[CCLocationManager shareLocation] getCity:^{
            NSString * provinceName = [SHGGloble sharedGloble].provinceName;
            [weakSelf.areaSelectButton setTitle:provinceName forState:UIControlStateNormal];
            [weakSelf.areaSelectButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        }];
        self.sendType = SHGEquityInvestSendTypeNew;
    }
    self.scrollView.delegate = self;
    self.nameTextField.delegate = self;
    self.phoneNumTextField.delegate = self;
    self.monenyTextField.delegate = self;
    self.bondStageButtonView.showMode = 2;
    self.buttonBgImage = [UIImage imageNamed:@"business_SendButtonBg"];
    self.buttonBgImage = [self.buttonBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f) resizingMode:UIImageResizingModeStretch];
    
    self.buttonSelectBgImage = [UIImage imageNamed:@"business_SendButtonSelectBg"];
    self.buttonSelectBgImage = [self.buttonSelectBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f) resizingMode:UIImageResizingModeStretch];
    [self.scrollView addSubview:self.nameView];
    [self.scrollView addSubview:self.phoneNumView];
    [self.scrollView addSubview:self.bondStageView];
    [self.scrollView addSubview:self.monenyView];
    [self.scrollView addSubview:self.areaView];
    [self.scrollView addSubview:self.industryView];
    [self addSdLayout];
    [self initView];
    [self editObject];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    NSArray *array = self.bondStageButtonView.selectedArray;
    NSString *businesstype = [businessSelectDic objectForKey:[array firstObject]];
    
    for (NSInteger i = 1 ;i < array.count ; i++) {
        businesstype = [NSString stringWithFormat:@"%@;%@",businesstype,[businessSelectDic objectForKey:[array objectAtIndex:i]]];
        
    }
    
    //行业多选字段
    NSString *industry= @"";
    if (self.industrySelectArray.count > 0) {
        industry = [businessSelectDic objectForKey:[self.industrySelectArray objectAtIndex:0]];
        
        for (NSInteger i = 1 ;i < self.industrySelectArray.count ; i ++) {
            industry = [NSString stringWithFormat:@"%@;%@",industry,[businessSelectDic objectForKey:[self.industrySelectArray objectAtIndex:i]]];
        }

    } else {
        NSArray * array = [self.industrySelectButton.titleLabel.text componentsSeparatedByString:@"/"];
        industry = [businessSelectDic objectForKey:[array objectAtIndex:0]];
        
        for (NSInteger i = 1 ;i < array.count ; i ++) {
            industry = [NSString stringWithFormat:@"%@;%@",industry,[businessSelectDic objectForKey:[array objectAtIndex:i]]];
        }
    }
    
    dictionary = @{@"uid":UID, @"type": @"moneyside", @"contact": self.phoneNumTextField.text, @"investAmount": self.monenyTextField.text, @"area": self.areaSelectButton.titleLabel.text,@"industry":industry,@"title":self.nameTextField.text ,@"financingStage":businesstype};
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
    
    //联系电话
    self.phoneNumView.sd_layout
    .topSpaceToView(self.nameView, kLeftToView)
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
    
    //融资阶段
    self.bondStageView.sd_layout
    .topSpaceToView(self.phoneNumView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.bondStageLabel.sd_layout
    .topSpaceToView(self.bondStageView, ktopToView)
    .leftSpaceToView(self.bondStageView, kLeftToView)
    .heightIs(ceilf(self.bondStageLabel.font.lineHeight));
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
    .heightIs(MarginFactor(85.0f));
    
    [self.bondStageView setupAutoHeightWithBottomView:self.bondStageButtonView bottomMargin:ktopToView];
    
    //金额
    self.monenyView.sd_layout
    .topSpaceToView(self.bondStageView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.monenyLabel.sd_layout
    .topSpaceToView(self.monenyView, ktopToView)
    .leftSpaceToView(self.monenyView, kLeftToView)
    .heightIs(ceilf(self.monenyLabel.font.lineHeight));
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
    
    
    //意向行业
    self.industryView.sd_layout
    .topSpaceToView(self.areaView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.industryLabel.sd_layout
    .topSpaceToView(self.industryView, ktopToView)
    .leftSpaceToView(self.industryView, kLeftToView)
    .heightIs(ceilf(self.industryLabel.font.lineHeight));
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
    
    [self.scrollView setupAutoContentSizeWithBottomView:self.industryView bottomMargin:MarginFactor(50.0f)];
    
}


- (void)initView
{
    self.monenyTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
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
    
    NSArray *marketCategoryArray = @[@"不限",@"天使",@"PE/VC",@"定增并购",@"三板定增"];
    for (NSInteger i = 0; i < marketCategoryArray.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = FontFactor(15.0f);
        button.adjustsImageWhenHighlighted = NO;
        [button setTitle:[marketCategoryArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        [button setBackgroundImage:self.buttonBgImage forState:UIControlStateNormal];
        [button setTitleColor:Color(@"ff8d65") forState:UIControlStateSelected];
        [button setBackgroundImage:self.buttonSelectBgImage forState:UIControlStateSelected];

        button.frame = CGRectMake(kLeftToView + i%3 * (kThreeButtonWidth + kButtonLeftMargin), i/3 * (kButtonHeight + kButtonTopMargin), kThreeButtonWidth, kCategoryButtonHeight);
        [button addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bondStageButtonView addSubview:button];
    }
    
}

- (void)editObject
{
    if (self.object) {

        self.nameTextField.text = self.object.businessTitle;
        NSString *result = [[SHGGloble sharedGloble] businessKeysForValues:self.object.middleContent showEmptyKeys:YES];
        NSArray *nameArray = @[@"联系方式",@"投资阶段",@"金额",@"地区",@"意向行业"];
        NSArray *resultArray = [result componentsSeparatedByString:@"\n"];
        NSMutableArray * array = [[SHGGloble sharedGloble] editBusinessKeysForValues:nameArray middleContentArray:resultArray];
        NSLog(@"%@", array);
        //金额
        self.phoneNumTextField.text = [array objectAtIndex:4];
        
        NSString *money = [array objectAtIndex:1];
        if ([money isEqualToString:@"暂未说明"]) {
            self.monenyTextField.text = @"";
        } else{
            self.monenyTextField.text = [money substringWithRange:NSMakeRange(0, money.length - 2)];
        }
        
        //地区
        [self.areaSelectButton setTitle:[array objectAtIndex:2] forState:UIControlStateNormal];
        [self.areaSelectButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        
        //行业
        NSString *industry = [array objectAtIndex:3];
        NSArray *industryArray = [industry componentsSeparatedByString:@"，"];
        self.editIndustryArray = industryArray;
        for (NSInteger i = 1 ; i < industryArray.count ; i ++) {
            industry = [NSString stringWithFormat:@"%@/%@",[industryArray objectAtIndex:0],[industryArray objectAtIndex:i]];
        }
        [self.industrySelectButton setTitle:industry forState:UIControlStateNormal];
        [self.industrySelectButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        
        //投资阶段
        NSString *investTime = [array objectAtIndex:0];
        NSArray *investTimeArray = [investTime componentsSeparatedByString:@"，"];
        for (NSInteger i = 0; i < self.bondStageButtonView.buttonArray.count; i ++) {
            
            UIButton *button = [self.bondStageButtonView.buttonArray objectAtIndex:i];
            for (NSInteger j = 0; j < investTimeArray.count; j ++ ) {
                if ([button.titleLabel.text isEqualToString:[investTimeArray objectAtIndex:j]]) {
                    button.selected = YES;
                }
            }
            
        }
        
    }
}

- (void)categoryButtonClick:(UIButton *)btn
{
    SHGBusinessButtonContentView *superView = (SHGBusinessButtonContentView *)btn.superview;
    [superView didClickButton:btn];
}


- (IBAction)nextButtonClick:(UIButton *)sender
{
    if ([self checkInputMessage]) {

        if (!self.equityInvestNextViewController) {
            self.equityInvestNextViewController = [[SHGEquityInvestNextViewController alloc] init];
        }
        self.equityInvestNextViewController.superController = self;
        [self.navigationController pushViewController:self.equityInvestNextViewController animated:YES];

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
    if (self.bondStageButtonView.selectedArray.count == 0) {
        [Hud showMessageWithText:@"请选择投资阶段"];
        return NO;
    }
    if (self.areaSelectButton.titleLabel.text.length == 0) {
        [Hud showMessageWithText:@"请选择业务地区"];
        return NO;
    }
    if ([self.industrySelectButton.titleLabel.text isEqualToString:@"请选择行业"] ) {
        [Hud showMessageWithText:@"请填写意向行业"];
        return NO;
    }
    if ([self.industrySelectButton.titleLabel.text isEqualToString:@""] ) {
        [Hud showMessageWithText:@"请填写意向行业"];
        return NO;
    }
    NSString *string = [[SHGGloble sharedGloble] checkPhoneNumber:self.phoneNumTextField.text];
    if (string.length > 0) {
        [Hud showMessageWithText:string];
        return NO;
    }
    return YES;
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
- (IBAction)businessClick:(UIButton *)sender
{
    NSArray *array =  @[@"不限",@"金融投资",@"能源化工",@"TMT/互联网",@"地产基建",@"制造业",@"大健康",@"服务业",@"冶金采掘",@"农林牧渔",@"其他行业"];
    if (!self.selectViewController) {
        self.selectViewController = [[SHGBusinessSelectView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT) array:array statu:YES industryArray:self.editIndustryArray];
    }
    
    __weak typeof (self) weakSelf = self;
    self.selectViewController.returnTextBlock = ^(NSString *string, NSMutableArray *array){
        weakSelf.industrySelectArray = array;
        [weakSelf.industrySelectButton setTitle:string forState:UIControlStateNormal];
        [weakSelf.industrySelectButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
    };
    [self.view.window addSubview:self.selectViewController];
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
- (void)textFieldDidChange:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    if ([textField isEqual:self.nameTextField]) {
        if (textField.text.length > 40) {
            textField.text = [textField.text substringToIndex:40];
        }
    } else if ([textField isEqual:self.phoneNumTextField]) {
        if (textField.text.length > 20){
            textField.text = [textField.text substringToIndex:20];
        }
    } else if ([textField isEqual:self.monenyTextField]) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
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
