//
//  SHGAlertView.m
//  Finance
//
//  Created by changxicao on 16/5/6.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGAlertView.h"

@interface SHGAlertView ()

@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;

@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *lineLabel;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIView *customView;

@property (strong, nonatomic) UIButton *closeButton;

@end

@implementation SHGAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shouldDismiss = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10.0f;
        [self initView];
        [self addAutoLayout];
    }
    return self;
}

- (void)initView
{
    self.titleView = [[UIView alloc] init];
    self.titleView.backgroundColor = [UIColor clearColor];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = FontFactor(18.0f);
    self.titleLabel.textColor = Color(@"f04241");
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.textColor = Color(@"585858");
    self.subTitleLabel.font = FontFactor(14.0f);
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;

    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = Color(@"f04241");

    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = FontFactor(15.0f);
    self.contentLabel.textColor = Color(@"8d8d8d");
    self.contentLabel.textAlignment = NSTextAlignmentCenter;

    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.leftBtn.backgroundColor = Color(@"C5C5C5");

    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn.backgroundColor = Color(@"F04241");

    self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = FontFactor(16.0f);
    self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;

    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage imageNamed:@"alert_Close"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setEnlargeEdge:20.0f];
    self.closeButton.hidden = YES;

    [self.titleView addSubview:self.titleLabel];
    [self sd_addSubviews:@[self.titleView, self.lineLabel, self.closeButton]];
}

- (void)addAutoLayout
{
    self.titleView.sd_layout
    .centerXEqualToView(self)
    .widthRatioToView(self, 1.0f)
    .topSpaceToView(self, 0.0f);

    self.titleLabel.sd_layout
    .centerXEqualToView(self.titleView)
    .widthRatioToView(self.titleView, 1.0f)
    .topSpaceToView(self.titleView, MarginFactor(9.0f))
    .heightIs(ceilf(self.titleLabel.font.lineHeight));

    [self.titleView setupAutoHeightWithBottomView:self.titleLabel bottomMargin: MarginFactor(9.0f)];

    self.lineLabel.sd_layout
    .leftSpaceToView(self, MarginFactor(26.0f))
    .rightSpaceToView(self, MarginFactor(26.0f))
    .topSpaceToView(self.titleView, 0.0f)
    .heightIs(1.0f);

    self.closeButton.sd_layout
    .leftSpaceToView(self, MarginFactor(28.0f))
    .centerYEqualToView(self.titleView)
    .widthIs(self.closeButton.currentImage.size.width)
    .heightIs(self.closeButton.currentImage.size.height);
}

