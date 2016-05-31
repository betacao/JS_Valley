//
//  SHGBusinessLocationViewController.m
//  Finance
//
//  Created by weiqiankun on 16/3/30.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessLocationViewController.h"
#import "SHGBusinessMargin.h"
#import "SHGBusinessManager.h"
#import "SHGBusinessListViewController.h"

@interface SHGBusinessLocationViewController ()
//topView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (strong, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UILabel *locationTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *locationBottonView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

//全国
@property (strong, nonatomic) IBOutlet UIView *municipalityView;
@property (weak, nonatomic) IBOutlet UIButton *nationWideButton;
@property (weak, nonatomic) IBOutlet UILabel *municipalityTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *municipalityBottomView;
@property (weak, nonatomic) IBOutlet UIView *municipalityButtonView;

//华东地区
@property (strong, nonatomic) IBOutlet UIView *eastChinaView;
@property (weak, nonatomic) IBOutlet UILabel *eastChinaTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *eastChinaButtonView;
@property (weak, nonatomic) IBOutlet UIView *eastChinaBottomView;
//华北地区
@property (strong, nonatomic) IBOutlet UIView *northChinaView;
@property (weak, nonatomic) IBOutlet UILabel *northChinaTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *northChinaButtonView;
@property (weak, nonatomic) IBOutlet UIView *northChinaBottomView;
//东北地区
@property (strong, nonatomic) IBOutlet UIView *northeastView;
@property (weak, nonatomic) IBOutlet UILabel *northeastTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *northeastButtonView;
@property (weak, nonatomic) IBOutlet UIView *northeastBottom;
//华南地区
@property (strong, nonatomic) IBOutlet UIView *southChinaView;
@property (weak, nonatomic) IBOutlet UILabel *southChinaTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *southChinaButtonView;
@property (weak, nonatomic) IBOutlet UIView *southChinaBottomView;
//华中地区
@property (strong, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UILabel *centerTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *centerButtonView;
@property (weak, nonatomic) IBOutlet UIView *centerBottomView;
//西南地区
@property (strong, nonatomic) IBOutlet UIView *southwestView;
@property (weak, nonatomic) IBOutlet UILabel *southwestTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *southwestButtonView;
@property (weak, nonatomic) IBOutlet UIView *southwestBottomView;
//西北地区
@property (strong, nonatomic) IBOutlet UIView *northwestView;
@property (weak, nonatomic) IBOutlet UILabel *northwestTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *northwestButtonView;
@property (weak, nonatomic) IBOutlet UIView *northwestBottomView;

@property (strong, nonatomic) NSArray *provinces;
@property (strong, nonatomic) NSMutableArray *allCity;
@property (strong, nonatomic) UIButton *locationCurrentButton;

@property (assign, nonatomic)  BOOL status;
@end

@implementation SHGBusinessLocationViewController
+ (instancetype)sharedController
{
    static SHGBusinessLocationViewController *sharedGlobleInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGlobleInstance = [[self alloc] init];
    });
    return sharedGlobleInstance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择地点";
    self.scrollView.backgroundColor = Color(@"efeeef");
    self.allCity = [NSMutableArray array];
    self.provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MarketArea" ofType:@"plist"]];
    [[self.provinces objectAtIndex:1] objectForKey:@"areas"];
    

    // [self.scrollView addSubview:self.locationView];
    [self.scrollView addSubview:self.municipalityView];
    [self.scrollView addSubview:self.eastChinaView];
    [self.scrollView addSubview:self.northChinaView];
    [self.scrollView addSubview:self.northeastView];
    [self.scrollView addSubview:self.southChinaView];
    [self.scrollView addSubview:self.centerView];
    [self.scrollView addSubview:self.southwestView];
    [self.scrollView addSubview:self.northwestView];
    [self addSdLayout];
    [self initView];

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
    
