//
//  SHGBondFinancingSendNextViewController.m
//  Finance
//
//  Created by weiqiankun on 16/4/1.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBondInvestNextViewController.h"
#import "EMTextView.h"
#import "SHGBusinessMargin.h"
#import "UIButton+WebCache.h"
#import "SHGBusinessButtonContentView.h"
#import "SHGBusinessManager.h"
@interface SHGBondInvestNextViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
//增信要求
@property (strong, nonatomic) IBOutlet UIView *addRequireView;
@property (weak, nonatomic) IBOutlet UILabel *addRequireTitleLabel;
@property (weak, nonatomic) IBOutlet SHGBusinessButtonContentView *addRequireButtonView;
//最短退出年限
@property (strong, nonatomic) IBOutlet UIView *investTimeView;
@property (weak, nonatomic) IBOutlet UILabel *investTimeTitleLabel;
@property (weak, nonatomic) IBOutlet SHGBusinessButtonContentView *investTimeButtonView;
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

@property (assign, nonatomic) CGFloat keyBoardOrginY;
@property (strong, nonatomic) IBOutlet UIButton *authorizeButton;

@property (strong, nonatomic) UIImage *buttonBgImage;
@property (strong, nonatomic) UIImage *buttonSelectBgImage;

@property (strong, nonatomic) id currentContext;

@property (assign, nonatomic) BOOL hasImage;
@property (strong, nonatomic) NSString *imageName;

@property (strong, nonatomic) SHGBusinessObject *obj;
@property (strong, nonatomic) NSArray *clarifyingWaybuttonArray;
@end