- (instancetype)initWithTitle:(NSString *)title contentText:(NSString *)content leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rightTitle
{
    self = [self init];
    if (self) {

        if (!leftTitle) {
            [self sd_addSubviews:@[self.contentLabel, self.rightBtn]];

            self.contentLabel.sd_layout
            .leftEqualToView(self.lineLabel)
            .rightEqualToView(self.lineLabel)
            .topSpaceToView(self.lineLabel, MarginFactor(17.0f))
            .autoHeightRatio(0.0f);

            self.rightBtn.sd_layout
            .centerXEqualToView(self)
            .topSpaceToView(self.contentLabel, MarginFactor(17.0f))
            .widthRatioToView(self.lineLabel, 1.0f)
            .heightIs(MarginFactor(37.0f));

            [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];

        } else {
            [self sd_addSubviews:@[self.contentLabel, self.leftBtn, self.rightBtn]];

            self.contentLabel.sd_layout
            .leftEqualToView(self.lineLabel)
            .rightEqualToView(self.lineLabel)
            .topSpaceToView(self.lineLabel, MarginFactor(17.0f))
            .autoHeightRatio(0.0f);

            self.leftBtn.sd_layout
            .leftEqualToView(self.lineLabel)
            .topSpaceToView(self.contentLabel, MarginFactor(17.0f))
            .widthIs(MarginFactor(118.0f))
            .heightIs(MarginFactor(37.0f));

            self.rightBtn.sd_layout
            .rightEqualToView(self.lineLabel)
            .topEqualToView(self.leftBtn)
            .widthRatioToView(self.leftBtn, 1.0f)
            .heightRatioToView(self.leftBtn, 1.0f);

            [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];

            [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        }

        self.titleLabel.text = title;
        self.contentLabel.text = content;

        [self setupAutoHeightWithBottomView:self.rightBtn bottomMargin:MarginFactor(24.0f)];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title customView:(UIView *)customView leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rightTitle
{
    self = [self init];
    if (self) {
        self.customView = customView;

        if (!leftTitle) {
            [self sd_addSubviews:@[customView, self.rightBtn]];

            customView.sd_layout
            .heightIs(CGRectGetHeight(customView.frame))
            .centerXEqualToView(self)
            .topSpaceToView(self.lineLabel, 0.0f);

            self.rightBtn.sd_layout
            .centerXEqualToView(self)
            .topSpaceToView(customView, MarginFactor(17.0f))
            .widthRatioToView(self.lineLabel, 1.0f)
            .heightIs(MarginFactor(37.0f));

            [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];

        } else {
            [self sd_addSubviews:@[self.leftBtn, self.rightBtn, customView]];

            customView.sd_layout
            .topSpaceToView(self.lineLabel, 0.0f);

            self.leftBtn.sd_layout
            .leftEqualToView(self.lineLabel)
            .topSpaceToView(customView, MarginFactor(17.0f))
            .widthIs(MarginFactor(118.0f))
            .heightIs(MarginFactor(37.0f));

            self.rightBtn.sd_layout
            .rightEqualToView(self.lineLabel)
            .topEqualToView(self.leftBtn)
            .widthRatioToView(self.leftBtn, 1.0f)
            .heightRatioToView(self.leftBtn, 1.0f);

            [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];

            [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        }

        self.titleLabel.text = title;

        [self setupAutoHeightWithBottomView:self.rightBtn bottomMargin:MarginFactor(24.0f)];
    }
    return self;
}

- (instancetype)initWithCustomView:(UIView *)customView leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rightTitle
{
    self = [super init];
    if (self) {
        self.shouldDismiss = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10.0f;
        [self addSubview:customView];
        self.customView = customView;

        [self setupAutoHeightWithBottomView:customView bottomMargin:0.0f];
    }
    return self;
}


- (void)addSubTitle:(NSString *)subTitle
{
    [self.titleView addSubview:self.subTitleLabel];

    self.subTitleLabel.sd_layout
    .leftEqualToView(self.titleLabel)
    .rightEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel, MarginFactor(9.0f))
    .heightIs(ceilf(self.subTitleLabel.font.lineHeight));

    self.subTitleLabel.text = subTitle;
    [self.titleView setupAutoHeightWithBottomView:self.subTitleLabel bottomMargin:MarginFactor(7.0f)];
}

- (void)leftBtnClicked:(id)sender
{
    if (self.leftBlock) {
        self.leftBlock();
    }
    [self dismissAlert];
}

- (void)rightBtnClicked:(id)sender
{
    if (self.rightBlock) {
        self.rightBlock();
    }
    if (self.shouldDismiss) {
        [self dismissAlert];
    }
}

- (void)show
{
    [[AppDelegate currentAppdelegate].window addSubview:self];
}

- (void)showWithClose
{
    self.closeButton.hidden = NO;
    [[AppDelegate currentAppdelegate].window addSubview:self];
}

- (void)dismissAlert
{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    [self removeFromSuperview];
}


- (void)removeFromSuperview
{
    [self.backView removeFromSuperview];
    self.backView = nil;
    [super removeFromSuperview];
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (newWindow == nil) {
        return;
    }

    if (!self.backView) {
        self.backView = [[UIView alloc] initWithFrame:[AppDelegate currentAppdelegate].window.bounds];
        self.backView.backgroundColor = [UIColor blackColor];
        self.backView.alpha = 0.6f;
        self.backView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewTaped:)];
        [self.backView addGestureRecognizer:recognizer];
    }
    [newWindow addSubview:self.backView];

    [UIView animateKeyframesWithDuration:0.45f delay:0.0f options:UIViewKeyframeAnimationOptionCalculationModeCubic | UIViewAnimationOptionCurveLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.15f animations:^{
            self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.15f relativeDuration:0.15f animations:^{
            self.transform = CGAffineTransformMakeScale(0.95f, 0.95f);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.3f relativeDuration:0.15f animations:^{
            self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }];
    } completion:nil];

    [super willMoveToWindow:newWindow];
}

- (void)didMoveToWindow
{
    if (self.superview) {
        if (self.titleLabel.text) {
            self.sd_layout
            .widthIs(MarginFactor(300.0f))
            .centerYEqualToView([AppDelegate currentAppdelegate].window)
            .centerXEqualToView([AppDelegate currentAppdelegate].window);
        } else {
            if (self.customView) {
                self.sd_layout
                .widthIs(CGRectGetWidth(self.customView.frame))
                .centerYEqualToView([AppDelegate currentAppdelegate].window)
                .centerXEqualToView([AppDelegate currentAppdelegate].window);
            }
        }
        //再次更新下 以防布局出错
        [self updateLayout];
    }
    [super didMoveToWindow];
}

- (void)backViewTaped:(UITapGestureRecognizer *)recognizer
{
    if (self.touchOtherDismiss) {
        [self dismissAlert];
    }
}

@end


@interface SHGBusinessContactAlertView()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) NSString *leftTitle;
@property (strong, nonatomic) NSString *rightTitle;

