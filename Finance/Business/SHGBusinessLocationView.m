//
//  SHGBusinessLocationView.m
//  Finance
//
//  Created by weiqiankun on 16/4/12.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessLocationView.h"
#import "SHGBusinessMargin.h"
#import "CCLocationManager.h"
@interface SHGBusinessLocationView ()

//topView
@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic)  UIButton *quiteButton;
@property (strong, nonatomic)  UIView *locationView;
@property (strong, nonatomic)  UILabel *locationTitleLabel;
@property (strong, nonatomic)  UIView *locationBottonView;
@property (strong, nonatomic)  UIButton *locationButton;

//全国
@property (strong, nonatomic)  UIView *municipalityView;
@property (strong, nonatomic)  UILabel *municipalityTitleLabel;
@property (strong, nonatomic)  UIView *municipalityBottomView;
@property (strong, nonatomic)  UIView *municipalityButtonView;

//华东地区
@property (strong, nonatomic)  UIView *eastChinaView;
@property (strong, nonatomic)  UILabel *eastChinaTitleLabel;
@property (strong, nonatomic)  UIView *eastChinaButtonView;
@property (strong, nonatomic)  UIView *eastChinaBottomView;
//华北地区
@property (strong, nonatomic)  UIView *northChinaView;
@property (strong, nonatomic)  UILabel *northChinaTitleLabel;
@property (strong, nonatomic)  UIView *northChinaButtonView;
@property (strong, nonatomic)  UIView *northChinaBottomView;
//东北地区
@property (strong, nonatomic)  UIView *northeastView;
@property (strong, nonatomic)  UILabel *northeastTitleLabel;
@property (strong, nonatomic)  UIView *northeastButtonView;
@property (strong, nonatomic)  UIView *northeastBottom;
//华南地区
@property (strong, nonatomic)  UIView *southChinaView;
@property (strong, nonatomic)  UILabel *southChinaTitleLabel;
@property (strong, nonatomic)  UIView *southChinaButtonView;
@property (strong, nonatomic)  UIView *southChinaBottomView;
//华中地区
@property (strong, nonatomic)  UIView *centerView;
@property (strong, nonatomic)  UILabel *centerTitleLabel;
@property (strong, nonatomic)  UIView *centerButtonView;
@property (strong, nonatomic)  UIView *centerBottomView;
//西南地区
@property (strong, nonatomic)  UIView *southwestView;
@property (strong, nonatomic)  UILabel *southwestTitleLabel;
@property (strong, nonatomic)  UIView *southwestButtonView;
@property (strong, nonatomic)  UIView *southwestBottomView;
//西北地区
@property (strong, nonatomic)  UIView *northwestView;
@property (strong, nonatomic)  UILabel *northwestTitleLabel;
@property (strong, nonatomic)  UIView *northwestButtonView;
@property (strong, nonatomic)  UIView *northwestBottomView;

@property (strong, nonatomic) NSArray *provinces;
@property (strong, nonatomic) NSMutableArray *allCity;
@property (strong, nonatomic) UIButton *locationCurrentButton;

@end
@implementation SHGBusinessLocationView


- (instancetype)initWithFrame:(CGRect)frame locationString:(NSString *)locationString
{
    if (self = [super initWithFrame:frame]) {
        self.allCity = [NSMutableArray array];
        self.provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MarketArea" ofType:@"plist"]];
        [[self.provinces objectAtIndex:1] objectForKey:@"areas"];
        self.scrollView.backgroundColor = Color(@"efeeef");
        [self addSubview:self.scrollView];
        [self addSubview:self.quiteButton];
        [self.scrollView addSubview:self.locationView];
        [self.scrollView addSubview:self.municipalityView];
        [self.scrollView addSubview:self.eastChinaView];
        [self.scrollView addSubview:self.northChinaView];
        [self.scrollView addSubview:self.northeastView];
        [self.scrollView addSubview:self.southChinaView];
        [self.scrollView addSubview:self.centerView];
        [self.scrollView addSubview:self.southwestView];
        [self.scrollView addSubview:self.northwestView];
        
        self.locationTitleLabel.text = locationString;
        [self addSdLayout];
        [self initView];
    }
    return self;
}

