//
//  SHGBusinessSendMainView.m
//  Finance
//
//  Created by changxicao on 16/4/7.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessMainSendView.h"
#import "SHGBusinessListViewController.h"
#import "SHGBondInvestSendViewController.h"
#import "SHGBondFinanceSendViewController.h"
#import "SHGEquityInvestSendViewController.h"
#import "SHGEquityFinanceSendViewController.h"
#import "SHGSameAndCommixtureSendViewController.h"

@interface SHGBusinessMainSendView()

@property (strong, nonatomic) UIImageView *backgroundView;
@property (strong, nonatomic) UIImageView *titleView;

@property (strong, nonatomic) UIButton *firstButton;
@property (strong, nonatomic) UIButton *secondButton;
@property (strong, nonatomic) UIButton *thridButton;
@property (strong, nonatomic) UIButton *fourthButton;
@property (strong, nonatomic) UIButton *fifthButton;
@property (strong, nonatomic) UIButton *closeButton;

@end

@implementation SHGBusinessMainSendView

+ (SHGBusinessMainSendView *)sharedView
{
    static SHGBusinessMainSendView *sharedView = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return sharedView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self addAutoLayout];
    }
    return self;
}

- (void)initView
{
    self.backgroundView = [[UIImageView alloc] init];
    self.backgroundView.image = [UIImage imageNamed:@"business_mainSendBg"];
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;

    self.titleView = [[UIImageView alloc] init];
    self.titleView.image = [UIImage imageNamed:@"business_title"];

    self.firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.firstButton setImage:[UIImage imageNamed:@"business_equityFinance"] forState:UIControlStateNormal];
    [self.firstButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.secondButton setImage:[UIImage imageNamed:@"business_bondFinance"] forState:UIControlStateNormal];
    [self.secondButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.thridButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.thridButton setImage:[UIImage imageNamed:@"business_bondInvest"] forState:UIControlStateNormal];
    [self.thridButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.fourthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fourthButton setImage:[UIImage imageNamed:@"business_equityInvest"] forState:UIControlStateNormal];
    [self.fourthButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.fifthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fifthButton setImage:[UIImage imageNamed:@"banksAndRecurity"] forState:UIControlStateNormal];
    [self.fifthButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage imageNamed:@"business_sendClose"] forState:UIControlStateNormal];
    self.closeButton.backgroundColor = [UIColor whiteColor];
    [self.closeButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self sd_addSubviews:@[self.backgroundView, self.titleView, self.firstButton, self.secondButton, self.thridButton, self.fourthButton, self.fifthButton, self.closeButton]];
}

- (void)addAutoLayout
{
    self.backgroundView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.titleView.sd_layout
    .topSpaceToView(self, MarginFactor(115.0f))
    .centerXEqualToView(self)
    .widthIs(self.titleView.image.size.width)
    .heightIs(self.titleView.image.size.height);

    CGFloat margin = ceilf((CGRectGetWidth(self.frame) - 3.0f * self.firstButton.currentImage.size.width)/ 4.0f);
    self.firstButton.sd_layout
    .leftSpaceToView(self, margin)
    .topSpaceToView(self.titleView, MarginFactor(80.0f))
    .widthIs(self.firstButton.currentImage.size.width)
    .heightIs(self.firstButton.currentImage.size.height);


    self.secondButton.sd_layout
    .leftSpaceToView(self.firstButton, margin)
    .topEqualToView(self.firstButton)
    .widthIs(self.secondButton.currentImage.size.width)
    .heightIs(self.secondButton.currentImage.size.height);


    self.thridButton.sd_layout
    .leftSpaceToView(self.secondButton, margin)
    .topEqualToView(self.firstButton)
    .widthIs(self.thridButton.currentImage.size.width)
    .heightIs(self.thridButton.currentImage.size.height);

    self.fourthButton.sd_layout
    .topSpaceToView(self.firstButton, MarginFactor(37.0f))
    .leftSpaceToView(self.firstButton, (margin - self.firstButton.currentImage.size.width) / 2.0f)
    .widthIs(self.fourthButton.currentImage.size.width)
    .heightIs(self.fourthButton.currentImage.size.height);


    self.fifthButton.sd_layout
    .leftSpaceToView(self.fourthButton, margin)
    .topEqualToView(self.fourthButton)
    .widthIs(self.fifthButton.currentImage.size.width)
    .heightIs(self.fifthButton.currentImage.size.height);


    self.closeButton.sd_layout
    .bottomSpaceToView(self, MarginFactor(0.0f))
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .heightIs(MarginFactor(50.0f));

}

- (void)buttonClicked:(UIButton *)button
{
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    UIViewController *controller = nil;
    if ([button isEqual:self.firstButton]) {
        controller = [[SHGEquityFinanceSendViewController alloc] init];
    } else if ([button isEqual:self.secondButton]) {
        controller = [[SHGBondFinanceSendViewController alloc] init];
    } else if ([button isEqual:self.thridButton]) {
        controller = [[SHGBondInvestSendViewController alloc] init];
    } else if ([button isEqual:self.fourthButton]) {
        controller = [[SHGEquityInvestSendViewController alloc] init];
    } else if ([button isEqual:self.fifthButton]) {
        controller = [[SHGSameAndCommixtureSendViewController alloc] init];
    }
    if (controller) {
        [[SHGBusinessListViewController sharedController].navigationController pushViewController:controller animated:YES];
    }
}
@end
