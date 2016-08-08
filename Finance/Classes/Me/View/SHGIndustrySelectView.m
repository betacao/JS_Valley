//
//  SHGIndustrySelectView.m
//  Finance
//
//  Created by weiqiankun on 16/8/8.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGIndustrySelectView.h"
#import "SHGBusinessButtonContentView.h"

@interface SHGIndustrySelectView ()
@property (strong, nonatomic)UIView *topView;
@property (strong, nonatomic)UIView *topLineView;
@property (strong, nonatomic)UILabel *titleLabel;
@property (strong, nonatomic)UIButton *quiteButton;
@property (strong, nonatomic)SHGBusinessButtonContentView *buttonView;
@property (strong, nonatomic)UIImageView *bottomImageView;

@property (strong, nonatomic)NSString *industry;
@end

@implementation SHGIndustrySelectView
- (instancetype)initWithFrame:(CGRect)frame andSelctIndustry:(NSString *)industry
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.industry = industry;
        [self addSubview:self.topView];
        [self addSubview:self.buttonView];
        [self addSubview:self.bottomImageView];
        [self addSDlayout];
        
    }
    return self;
}

- (void)addSDlayout
{
    self.topView.sd_layout
    .topSpaceToView(self, 0.0f)
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .heightIs(64.0f);
    
    self.titleLabel.sd_layout
    .centerXEqualToView (self.topView)
    .centerYEqualToView (self.topView)
    .heightIs(self.titleLabel.font.lineHeight);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    UIImage *quiteImage = [UIImage imageNamed:@"industryQuite"];
    CGSize quiteImageSize = quiteImage.size;
    
    self.quiteButton.sd_layout
    .rightSpaceToView(self.topView, MarginFactor(20.0f))
    .centerYEqualToView (self.topView)
    .widthIs (quiteImageSize.width)
    .heightIs (quiteImageSize.height);
    
    self.topLineView.sd_layout
    .leftSpaceToView (self.topView, 0.0f)
    .rightSpaceToView (self.topView, 0.0f)
    .bottomSpaceToView (self.topView, 0.0f)
    .heightIs (1/SCALE);
    
    UIImage *bottomImage = [UIImage imageNamed:@"industrySelectBottomImage"];
    CGSize bottomImageSize = bottomImage.size;
    
    self.bottomImageView.sd_layout
    .leftSpaceToView (self, 0.0f)
    .rightSpaceToView (self, 0.0f)
    .bottomSpaceToView(self, 0.0f)
    .heightIs (bottomImageSize.height);
    
    self.buttonView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .topSpaceToView(self.topView, MarginFactor(88.0f))
    .bottomSpaceToView(self.bottomImageView, MarginFactor(41.0f));
    
    NSArray *array = [NSArray arrayWithObjects:@"银行机构",@"证券公司",@"PE/VC",@"债权机构",@"公募基金",@"信托公司",@"三方理财",@"担保小贷",@"上市公司",@"融资企业",@"其他", nil];
    for (NSInteger i = 0; i < array.count; i ++) {
        UIImage *buttonBgImage = [UIImage imageNamed:@"industry_unSelected"];
        buttonBgImage = [buttonBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
        UIImage *buttonSelectBgImage = [UIImage imageNamed:@"industry_selected"];
        buttonSelectBgImage = [buttonSelectBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 20.0f) resizingMode:UIImageResizingModeStretch];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = FontFactor(16.0f);
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateSelected];
        [button setTitleColor:Color(@"fe5858") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:buttonBgImage forState:UIControlStateNormal];
        [button setBackgroundImage:buttonSelectBgImage forState:UIControlStateSelected];
        
        if (self.industry) {
            if ([button.titleLabel.text isEqualToString:self.industry]) {
                button.selected = YES;
            }
        }
        CGFloat kLeftToView = MarginFactor(34.0f);
        CGFloat width = MarginFactor(142.0f);
        CGFloat height = MarginFactor(43.0f);
        CGFloat leftMargin = MarginFactor(24.0f);
        CGFloat topMargin = MarginFactor(22.0f);
        
        button.frame = CGRectMake(kLeftToView + i%2 * (width + leftMargin), i/2 * (height + topMargin), width, height);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonView addSubview:button];

    }
    
}
- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = Color(@"f6f6f6");
    }
    return _topView;
}

- (UIView *)topLineView
{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = Color(@"e1e3e3");
        [self.topView addSubview:_topLineView];
    }
    return _topLineView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"选择您的行业";
        _titleLabel.textColor = Color(@"f55252");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = FontFactor(18.0f);
        [self.topView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)quiteButton
{
    if (!_quiteButton) {
        _quiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quiteButton setImage:[UIImage imageNamed:@"industryQuite"] forState:UIControlStateNormal];
        [_quiteButton addTarget:self action:@selector(quiteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:_quiteButton];
    }
    return _quiteButton;
}

- (SHGBusinessButtonContentView *)buttonView
{
    if (!_buttonView) {
        _buttonView = [[SHGBusinessButtonContentView alloc] initWithMode:SHGBusinessButtonShowModeSingleChoice];
    }
    return _buttonView;
}

- (UIImageView *)bottomImageView
{
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] init];
        _bottomImageView.image = [UIImage imageNamed:@"industrySelectBottomImage"];
    }
    return _bottomImageView;
}

- (void)buttonClick:(UIButton *)btn
{
    if (self.returnTextBlock) {
        self.returnTextBlock(btn.titleLabel.text);
    }
    [self removeFromSuperview];
}

- (void)quiteButtonClick:(UIButton *)btn
{
    [self removeFromSuperview];
}
@end
