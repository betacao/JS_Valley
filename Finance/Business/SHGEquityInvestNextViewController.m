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
#import "SHGBusinessButtonContentView.h"
#import "SHGBusinessManager.h"
#import "SHGBusinessListViewController.h"
@interface SHGEquityInvestNextViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
//资金来源
@property (strong, nonatomic) IBOutlet UIView *capitalSourceView;
@property (weak, nonatomic) IBOutlet UILabel *capitalSourceLabel;
@property (weak, nonatomic) IBOutlet SHGBusinessButtonContentView *capitalSourceButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *capitalSourceSelectImage;

//投资期限
@property (strong, nonatomic) IBOutlet UIView *investTimeView;
@property (weak, nonatomic) IBOutlet UILabel *investTimeTitleLabel;
@property (weak, nonatomic) IBOutlet SHGBusinessButtonContentView *timeButtonView;

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

@property (strong, nonatomic) UIButton *requireCurrentButton;

@property (strong, nonatomic) id currentContext;
@property (assign, nonatomic) BOOL hasImage;
@property (assign, nonatomic) CGFloat keyBoardOrginY;
@property (strong, nonatomic) SHGBusinessObject *obj;
@property (strong, nonatomic) NSString *imageName;

@end

@implementation SHGEquityInvestNextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapAction:)];
    [self.scrollView addGestureRecognizer:tap];

    if (((SHGEquityInvestSendViewController *)self.superController).object) {
        self.title = @"修改股权投资";
        ((SHGEquityInvestSendViewController *)self.superController).sendType = 1;
        self.obj = ((SHGEquityInvestSendViewController *)self.superController).object;
    } else{
        self.title = @"发布股权投资";
        ((SHGEquityInvestSendViewController *)self.superController).sendType = 0;
    }
    self.scrollView.delegate = self;
    self.retributionTextField.delegate = self;
    self.marketExplainTextView.delegate = self;
    self.capitalSourceButtonView.showMode = 1;
    self.timeButtonView.showMode = 2;
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
    [self editObject];

 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeText:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    .heightIs(ceilf(self.capitalSourceLabel.font.lineHeight));
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
    .heightIs(ceilf(self.retributionTitleLabel.font.lineHeight));
    [self.retributionTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.retributionTextField.sd_layout
    .leftEqualToView(self.retributionTitleLabel)
    .topSpaceToView(self.retributionTitleLabel, ktopToView)
    .widthIs(MarginFactor(212.0f))
    .heightIs(kButtonHeight);
    
    self.retributionNumLabel.sd_layout
    .leftSpaceToView(self.retributionTextField, kLeftToView)
    .centerYEqualToView(self.retributionTextField)
    .heightIs(ceilf(self.retributionNumLabel.font.lineHeight));
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
    .heightIs(ceilf(self.investTimeTitleLabel.font.lineHeight));
    [self.investTimeTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.timeButtonView.sd_layout
    .leftSpaceToView(self.investTimeView, 0.0f)
    .rightSpaceToView(self.investTimeView, 0.0f)
    .topSpaceToView(self.investTimeTitleLabel, ktopToView)
    .heightIs(kButtonHeight);
    
    [self.investTimeView setupAutoHeightWithBottomView:self.timeButtonView bottomMargin:ktopToView];
    //业务说明
    
    self.marketExplainView.sd_layout
    .topSpaceToView(self.investTimeView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.marketExplainTitleLabel.sd_layout
    .topSpaceToView(self.marketExplainView, ktopToView)
    .leftSpaceToView(self.marketExplainView, kLeftToView)
    .heightIs(ceilf(self.marketExplainTitleLabel.font.lineHeight));
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
    UIImage *addImage = [UIImage imageNamed:@"circle_plus"];
    CGSize addSize = addImage.size;
    
    self.addImageView.sd_layout
    .topSpaceToView(self.marketExplainView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.addImageTitleLabel.sd_layout
    .topSpaceToView(self.addImageView, ktopToView)
    .leftSpaceToView(self.addImageView, kLeftToView)
    .heightIs(ceilf(self.addImageTitleLabel.font.lineHeight));
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
    self.retributionTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.sureButton.titleLabel.font = FontFactor(19.0f);
    [self.sureButton setTitleColor:Color(@"ffffff") forState:UIControlStateNormal];
    [self.sureButton setBackgroundColor:Color(@"f04241")];
    CGFloat scale = [[UIScreen mainScreen] scale];
    self.retributionTextField.layer.borderColor = Color(@"cecece").CGColor;
    self.retributionTextField.layer.borderWidth = 1.0f / scale;

    self.marketExplainTextView.layer.borderColor = Color(@"cecece").CGColor;
    self.marketExplainTextView.layer.borderWidth = 1.0f / scale;
    self.marketExplainTextView.scrollEnabled = NO;
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
    
    NSArray *investTimeArray = @[@"不限",@"3年以内",@"3-5年",@"5年以上"];
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
        [self.timeButtonView addSubview:button];
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
- (void)editObject
{
    
    if (self.obj) {
        [self.sureButton setTitle:@"完成" forState:UIControlStateNormal];
        self.marketExplainTextView.text = self.obj.detail;
        if ([self.obj.anonymous isEqualToString:@"1"]) {
            self.authorizeButton.selected = YES;
        } else{
            self.authorizeButton.selected = NO;
        }
        
        if (self.obj.url && self.obj.url.length > 0) {
            self.hasImage = YES;
            __weak typeof(self) weakSelf = self;
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.obj.url]] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [weakSelf.addImageButton setImage:image forState:UIControlStateNormal];
            }];
        }
 
        NSString *result = [[SHGGloble sharedGloble] businessKeysForValues:self.obj.middleContent showEmptyKeys:YES];
        NSArray *nameArray = @[@"资金来源",@"参股比例",@"投资期限"];
        NSArray *resultArray = [result componentsSeparatedByString:@"\n"];
        NSMutableArray * array = [[SHGGloble sharedGloble] editBusinessKeysForValues:nameArray middleContentArray:resultArray];
        NSLog(@"%@", array);
        //资金来源
        NSString *sources = [array objectAtIndex:0];
        for (NSInteger i = 0; i < self.capitalSourceButtonView.buttonArray.count; i ++) {
            UIButton *button = [self.capitalSourceButtonView.buttonArray objectAtIndex:i];
            if ([button.titleLabel.text isEqualToString:sources]) {
                button.selected = YES;
            }
        }
     
        //投资期限
        NSString *investTime = [array objectAtIndex:2];
        if (investTime.length > 0) {
            NSArray *investArray = [investTime componentsSeparatedByString:@"，"];
            for (NSInteger i = 0; i < self.timeButtonView.buttonArray.count; i ++) {
                UIButton *button = [self.timeButtonView.buttonArray objectAtIndex:i];
                for (NSInteger j = 0; j < investArray.count; j ++) {
                    if ([button.titleLabel.text isEqualToString:[investArray objectAtIndex:j]]) {
                        button.selected = YES;
                    }
                }
            }
        }
        
        //参股比例
        NSString *number = [array objectAtIndex:1];
        self.retributionTextField.text = [[number componentsSeparatedByString:@"%"] firstObject];
        
        
    }
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

- (IBAction)authorizeButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (IBAction)sureButtonClick:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *businessDic = ((SHGEquityInvestSendViewController *)self.superController).firstDic;
    NSDictionary *businessSelectDic = [[SHGGloble sharedGloble] getBusinessKeysAndValues];
    [self uploadImage:^(BOOL success) {
        if (success) {
            switch (((SHGEquityInvestSendViewController *)weakSelf.superController).sendType) {
                    
                case 0:{
                    NSString *anonymous = weakSelf.authorizeButton.isSelected ? @"1" : @"0";
                    
                    NSString *type = [businessDic objectForKey:@"type"];
                    NSString *contact = [businessDic objectForKey:@"contact"];
                    NSString *investAmount = [businessDic objectForKey:@"investAmount"];
                    NSString *financingStage = [businessDic objectForKey:@"financingStage"];
                    NSString *area = [businessDic objectForKey:@"area"];
                    NSString *industry = [businessDic objectForKey:@"industry"];
                    NSString *title = [businessDic objectForKey:@"title"];
                    NSString *fundSource = [businessSelectDic objectForKey:[weakSelf.capitalSourceButtonView.selectedArray firstObject]];
                    NSString *vestYears = @"";
                    
                    if (weakSelf.timeButtonView.selectedArray.count == 0) {
                        vestYears = @"";
                    } else{
                        vestYears = [businessSelectDic objectForKey:[weakSelf.timeButtonView.selectedArray objectAtIndex:0]];
                        for (NSInteger i = 1 ;i < weakSelf.timeButtonView.selectedArray.count ; i ++) {
                            
                            vestYears = [NSString stringWithFormat:@"%@;%@",vestYears,[businessSelectDic objectForKey:[weakSelf.timeButtonView.selectedArray objectAtIndex:i]]];
                        }
                        
                    }

                    SHGBusinessObject *object = [[SHGBusinessObject alloc]init];
                    object.type = type;
                    NSDictionary *param = @{@"uid":UID, @"type": type, @"moneysideType": @"equityInvest",@"contact":contact,@"financingStage":financingStage, @"investAmount": investAmount, @"area": area, @"industry": industry,@"fundSource":fundSource ,@"totalshareRate":weakSelf.retributionTextField.text, @"vestYears": vestYears,@"detail": weakSelf.marketExplainTextView.text,@"photo": weakSelf.imageName,@"anonymous": anonymous,@"title": title};
                    [SHGBusinessManager createNewBusiness:param success:^(BOOL success) {
                        if (success) {
                            [[SHGBusinessListViewController sharedController] didCreateOrModifyBusiness:object];
                            [weakSelf.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:@(YES) afterDelay:1.2f];
                        }
                    }];
                }
                    break;
                    
                case 1:{
                    NSString *anonymous = weakSelf.authorizeButton.isSelected ? @"1" : @"0";
                    NSString *type = [businessDic objectForKey:@"type"];
                    NSString *contact = [businessDic objectForKey:@"contact"];
                    NSString *investAmount = [businessDic objectForKey:@"investAmount"];
                    NSString *businessId= self.obj.businessID;
                    NSString *financingStage = [businessDic objectForKey:@"financingStage"];
                    NSString *area = [businessDic objectForKey:@"area"];
                    NSString *industry = [businessDic objectForKey:@"industry"];
                    NSString *title = [businessDic objectForKey:@"title"];
                    NSString *fundSource = [businessSelectDic objectForKey:[weakSelf.capitalSourceButtonView.selectedArray firstObject]];
                    SHGBusinessObject *object = [[SHGBusinessObject alloc]init];
                    object.type = type;
                    NSString *vestYears = @"";
                    if (weakSelf.timeButtonView.selectedArray.count == 0) {
                        vestYears = @"";
                    } else{
                        vestYears = [businessSelectDic objectForKey:[weakSelf.timeButtonView.selectedArray objectAtIndex:0]];
                        for (NSInteger i = 1 ;i < weakSelf.timeButtonView.selectedArray.count ; i ++) {

                            vestYears = [NSString stringWithFormat:@"%@;%@",vestYears,[businessSelectDic objectForKey:[weakSelf.timeButtonView.selectedArray objectAtIndex:i]]];
                        }
                        
                    }
                    

                    NSDictionary *param = @{@"uid":UID, @"businessId":businessId,@"type": type, @"moneysideType": @"equityInvest",@"contact":contact,@"financingStage":financingStage, @"investAmount": investAmount, @"area": area, @"industry": industry,@"fundSource":fundSource ,@"totalshareRate":weakSelf.retributionTextField.text, @"vestYears": vestYears,@"detail": weakSelf.marketExplainTextView.text,@"photo": weakSelf.imageName,@"anonymous": anonymous,@"title": title};
                    NSLog(@"%@",param);
                    [SHGBusinessManager editBusiness:param success:^(BOOL success) {
                        if (success) {
                            [[SHGBusinessListViewController sharedController] didCreateOrModifyBusiness:object];
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
        [self.addImageButton setImage:[UIImage imageNamed:@"circle_plus"] forState:UIControlStateNormal];
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
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
    [self.currentContext becomeFirstResponder];
    self.currentContext = textView;
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
    CGPoint point = CGPointMake(0.0f, CGRectGetMidY(view.frame));
    point = [view.superview convertPoint:point toView:self.scrollView];
    point.y = MAX(0.0f, keyboardSize.height + point.y - CGRectGetHeight(self.view.frame));
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.scrollView setContentOffset:point animated:YES];
        
    });
}

- (void)textFieldDidChange:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    if ([textField isEqual:self.retributionTextField]) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
}

- (void)textViewDidChangeText:(NSNotification *)notification
{
    UITextView *textView = notification.object;
    if ([textView isEqual:self.marketExplainTextView]) {
        if (textView.text.length > 600) {
            textView.text = [textView.text substringToIndex:600];
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