@implementation SHGBondInvestNextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (((SHGBondInvestSendViewController *)self.superController).object) {
        self.title = @"修改债权投资";
        ((SHGBondInvestSendViewController *)self.superController).sendType = 1;
        self.obj = ((SHGBondInvestSendViewController *)self.superController).object;
        NSLog(@"%@",self.obj);
    } else{
        self.title = @"发布债权投资";
        ((SHGBondInvestSendViewController *)self.superController).sendType = 0;
    }
    self.hasImage = NO;
    self.scrollView.delegate = self;
    self.retributionTextField.delegate = self;
    self.marketExplainTextView.delegate = self;
    self.addRequireButtonView.showMode = 2;
    self.investTimeButtonView.showMode = 2;
    self.buttonBgImage = [UIImage imageNamed:@"business_SendButtonBg"];

    self.buttonBgImage = [self.buttonBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f) resizingMode:UIImageResizingModeStretch];
    
    self.buttonSelectBgImage = [UIImage imageNamed:@"business_SendButtonSelectBg"];
    self.buttonSelectBgImage = [self.buttonSelectBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f) resizingMode:UIImageResizingModeStretch];
    [self.scrollView addSubview:self.addRequireView];
    [self.scrollView addSubview:self.investTimeView];
    [self.scrollView addSubview:self.retributionView];
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
    
    self.addRequireButtonView.sd_layout
    .leftSpaceToView(self.addRequireView, 0.0f)
    .rightSpaceToView(self.addRequireView, 0.0f)
    .topSpaceToView(self.addRequireTitleLabel, ktopToView)
    .heightIs(MarginFactor(85.0f));
    
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
    
    //最短退出年限
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
    NSString *clarifyingWay = @"";//增信方式
    NSString *vestYears = @"";
    NSArray *clarifyingWayArray = [NSArray array];
    NSArray *vestYearsWayArray = [NSArray array];

    if (((SHGBondInvestSendViewController *)self.superController).sendType == 1) {
        self.marketExplainTextView.text = self.obj.detail;
        if ([self.obj.anonymous isEqualToString:@"1"]) {
            self.authorizeButton.selected = YES;
        } else{
            self.authorizeButton.selected = NO;
        }
        
        if (self.obj.photo && self.obj.photo.length > 0) {
            self.hasImage = YES;
            __weak typeof(self) weakSelf = self;
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.obj.photo]] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [weakSelf.addImageButton setImage:image forState:UIControlStateNormal];
            }];
        }
        
        clarifyingWay = self.obj.clarifyingWay;
        if (clarifyingWay.length == 0) {
            clarifyingWay = @"不限";
        } else{
            clarifyingWayArray = [clarifyingWay componentsSeparatedByString:@";"];
            
        }

        
        vestYears = self.obj.vestYears;
        if (vestYears.length == 0) {
             vestYears = @"不限";
        } else{
           vestYearsWayArray = [vestYears componentsSeparatedByString:@";"];
        }
        
        
    }
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

    NSArray *investTimeArray = @[@"不限",@"1年以内",@"1~3年",@"3年以上"];
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
        if (((SHGBondInvestSendViewController *)self.superController).sendType == 1) {
            if ([vestYears isEqualToString:@"不限"]) {
                if ([button.titleLabel.text isEqualToString:vestYears]) {
                    button.selected = YES;
                }
                
            } else{
                for (NSInteger i = 0; i < vestYearsWayArray.count; i ++) {
                    if ([button.titleLabel.text isEqualToString:[vestYearsWayArray objectAtIndex:i]]) {
                        button.selected = YES;
                    }
                }
            }
            
        }
        [button addTarget:self action:@selector(investTimeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.investTimeButtonView addSubview:button];
    }
    
    NSArray *addRequireArray = @[@"不限",@"抵押",@"质押",@"担保",@"信用"];
    for (NSInteger j = 0; j < addRequireArray.count; j ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = FontFactor(15.0f);
        button.adjustsImageWhenHighlighted = NO;
        [button setTitle:[addRequireArray objectAtIndex:j] forState:UIControlStateNormal];
        [button setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        [button setBackgroundImage:self.buttonBgImage forState:UIControlStateNormal];
        [button setTitleColor:Color(@"ff8d65") forState:UIControlStateSelected];
        [button setBackgroundImage:self.buttonSelectBgImage forState:UIControlStateSelected];
        button.frame = CGRectMake(kLeftToView + j%3 * (kThreeButtonWidth + kButtonLeftMargin), j/3 * (kButtonHeight + kButtonTopMargin), kThreeButtonWidth, kCategoryButtonHeight);
        if (((SHGBondInvestSendViewController *)self.superController).sendType == 1) {
            if ([clarifyingWay isEqualToString:@"不限"]) {
                if ([button.titleLabel.text isEqualToString:clarifyingWay]) {
                     button.selected = YES;
                }
               
            } else{
                for (NSInteger i = 0; i < clarifyingWayArray.count; i ++) {
                    if ([button.titleLabel.text isEqualToString:[clarifyingWayArray objectAtIndex:i]]) {
                        button.selected = YES;
                    }
                }
            }
            
        }
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
    [self.authorizeButton setImage:[UIImage imageNamed:@"business_authorizeUnselect"] forState:UIControlStateNormal];
    [self.authorizeButton setImage:[UIImage imageNamed:@"business_authorizeSelect"] forState:UIControlStateSelected];
    [self.authorizeButton setEnlargeEdgeWithTop:10.0f right:10.0f bottom:10.0f left:10.0f];
}

- (void)investTimeButtonClick:(UIButton *)btn
{
    SHGBusinessButtonContentView *superView = (SHGBusinessButtonContentView *)btn.superview;
    [superView didClickButton:btn];

}

- (void)addRequireButtonClick:(UIButton *)btn
{
    SHGBusinessButtonContentView *superView = (SHGBusinessButtonContentView *)btn.superview;
    [superView didClickButton:btn];
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
- (IBAction)authorizeButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (IBAction)sureButtonClick:(UIButton *)sender
{
    if ([self checkInputMessage]) {
        __weak typeof(self) weakSelf = self;
        NSDictionary *businessSelectDic = [[SHGGloble sharedGloble]getBusinessKeysAndValues];
        NSDictionary *businessDic = ((SHGBondInvestSendViewController *)weakSelf.superController).firstDic;
        [self uploadImage:^(BOOL success) {
            if (success) {
                switch (((SHGBondInvestSendViewController *)weakSelf.superController).sendType) {
                        
                    case 0:{
                        //增信选择字段
                        NSString *clarifyingRequire = @"";
                        if ([[weakSelf.addRequireButtonView.selectedArray objectAtIndex:0] isEqualToString:@"不限"]) {
                            clarifyingRequire = @"";
                        } else{
                            for (NSInteger i = 1 ;i < weakSelf.addRequireButtonView.selectedArray .count ; i ++) {
                                clarifyingRequire = [NSString stringWithFormat:@"%@;%@",[businessSelectDic objectForKey:[weakSelf.addRequireButtonView.selectedArray  objectAtIndex:0] ],[businessSelectDic objectForKey:[weakSelf.addRequireButtonView.selectedArray  objectAtIndex:i]]];
                            }
                            
                        }
                            //投资期限选择字段
                        NSString *vestYears = @"";
                        if ([[weakSelf.investTimeButtonView.selectedArray objectAtIndex:0] isEqualToString:@"不限"]) {
                            vestYears = @"";
                        } else{
                           // vestYears = [businessSelectDic objectForKey:vestYears];
                            for (NSInteger i = 1 ;i < weakSelf.investTimeButtonView.selectedArray.count ; i ++) {
                                vestYears = [NSString stringWithFormat:@"%@;%@",[businessSelectDic objectForKey:[weakSelf.investTimeButtonView.selectedArray objectAtIndex:0]],[businessSelectDic objectForKey:[weakSelf.investTimeButtonView.selectedArray objectAtIndex:i]]];
                            }

                        }
                        
                        NSString *anonymous = weakSelf.authorizeButton.isSelected ? @"1" : @"0";
                        SHGBusinessObject *object = [[SHGBusinessObject alloc]init];
                        NSString *type = [businessDic objectForKey:@"type"];
                        NSString *contact = [businessDic objectForKey:@"contact"];
                        NSString *investAmount = [businessDic objectForKey:@"investAmount"];
                        NSString *businessType = [businessDic objectForKey:@"businessType"];
                        NSString *fundSource = [businessDic objectForKey:@"fundSource"];
                        NSString *area = [businessDic objectForKey:@"area"];
                        NSString *industry = [businessDic objectForKey:@"industry"];
                        NSString *title = [businessDic objectForKey:@"title"];
                        NSString *moneysideType = @"bondInvest";
                        NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",type,contact,businessType,fundSource,investAmount,area,industry,clarifyingRequire,weakSelf.retributionTextField.text,vestYears,weakSelf.marketExplainTextView.text,weakSelf.imageName,anonymous,title);

                        NSDictionary *param = @{@"uid":UID, @"type": type, @"moneysideType":moneysideType ,@"contact":contact, @"businessType":businessType,@"fundSource":fundSource, @"investAmount": investAmount, @"area": area, @"industry": industry, @"clarifyingRequire":clarifyingRequire,@"lowestPaybackRate":weakSelf.retributionTextField.text, @"vestYears": vestYears,@"detail": weakSelf.marketExplainTextView.text,@"photo": weakSelf.imageName,@"anonymous": anonymous,@"title": title};
                        [SHGBusinessManager createNewBusiness:param success:^(BOOL success) {
                            if (success) {
                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didCreateNewBusiness:)]) {
                                    [weakSelf.delegate didCreateNewBusiness:object];
                                }
                                [weakSelf.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:@(YES) afterDelay:1.2f];
                            }
                        }];
                        
                    }
                        break;
                        
                    case 1:{
                        
                        //增信选择字段
                        //增信选择字段
                        NSString *clarifyingRequire = @"";
                        if ([[weakSelf.addRequireButtonView.selectedArray objectAtIndex:0] isEqualToString:@"不限"]) {
                            clarifyingRequire = @"";
                        } else{
                            for (NSInteger i = 1 ;i < weakSelf.addRequireButtonView.selectedArray .count ; i ++) {
                                clarifyingRequire = [NSString stringWithFormat:@"%@;%@",[businessSelectDic objectForKey:[weakSelf.addRequireButtonView.selectedArray  objectAtIndex:0] ],[businessSelectDic objectForKey:[weakSelf.addRequireButtonView.selectedArray  objectAtIndex:i]]];
                            }
                            
                        }
                        //投资期限选择字段
                        NSString *vestYears = @"";
                        if ([[weakSelf.investTimeButtonView.selectedArray objectAtIndex:0] isEqualToString:@"不限"]) {
                            vestYears = @"";
                        } else{
                            // vestYears = [businessSelectDic objectForKey:vestYears];
                            for (NSInteger i = 1 ;i < weakSelf.investTimeButtonView.selectedArray.count ; i ++) {
                                vestYears = [NSString stringWithFormat:@"%@;%@",[businessSelectDic objectForKey:[weakSelf.investTimeButtonView.selectedArray objectAtIndex:0]],[businessSelectDic objectForKey:[weakSelf.investTimeButtonView.selectedArray objectAtIndex:i]]];
                            }
                            
                        }
                        NSString * businessId = self.obj.businessID;
                        
                        NSString *anonymous = weakSelf.authorizeButton.isSelected ? @"1" : @"0";
                        //SHGBusinessObject *object = [[SHGBusinessObject alloc]init];
                        NSString *type = [businessDic objectForKey:@"type"];
                        NSString *contact = [businessDic objectForKey:@"contact"];
                        NSString *investAmount = [businessDic objectForKey:@"investAmount"];
                        NSString *businessType = [businessDic objectForKey:@"businessType"];
                        NSString *fundSource = [businessDic objectForKey:@"fundSource"];
                        NSString *area = [businessDic objectForKey:@"area"];
                        NSString *industry = [businessDic objectForKey:@"industry"];
                        NSString *title = [businessDic objectForKey:@"title"];
                        
                        
                        NSDictionary *param = @{@"uid":UID,@"businessId":businessId, @"type": type,@"moneysideType": @"bondInvest",@"contact":contact, @"businessType":businessType,@"fundSource":fundSource, @"investAmount": investAmount, @"area": area, @"industry": industry, @"clarifyingRequire":clarifyingRequire,@"lowestPaybackRate":self.retributionTextField.text, @"vestYears": vestYears,@"detail": weakSelf.marketExplainTextView.text,@"photo": weakSelf.imageName,@"anonymous": anonymous,@"title": title};
                        [SHGBusinessManager editBusiness:param success:^(BOOL success) {
                            if (success) {
                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didCreateNewBusiness:)]) {
                                    [weakSelf.delegate didCreateNewBusiness:self.obj];
                                }
                                [weakSelf.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:@(YES) afterDelay:1.2f];
                            }
                        }];
                        
                    }
                        
                        break;
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
        [self.addImageButton setImage:[UIImage imageNamed:@"addImageButton"] forState:UIControlStateNormal];
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
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGPoint keyboardOrigin = [value CGRectValue].origin;
    self.keyBoardOrginY = keyboardOrigin.y;
    UIView *view = (UIView *)self.currentContext;
    CGPoint point = CGPointMake(0.0f, CGRectGetMinX(view.frame));
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.scrollView setContentOffset:point animated:YES];
    });
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