@end

@implementation SHGBusinessContactAlertView

- (instancetype)initWithLeftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rightTitle
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.leftTitle = leftTitle;
        self.rightTitle = rightTitle;
        [self initView];
        [self addAutoLayout];
    }
    return self;
}

- (void)initView
{
    self.customView = [[UIView alloc] init];

    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.cornerRadius = 10.0f;

    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"business_titleImage"]];

    self.label = [[UILabel alloc] init];
    self.label.font = FontFactor(15.0f);
    self.label.textColor = Color(@"8d8d8d");
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.backgroundColor = Color(@"90bec6");
    [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.leftBtn setTitle:self.leftTitle forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.backgroundColor = Color(@"f95c53");
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBtn setTitle:self.rightTitle forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = FontFactor(16.0f);
    self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
    self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0f;
    
    [self addSubview:self.customView];
    
    [self.customView sd_addSubviews:@[self.backgroundView, self.imageView, self.label, self.rightBtn, self.leftBtn]];

}

- (void)addAutoLayout
{
    self.customView.sd_layout
    .widthIs(MarginFactor(290.0f));

    self.backgroundView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.imageView.sd_layout
    .centerXEqualToView(self.customView)
    .topSpaceToView(self.customView, MarginFactor(15.0f))
    .widthIs(self.imageView.image.size.width)
    .heightIs(self.imageView.image.size.height);

    self.label.sd_layout
    .leftSpaceToView(self.customView, MarginFactor(27.0f))
    .rightSpaceToView(self.customView, MarginFactor(27.0f))
    .topSpaceToView(self.imageView, 0.0f)
    .bottomSpaceToView(self.rightBtn, 0.0f);

    [self.customView setupAutoHeightWithBottomView:self.rightBtn bottomMargin:MarginFactor(15.0f)];

    [self setupAutoHeightWithBottomView:self.customView bottomMargin:0.0f];

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setText:(NSAttributedString *)text
{
    _text = text;
    self.label.attributedText = text;

    if (self.leftTitle) {
        self.leftBtn.sd_layout
        .leftEqualToView(self.label)
        .topSpaceToView(self.imageView, text.length > 0 ? MarginFactor(79.0f) : MarginFactor(26.0f))
        .heightIs(MarginFactor(38.0f))
        .widthIs(MarginFactor(116.0f));
        
        self.rightBtn.sd_layout
        .rightEqualToView(self.label)
        .topEqualToView(self.leftBtn)
        .widthRatioToView(self.leftBtn, 1.0f)
        .heightRatioToView(self.leftBtn, 1.0f);
    } else{
        
        self.rightBtn.sd_layout
        .centerXEqualToView(self.customView)
        .topSpaceToView(self.imageView, text.length > 0 ? MarginFactor(79.0f) : MarginFactor(26.0f))
        .widthIs(MarginFactor(227.0f))
        .heightIs(MarginFactor(38.0f));
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


@end