//    //topView
//    self.locationView.sd_layout
//    .topSpaceToView(self.scrollView, 0.0f)
//    .leftSpaceToView(self.scrollView, 0.0f)
//    .rightSpaceToView(self.scrollView, 0.0f);
//    
//    self.locationTitleLabel.sd_layout
//    .leftSpaceToView(self.locationView, MarginFactor(24.0f))
//    .topSpaceToView(self.locationView, 0.0f)
//    .heightIs(MarginFactor(50.0f))
//    .widthIs(MarginFactor(150.0f));
//    
//    self.locationButton.sd_layout
//    .rightSpaceToView(self.locationView, MarginFactor(17.0f))
//    .centerYEqualToView(self.locationTitleLabel)
//    .heightIs(MarginFactor(50.0f))
//    .widthIs(MarginFactor(150.0f));
//    
//    self.locationBottonView.sd_layout
//    .leftSpaceToView(self.locationView, 0.0f)
//    .rightSpaceToView(self.locationView, 0.0f)
//    .topSpaceToView(self.locationTitleLabel, 0.0f)
//    .heightIs(MarginFactor(12.0f));
//    
//    [self.locationView setupAutoHeightWithBottomView:self.locationBottonView bottomMargin:0.0f];
    //全国直辖市
 
    self.municipalityView.sd_layout
    .topSpaceToView(self.scrollView, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.nationWideButton.sd_layout
    .topSpaceToView(self.municipalityView, MarginFactor(15.0f))
    .leftSpaceToView(self.municipalityView, MarginFactor(12.0f))
    .widthIs(MarginFactor(111))
    .heightIs(MarginFactor(26.0f));
    
    self.municipalityTitleLabel.sd_layout
    .leftSpaceToView(self.municipalityView, MarginFactor(24.0f))
    .topSpaceToView(self.nationWideButton, MarginFactor(15.0f))
    .heightIs(ceilf(self.municipalityTitleLabel.font.lineHeight));
    [self.municipalityTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.municipalityButtonView.sd_layout
    .leftSpaceToView(self.municipalityView, 0.0f)
    .rightSpaceToView(self.municipalityView, 0.0f)
    .topSpaceToView(self.municipalityTitleLabel, MarginFactor(15.0f))
    .heightIs(82.0f);
    
    self.municipalityBottomView.sd_layout
    .leftSpaceToView(self.municipalityView, 0.0f)
    .rightSpaceToView(self.municipalityView, 0.0f)
    .heightIs(MarginFactor(12.0f))
    .topSpaceToView(self.municipalityButtonView, 0.0f);
    
    [self.municipalityView setupAutoHeightWithBottomView:self.municipalityBottomView bottomMargin:0.0f];
    
    //华东地区
    self.eastChinaView.sd_layout
    .topSpaceToView(self.municipalityView, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.eastChinaTitleLabel.sd_layout
    .leftSpaceToView(self.eastChinaView, MarginFactor(24.0f))
    .topSpaceToView(self.eastChinaView, MarginFactor(15.0f))
    .heightIs(ceilf(self.eastChinaTitleLabel.font.lineHeight));
    [self.eastChinaTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.eastChinaButtonView.sd_layout
    .topSpaceToView(self.eastChinaTitleLabel, MarginFactor(15.0f))
    .leftSpaceToView(self.eastChinaView, 0.0f)
    .rightSpaceToView(self.eastChinaView, 0.0f)
    .heightIs(MarginFactor(82.0f));
    
    self.eastChinaBottomView.sd_layout
    .leftSpaceToView(self.eastChinaView, 0.0f)
    .rightSpaceToView(self.eastChinaView, 0.0f)
    .heightIs(MarginFactor(12.0f))
    .topSpaceToView(self.eastChinaButtonView, 0.0f);
    
    [self.eastChinaView setupAutoHeightWithBottomView:self.eastChinaBottomView bottomMargin:0.0f];
    //华北地区
    self.northChinaView.sd_layout
    .topSpaceToView(self.eastChinaView, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.northChinaTitleLabel.sd_layout
    .leftSpaceToView(self.northChinaView, MarginFactor(24.0f))
    .topSpaceToView(self.northChinaView, MarginFactor(15.0f))
    .heightIs(ceilf(self.northChinaTitleLabel.font.lineHeight));
    [self.northChinaTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.northChinaButtonView.sd_layout
    .topSpaceToView(self.northChinaTitleLabel, MarginFactor(15.0f))
    .leftSpaceToView(self.northChinaView, 0.0f)
    .rightSpaceToView(self.northChinaView, 0.0f)
    .heightIs(MarginFactor(41.0f));
    
    self.northChinaBottomView.sd_layout
    .leftSpaceToView(self.northChinaView, 0.0f)
    .rightSpaceToView(self.northChinaView, 0.0f)
    .heightIs(MarginFactor(12.0f))
    .topSpaceToView(self.northChinaButtonView, 0.0f);
    
    [self.northChinaView setupAutoHeightWithBottomView:self.northChinaBottomView bottomMargin:0.0f];
    //东北地区
    self.northeastView.sd_layout
    .topSpaceToView(self.northChinaView, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.northeastTitleLabel.sd_layout
    .leftSpaceToView(self.northeastView, MarginFactor(24.0f))
    .topSpaceToView(self.northeastView, MarginFactor(15.0f))
    .heightIs(ceilf(self.northeastTitleLabel.font.lineHeight));
    [self.northeastTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.northeastButtonView.sd_layout
    .topSpaceToView(self.northeastTitleLabel, MarginFactor(15.0f))
    .leftSpaceToView(self.northeastView, 0.0f)
    .rightSpaceToView(self.northeastView, 0.0f)
    .heightIs(MarginFactor(41.0f));
    
    self.northeastBottom.sd_layout
    .leftSpaceToView(self.northeastView, 0.0f)
    .rightSpaceToView(self.northeastView, 0.0f)
    .heightIs(MarginFactor(12.0f))
    .topSpaceToView(self.northeastButtonView, 0.0f);

    [self.northeastView setupAutoHeightWithBottomView:self.northeastBottom bottomMargin:0.0f];
    
    //华南地区
    self.southChinaView.sd_layout
    .topSpaceToView(self.northeastView, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.southChinaTitleLabel.sd_layout
    .leftSpaceToView(self.southChinaView, MarginFactor(24.0f))
    .topSpaceToView(self.southChinaView, MarginFactor(15.0f))
    .heightIs(ceilf(self.southChinaTitleLabel.font.lineHeight));
    [self.southChinaTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.southChinaButtonView.sd_layout
    .topSpaceToView(self.southChinaTitleLabel, MarginFactor(15.0f))
    .leftSpaceToView(self.southChinaView, 0.0f)
    .rightSpaceToView(self.southChinaView, 0.0f)
    .heightIs(MarginFactor(41.0f));
    
    self.southChinaBottomView.sd_layout
    .leftSpaceToView(self.southChinaView, 0.0f)
    .rightSpaceToView(self.southChinaView, 0.0f)
    .heightIs(MarginFactor(12.0f))
    .topSpaceToView(self.southChinaButtonView, 0.0f);

     [self.southChinaView setupAutoHeightWithBottomView:self.southChinaBottomView bottomMargin:0.0f];
    //华中地区
    self.centerView.sd_layout
    .topSpaceToView(self.southChinaView, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.centerTitleLabel.sd_layout
    .leftSpaceToView(self.centerView, MarginFactor(24.0f))
    .topSpaceToView(self.centerView, MarginFactor(15.0f))
    .heightIs(ceilf(self.centerTitleLabel.font.lineHeight));
    [self.centerTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.centerButtonView.sd_layout
    .topSpaceToView(self.centerTitleLabel, MarginFactor(15.0f))
    .leftSpaceToView(self.centerView, 0.0f)
    .rightSpaceToView(self.centerView, 0.0f)
    .heightIs(MarginFactor(41.0f));
    
    self.centerBottomView.sd_layout
    .leftSpaceToView(self.centerView, 0.0f)
    .rightSpaceToView(self.centerView, 0.0f)
    .heightIs(MarginFactor(12.0f))
    .topSpaceToView(self.centerButtonView, 0.0f);

    [self.centerView setupAutoHeightWithBottomView:self.centerBottomView bottomMargin:0.0f];
    //西南地区
    self.southwestView.sd_layout
    .topSpaceToView(self.centerView, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.southwestTitleLabel.sd_layout
    .leftSpaceToView(self.southwestView, MarginFactor(24.0f))
    .topSpaceToView(self.southwestView, MarginFactor(15.0f))
    .heightIs(ceilf(self.southwestTitleLabel.font.lineHeight));
    [self.southwestTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.southwestButtonView.sd_layout
    .topSpaceToView(self.southwestTitleLabel, MarginFactor(15.0f))
    .leftSpaceToView(self.southwestView, 0.0f)
    .rightSpaceToView(self.southwestView, 0.0f)
    .heightIs(MarginFactor(82.0f));
    
    self.southwestBottomView.sd_layout
    .leftSpaceToView(self.southwestView, 0.0f)
    .rightSpaceToView(self.southwestView, 0.0f)
    .heightIs(MarginFactor(12.0f))
    .topSpaceToView(self.southwestButtonView, 0.0f);
    [self.southwestView setupAutoHeightWithBottomView:self.southwestBottomView bottomMargin:0.0f];
    
    //西北地区
    self.northwestView.sd_layout
    .topSpaceToView(self.southwestView, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);

    self.northwestTitleLabel.sd_layout
    .leftSpaceToView(self.northwestView, MarginFactor(24.0f))
    .topSpaceToView(self.northwestView, MarginFactor(15.0f))
    .heightIs(ceilf(self.northwestTitleLabel.font.lineHeight));
    [self.northwestTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.northwestButtonView.sd_layout
    .topSpaceToView(self.northwestTitleLabel, MarginFactor(15.0f))
    .leftSpaceToView(self.northwestView, 0.0f)
    .rightSpaceToView(self.northwestView, 0.0f)
    .heightIs(MarginFactor(82.0f));
    
    self.northwestBottomView.sd_layout
    .leftSpaceToView(self.northwestView, 0.0f)
    .rightSpaceToView(self.northwestView, 0.0f)
    .heightIs(MarginFactor(12.0f))
    .topSpaceToView(self.northwestButtonView, 0.0f);
    
    [self.northwestView setupAutoHeightWithBottomView:self.northwestBottomView bottomMargin:0.0f];
    
    [self.scrollView setupAutoHeightWithBottomView:self.northwestView bottomMargin:0.0f];
}

- (void)initView
{
    self.sureButton.titleLabel.font = FontFactor(19.0f);
    [self.sureButton setTitleColor:Color(@"ffffff") forState:UIControlStateNormal];
    [self.sureButton setBackgroundColor:Color(@"f04241")];
//    self.locationBottonView.backgroundColor = Color(@"efeeef");
    self.municipalityBottomView.backgroundColor = Color(@"efeeef");
    self.eastChinaBottomView.backgroundColor = Color(@"efeeef");
    self.northChinaBottomView.backgroundColor = Color(@"efeeef");
    self.northeastBottom.backgroundColor = Color(@"efeeef");
    self.southChinaBottomView.backgroundColor = Color(@"efeeef");
    self.centerBottomView.backgroundColor = Color(@"efeeef");
    self.southwestBottomView.backgroundColor = Color(@"efeeef");
    self.northwestBottomView.backgroundColor = Color(@"efeeef");
    self.municipalityTitleLabel.font = FontFactor(13.0f);
    self.municipalityTitleLabel.textColor = Color(@"858585");
    self.eastChinaTitleLabel.font = FontFactor(13.0f);
    self.eastChinaTitleLabel.textColor = Color(@"858585");
    self.northChinaTitleLabel.font = FontFactor(13.0f);
    self.northChinaTitleLabel.textColor = Color(@"858585");
    self.northeastTitleLabel.font = FontFactor(13.0f);
    self.northeastTitleLabel.textColor = Color(@"858585");
    self.southChinaTitleLabel.font = FontFactor(13.0f);
    self.southChinaTitleLabel.textColor = Color(@"858585");
    self.centerTitleLabel.font = FontFactor(13.0f);
    self.centerTitleLabel.textColor = Color(@"858585");
    self.southwestTitleLabel.font = FontFactor(13.0f);
    self.southwestTitleLabel.textColor = Color(@"858585");
    self.northwestTitleLabel.font = FontFactor(13.0f);
    self.northwestTitleLabel.textColor = Color(@"858585");
    
//    self.locationTitleLabel.font = FontFactor(16.0f);
//    self.locationTitleLabel.textColor = Color(@"161616");
//    
//    self.locationButton.titleLabel.font = FontFactor(15.0f);
//    [self.locationButton setTitle:@"重新定位" forState:UIControlStateNormal];
//    [self.locationButton setTitleColor:Color(@"2b7fdc") forState:UIControlStateNormal];
    self.nationWideButton.titleLabel.font = FontFactor(14.0f);
    [self.nationWideButton setBackgroundImage:[[UIImage imageNamed:@"locationButtonBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [self.nationWideButton setBackgroundImage:[[UIImage imageNamed:@"locationButtonBgHighlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
    [self.nationWideButton setTitleColor:Color(@"161616") forState:UIControlStateNormal];
    [self.nationWideButton setTitleColor:Color(@"f33300") forState:UIControlStateSelected];
    [self.nationWideButton addTarget:self action:@selector(locationButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    
    
    NSArray *locationArry = @[self.municipalityButtonView,self.eastChinaButtonView,self.northChinaButtonView,self.northeastButtonView,self.southChinaButtonView,self.centerButtonView,self.southwestButtonView,self.northwestButtonView,self.eastChinaButtonView];
    
    if ([self.locationString isEqualToString:@"全国"]) {
        self.nationWideButton.selected = YES;
        self.locationCurrentButton = self.nationWideButton;
        
    }
    for (NSInteger j = 0 ; j < self.provinces.count; j ++)
    {
        for (NSInteger i = 0; i < [[[self.provinces objectAtIndex:j] objectForKey:@"areas"] count]; i ++)
        {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:[NSString stringWithFormat:@"%@",[[[self.provinces objectAtIndex:j] objectForKey:@"areas"] objectAtIndex:i]] forState:UIControlStateNormal];
            button.titleLabel.font = FontFactor(14.0f);
            button.adjustsImageWhenHighlighted = NO;
            [button setBackgroundImage:[[UIImage imageNamed:@"locationButtonBg"]resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch ]forState:UIControlStateNormal];
            [button setBackgroundImage:[[UIImage imageNamed:@"locationButtonBgHighlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
            [button setTitleColor:Color(@"161616") forState:UIControlStateNormal];
            [button setTitleColor:Color(@"f33300") forState:UIControlStateSelected];
            [button addTarget:self action:@selector(locationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            if ([button.titleLabel.text isEqualToString:self.locationString]) {
                button.selected = YES;
                self.locationCurrentButton = button;
            }
            button.frame = CGRectMake(MarginFactor(12.0f) + i%3 * (kLocationButtonLeftMargin + kLocationButtonWidth), i/3 * (kLocationButtonTopMargin + kLocationButtonHeight), kLocationButtonWidth, kLocationButtonHeight);
            [[locationArry objectAtIndex:j] addSubview:button];
        }

    }
}

- (void)locationButtonClick:(UIButton *)btn
{
    if(btn != self.locationCurrentButton){
        self.locationCurrentButton.selected = NO;
        self.locationCurrentButton = btn;
        self.locationString = self.locationCurrentButton.titleLabel.text;
    }
    self.locationCurrentButton.selected = YES;
}

- (IBAction)sureButtonClick:(UIButton *)sender
{
    [[SHGGloble sharedGloble] recordUserAction:self.locationString type:@"business_search_city"];
    [SHGBusinessManager shareManager].cityName = self.locationString;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