- (void)addSdLayout
{
    UIImage *image = [UIImage imageNamed:@"business_quit"];
    CGSize imageSize = image.size;

    self.scrollView.sd_layout
    .topSpaceToView(self, 0.0f)
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .bottomSpaceToView(self,0.0f);
    
    self.quiteButton.sd_layout
    .centerXIs(SCREENWIDTH / 2.0f)
    .bottomSpaceToView(self, MarginFactor(20.0f))
    .widthIs(imageSize.width)
    .heightIs(imageSize.height);
    
    //topView
    self.locationView.sd_layout
    .topSpaceToView(self.scrollView, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f)
    .heightIs(MarginFactor(62.0f));
    
    self.locationTitleLabel.sd_layout
    .leftSpaceToView(self.locationView, MarginFactor(24.0f))
    .topSpaceToView(self.locationView, 0.0f)
    .heightIs(MarginFactor(50.0f))
    .widthIs(MarginFactor(150.0f));
    
    self.locationButton.sd_layout
    .rightSpaceToView(self.locationView, MarginFactor(17.0f))
    .centerYEqualToView(self.locationTitleLabel)
    .heightIs(MarginFactor(50.0f))
    .widthIs(MarginFactor(100.0f));
    
    self.locationBottonView.sd_layout
    .leftSpaceToView(self.locationView, 0.0f)
    .rightSpaceToView(self.locationView, 0.0f)
    .topSpaceToView(self.locationTitleLabel, 0.0f)
    .heightIs(MarginFactor(12.0f));
    

    //全国直辖市
    
    self.municipalityView.sd_layout
    .topSpaceToView(self.locationView, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);

    self.municipalityTitleLabel.sd_layout
    .leftSpaceToView(self.municipalityView, MarginFactor(24.0f))
    .topSpaceToView(self.municipalityView, MarginFactor(15.0f))
    .autoHeightRatio(0.0f);
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
    .autoHeightRatio(0.0f);
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
    .autoHeightRatio(0.0f);
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
    .autoHeightRatio(0.0f);
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
    .autoHeightRatio(0.0f);
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
    .autoHeightRatio(0.0f);
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
    .autoHeightRatio(0.0f);
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
    .autoHeightRatio(0.0f);
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
    
    [self.scrollView setupAutoContentSizeWithBottomView:self.northwestView bottomMargin:2 * MarginFactor(20.0f) + image.size.height];
}

