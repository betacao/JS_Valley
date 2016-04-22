//
//  SHGBusinessLocationView.m
//  Finance
//
//  Created by weiqiankun on 16/4/12.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessLocationView.h"
#import "SHGBusinessMargin.h"
#import "SHGBusinessObject.h"
#import "CCLocationManager.h"
#import "SHGBusinessButtonContentView.h"
@interface SHGBusinessLocationView ()

//topView
@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic)  UIButton *quiteButton;
@property (strong, nonatomic)  UIView *locationView;
@property (strong, nonatomic)  UILabel *locationTitleLabel;
@property (strong, nonatomic)  UIView *locationBottonView;
@property (strong, nonatomic)  UIButton *locationButton;

@property (strong, nonatomic) NSArray *provinces;
@property (strong, nonatomic) NSMutableArray *allCity;
@property (strong, nonatomic) UIButton *locationCurrentButton;
@property (strong, nonatomic) UIView *lastContentView;

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
        self.locationTitleLabel.text = locationString;
        [self initView];
        [self addSdLayout];
        
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
    
    [self.scrollView setupAutoContentSizeWithBottomView:self.lastContentView bottomMargin:0.0f];
}

- (void)initView
{

    self.locationTitleLabel.font = FontFactor(16.0f);
    self.locationTitleLabel.textColor = Color(@"161616");
    
    self.locationButton.titleLabel.font = FontFactor(15.0f);
    [self.locationButton setTitle:@"重新定位" forState:UIControlStateNormal];
    [self.locationButton setTitleColor:Color(@"2b7fdc") forState:UIControlStateNormal];
    [self.locationButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    self.locationButton.imageEdgeInsets = UIEdgeInsetsMake(0.0f, -7.0f, 0.0f, 0.0f);
    


    for (NSInteger j = 0 ; j < self.provinces.count; j ++) {
        SHGBusinessButtonContentView *contentView = [[SHGBusinessButtonContentView alloc] initWithMode:SHGBusinessButtonShowModeSingleChoice];
        contentView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:contentView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [contentView addSubview:titleLabel];
        titleLabel.font = FontFactor(13.0f);
        titleLabel.textColor = Color(@"161616");
        titleLabel.text = [[self.provinces objectAtIndex:j] objectForKey:@"state"];
        
        titleLabel.sd_layout
        .topSpaceToView(contentView, 0.0f)
        .leftSpaceToView(contentView, kLeftToView)
        .rightSpaceToView(contentView, 0.0f)
        .heightIs(MarginFactor(30.0f) + titleLabel.font.lineHeight);
        __block UIButton *lastButton = nil;
        for (NSInteger i = 0; i < [[[self.provinces objectAtIndex:j] objectForKey:@"areas"] count]; i ++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:[NSString stringWithFormat:@"%@",[[[self.provinces objectAtIndex:j] objectForKey:@"areas"] objectAtIndex:i]] forState:UIControlStateNormal];
            button.titleLabel.font = FontFactor(14.0f);
            button.adjustsImageWhenHighlighted = NO;
            [button setBackgroundImage:[[UIImage imageNamed:@"locationButtonBg"]resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch ]forState:UIControlStateNormal];
            [button setBackgroundImage:[[UIImage imageNamed:@"locationButtonBgHighlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
            [button setTitleColor:Color(@"161616") forState:UIControlStateNormal];
            [button setTitleColor:Color(@"f33300") forState:UIControlStateSelected];
            if ([button.titleLabel.text isEqualToString:self.locationTitleLabel.text]) {
                button.selected = YES;
                self.locationCurrentButton = button;
            }
            [button addTarget:self action:@selector(locationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(MarginFactor(12.0f) + i%3 * (kLocationButtonLeftMargin + kLocationButtonWidth), i/3 * (kLocationButtonTopMargin + kLocationButtonHeight) + MarginFactor(30.0f) + ceilf(titleLabel.font.lineHeight), kLocationButtonWidth, kLocationButtonHeight);
            lastButton = button;

            [contentView addSubview:button];
        }
        UIView *spliteView = [[UIView alloc] init];
        spliteView.backgroundColor = Color(@"efeeef");
        [contentView addSubview:spliteView];
        
        spliteView.sd_layout
        .topSpaceToView(lastButton, MarginFactor(10.0f))
        .leftSpaceToView(contentView, 0.0f)
        .rightSpaceToView(contentView, 0.0f)
        .heightIs(MarginFactor(12.0f));
        if (j == self.provinces.count - 1) {
            spliteView.hidden = YES;
        }

        if (self.lastContentView) {
            contentView.sd_layout
            .leftSpaceToView(self.scrollView, 0.0f)
            .rightSpaceToView(self.scrollView, 0.0f)
            .topSpaceToView(self.lastContentView, 0.0f);
            [contentView setupAutoHeightWithBottomView:spliteView bottomMargin:0.0f];
        } else {
            contentView.sd_layout
            .leftSpaceToView(self.scrollView, 0.0f)
            .rightSpaceToView(self.scrollView, 0.0f)
            .topSpaceToView(self.locationView, 0.0f);
            [contentView setupAutoHeightWithBottomView:spliteView bottomMargin:0.0f];
        }
        self.lastContentView = contentView;
        
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
        _scrollView.scrollEnabled = YES;
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
        _locationBottonView.backgroundColor = Color(@"efeeef");
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


@end