- (void)initView
{
    self.locationBottonView.backgroundColor = Color(@"efeeef");
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
    
    self.locationTitleLabel.font = FontFactor(16.0f);
    self.locationTitleLabel.textColor = Color(@"161616");
    
    self.locationButton.titleLabel.font = FontFactor(15.0f);
    [self.locationButton setTitle:@"重新定位" forState:UIControlStateNormal];
    [self.locationButton setTitleColor:Color(@"2b7fdc") forState:UIControlStateNormal];
    [self.locationButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    self.locationButton.imageEdgeInsets = UIEdgeInsetsMake(0.0f, -7.0f, 0.0f, 0.0f);
//    [self.locationButton addTarget:self action:@selector(locationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    NSArray *locationArry = @[self.municipalityButtonView,self.eastChinaButtonView,self.northChinaButtonView,self.northeastButtonView,self.southChinaButtonView,self.centerButtonView,self.southwestButtonView,self.northwestButtonView,self.eastChinaButtonView];
    
    for (NSInteger j = 0 ; j < self.provinces.count; j ++)
    {
        for (NSInteger i = 0; i < [[[self.provinces objectAtIndex:j] objectForKey:@"areas"] count]; i ++)
        {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:[NSString stringWithFormat:@"%@",[[[self.provinces objectAtIndex:j] objectForKey:@"areas"] objectAtIndex:i]] forState:UIControlStateNormal];
            button.titleLabel.font = FontFactor(14.0f);
            button.adjustsImageWhenHighlighted = NO;
            [button setBackgroundImage:[[UIImage imageNamed:@"locationButtonBg"]resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f) resizingMode:UIImageResizingModeStretch ]forState:UIControlStateNormal];
            [button setBackgroundImage:[[UIImage imageNamed:@"locationButtonBgHigh"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
            [button setTitleColor:Color(@"161616") forState:UIControlStateNormal];
            [button setTitleColor:Color(@"f33300") forState:UIControlStateSelected];
            if ([button.titleLabel.text isEqualToString:self.locationTitleLabel.text]) {
                button.selected = YES;
                self.locationCurrentButton = button;
            }
            [button addTarget:self action:@selector(locationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
        self.currentButtonString = self.locationCurrentButton.titleLabel.text;
    }
    self.locationCurrentButton.selected = YES;
}

- (void)quiteClick:(UIButton *)btn
{
    self.currentButtonString = self.locationCurrentButton.titleLabel.text;
    if (self.returnLocationBlock) {
        self.returnLocationBlock(self.currentButtonString);
    }
       [self removeFromSuperview];
    
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (UIButton *)quiteButton
{
    if (!_quiteButton) {
        _quiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quiteButton setImage:[UIImage imageNamed:@"business_quit"] forState:UIControlStateNormal];
        [_quiteButton addTarget:self action:@selector(quiteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quiteButton;
}

//topView
- (UIView *)locationView
{
    if (!_locationView) {
        _locationView = [[UIView alloc]init];
        _locationTitleLabel = [[UILabel alloc] init];
        _locationView.backgroundColor = [UIColor whiteColor];
        [_locationView addSubview:_locationTitleLabel];
    
        _locationBottonView = [[UIView alloc] init];
        [_locationView addSubview:_locationBottonView];
        
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_locationButton addTarget:self action:@selector(newSelectLocationClick:) forControlEvents:UIControlEventTouchUpInside];
        [_locationView addSubview:_locationButton];
    }
    return _locationView;
}

- (void)newSelectLocationClick:(UIButton *)btn
{
    __weak typeof(self) weakSelf = self;
    [[CCLocationManager shareLocation] getCity:^{
        weakSelf.locationTitleLabel.text = [SHGGloble sharedGloble].provinceName;
    }];
}
//全国
- (UIView *)municipalityView
{
    if (!_municipalityView) {
        _municipalityView = [[UIView alloc]init];
        _municipalityView.backgroundColor = [UIColor whiteColor];
        _municipalityTitleLabel = [[UILabel alloc] init];
        _municipalityTitleLabel.text = @"直辖市";
        [_municipalityView addSubview:_municipalityTitleLabel];
        
        _municipalityBottomView = [[UIView alloc] init];
        [_municipalityView addSubview:_municipalityBottomView];
        
        _municipalityButtonView = [[UIView alloc] init];
        [_municipalityView addSubview:_municipalityButtonView];
    }
    return _municipalityView;
}

//华东地区
- (UIView *)eastChinaView
{
    if (!_eastChinaView) {
        _eastChinaView = [[UIView alloc]init];
        _eastChinaView.backgroundColor = [UIColor whiteColor];
        _eastChinaTitleLabel = [[UILabel alloc] init];
        _eastChinaTitleLabel.text = @"华东地区";
        [_eastChinaView addSubview:_eastChinaTitleLabel];
        
        _eastChinaButtonView = [[UIView alloc] init];
        [_eastChinaView addSubview:_eastChinaButtonView];
        
        _eastChinaBottomView = [[UIView alloc] init];
        [_eastChinaView addSubview:_eastChinaBottomView];
    }
    return _eastChinaView;
}

//华北地区
- (UIView *)northChinaView
{
    if (!_northChinaView) {
        _northChinaView = [[UIView alloc]init];
        _northChinaView.backgroundColor = [UIColor whiteColor];
        _northChinaTitleLabel = [[UILabel alloc] init];
        _northChinaTitleLabel.text = @"华北地区";
        [_northChinaView addSubview:_northChinaTitleLabel];
        
        _northChinaBottomView = [[UIView alloc] init];
        [_northChinaView addSubview:_northChinaBottomView];
        
        _northChinaButtonView = [[UIView alloc] init];
        [_northChinaView addSubview:_northChinaButtonView];
        
    }
    return _northChinaView;
}

//东北地区
- (UIView *)northeastView
{
    if (!_northeastView) {
        _northeastView = [[UIView alloc]init];
        _northeastView.backgroundColor = [UIColor whiteColor];
        _northeastTitleLabel = [[UILabel alloc] init];
        _northeastTitleLabel.text = @"东北地区";
        [_northeastView addSubview:_northeastTitleLabel];
        
        _northeastBottom = [[UIView alloc] init];
        [_northeastView addSubview:_northeastBottom];
        
        _northeastButtonView = [[UIView alloc] init];
        [_northeastView addSubview:_northeastButtonView];
    }
    return _northeastView;
}

//华南地区
- (UIView *)southChinaView
{
    if (!_southChinaView) {
        _southChinaView = [[UIView alloc]init];
        _southChinaView.backgroundColor = [UIColor whiteColor];
        _southChinaTitleLabel = [[UILabel alloc] init];
        _southChinaTitleLabel.text = @"华南地区";
        [_southChinaView addSubview:_southChinaTitleLabel];
        
        _southChinaBottomView = [[UIView alloc] init];
        [_southChinaView addSubview:_southChinaBottomView];
        
        _southChinaButtonView = [[UIView alloc] init];
        [_southChinaView addSubview:_southChinaButtonView];
    }
    return _southChinaView;
}

//华中地区
- (UIView *)centerView
{
    if (!_centerView) {
        _centerView = [[UIView alloc]init];
        _centerView.backgroundColor = [UIColor whiteColor];
        _centerTitleLabel = [[UILabel alloc] init];
        _centerTitleLabel.text = @"华中地区";
        [_centerView addSubview:_centerTitleLabel];
        
        _centerBottomView = [[UIView alloc] init];
        [_centerView addSubview:_centerBottomView];
        
        _centerButtonView = [[UIView alloc] init];
        [_centerView addSubview:_centerButtonView];
        
    }
    return _centerView;
}

//西南地区
- (UIView *)southwestView
{
    if (!_southwestView) {
        _southwestView = [[UIView alloc]init];
        _southwestView.backgroundColor = [UIColor whiteColor];
        _southwestTitleLabel = [[UILabel alloc] init];
        _southwestTitleLabel.text = @"西南地区";
        [_southwestView addSubview:_southwestTitleLabel];
        
        _southwestBottomView = [[UIView alloc] init];
        [_southwestView addSubview:_southwestBottomView];
        
        _southwestButtonView = [[UIView alloc] init];
        [_southwestView addSubview:_southwestButtonView];

        
    }
    return _southwestView;
}

//西北地区
- (UIView *)northwestView
{
    if (!_northwestView) {
        _northwestView = [[UIView alloc]init];
        _northwestView.backgroundColor = [UIColor whiteColor];
        _northwestTitleLabel = [[UILabel alloc] init];
        _northwestTitleLabel.text = @"西北地区";
        [_northwestView addSubview:_northwestTitleLabel];
        
        _northwestButtonView = [[UIView alloc] init];
        [_northwestView addSubview:_northwestButtonView];
        
        _northwestBottomView = [[UIView alloc] init];
        [_northwestView addSubview:_northwestBottomView];
        

    }
    return _northwestView;
}


@end
