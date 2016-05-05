//
//  ILSMLAlertView.m
//  MoreLikers
//
//  Created by xiekw on 13-9-9.
//  Copyright (c) 2013年 谢凯伟. All rights reserved.
//

#import "DXAlertView.h"
#import <QuartzCore/QuartzCore.h>

@interface DXAlertView ()

@property (strong, nonatomic) UILabel *alertTitleLabel;
@property (strong, nonatomic) UILabel *alertContentLabel;
@property (strong, nonatomic) UILabel *lineLabel;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;
@property (strong, nonatomic) UIView *backImageView;
@property (strong, nonatomic) UIView *customView;

@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UILabel *subTitleLabel;
@end

@implementation DXAlertView

+ (CGFloat)alertWidth
{
    return kAlertWidth;
}

+ (CGFloat)alertHeight
{
    return kAlertHeight;
}

- (instancetype)initWithTitle:(NSString *)title contentText:(NSString *)content leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle
{
    if (self = [super init]){
        self.shouldDismiss = YES;
        self.layer.cornerRadius = 8.0f;
        self.backgroundColor = [UIColor whiteColor];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kAlertWidth, kLineViewTopMargin)];
        self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.alertTitleLabel.font = FontFactor(18.0f);
        self.alertTitleLabel.textColor = [UIColor colorWithHexString:@"f04241"];
        [self addSubview:self.alertTitleLabel];
        
        CGFloat contentLabelWidth = kAlertWidth - kLineViewLeftMargin * 2;
        
        self.lineLabel = [[UILabel alloc] initWithFrame:CGRectMake((kAlertWidth - contentLabelWidth) * 0.5, kLineViewTopMargin, contentLabelWidth, 1.0f)];
        self.lineLabel.backgroundColor = [UIColor colorWithHexString:@"f04241"];
        [self addSubview:self.lineLabel];
        
        //content的高度先设置为0 下面动态计算高度
        self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake((kAlertWidth - contentLabelWidth) * 0.5, CGRectGetMaxY(self.lineLabel.frame), contentLabelWidth, 0.0f)];
        self.alertContentLabel.numberOfLines = 0;
        self.alertContentLabel.textAlignment = NSTextAlignmentCenter;
        self.alertContentLabel.textColor = [UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1];
        self.alertContentLabel.font = FontFactor(16.0f);
        [self addSubview:self.alertContentLabel];
        
        CGRect leftBtnFrame = CGRectZero;
        CGRect rightBtnFrame = CGRectZero;

        if (!leftTitle) {
            rightBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kSingleButtonWidth, kButtonHeight);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;
            
            //这里设置content的高度
            CGRect frame = self.alertContentLabel.frame;
            frame.size.height = CGRectGetMinY(rightBtnFrame) - CGRectGetMinY(frame);
            self.alertContentLabel.frame = frame;
            
        }else {
            leftBtnFrame = CGRectMake(kLineViewLeftMargin, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(kAlertWidth - kCoupleButtonWidth - kLineViewLeftMargin, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
            
            //这里设置content的高度
            CGRect frame = self.alertContentLabel.frame;
            frame.size.height = CGRectGetMinY(rightBtnFrame) - CGRectGetMinY(frame);
            self.alertContentLabel.frame = frame;
        }
        
        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"F04241"]] forState:UIControlStateNormal];
        [self.leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"C5C5C5"]] forState:UIControlStateNormal];
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = FontFactor(16.0f);
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
        self.alertTitleLabel.text = title;
        self.alertContentLabel.text = content;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title customView:(UIView *)customView leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle
{
    self = [super init];
    if(self){
        self.shouldDismiss = YES;
        self.layer.cornerRadius = 8.0f;
        self.backgroundColor = [UIColor whiteColor];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kAlertWidth, kLineViewTopMargin)];
        self.alertTitleLabel.font = FontFactor(18.0f);
        self.alertTitleLabel.textColor = [UIColor colorWithHexString:@"f04241"];
        self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.alertTitleLabel];

        CGFloat contentLabelWidth = kAlertWidth - 2 * kLineViewLeftMargin;

        self.lineLabel = [[UILabel alloc] initWithFrame:CGRectMake((kAlertWidth - contentLabelWidth) * 0.5, kLineViewTopMargin, contentLabelWidth, 1.0f)];
        self.lineLabel.backgroundColor = [UIColor colorWithHexString:@"f04241"];
        [self addSubview:self.lineLabel];

        CGRect frame = customView.frame;
        frame.origin.y += CGRectGetMaxY(self.lineLabel.frame);
        customView.frame = frame;
        [self addSubview:customView];
        self.customView = customView;

        CGRect leftBtnFrame = CGRectZero;
        CGRect rightBtnFrame = CGRectZero;
        if (!leftTitle) {
            rightBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5, CGRectGetMaxY(customView.frame) + kCustomViewButtomMargin, kSingleButtonWidth, kButtonHeight);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;

        }else {
            leftBtnFrame = CGRectMake(kLineViewLeftMargin, CGRectGetMaxY(customView.frame) + kCustomViewButtomMargin, kCoupleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(kAlertWidth - kLineViewLeftMargin - kCoupleButtonWidth, CGRectGetMaxY(customView.frame) + kCustomViewButtomMargin, kCoupleButtonWidth, kButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
        }

        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"F04241"]] forState:UIControlStateNormal];
        [self.leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"C5C5C5"]] forState:UIControlStateNormal];
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = FontFactor(16.0f);
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];

        self.alertTitleLabel.text = title;

        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (instancetype)initWithCustomView:(UIView *)customView leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle
{
    self = [super init];
    if(self){
        self.shouldDismiss = YES;
        [self addSubview:customView];
        self.customView = customView;

        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"alert_Close"];
        [_closeButton setImage:image forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setEnlargeEdge:20.0f];
        _closeButton.hidden = YES;
        [self addSubview:_closeButton];
        _closeButton.sd_layout
        .leftSpaceToView(self, MarginFactor(28.0f))
        .topSpaceToView(self, MarginFactor(20.0f))
        .widthIs(image.size.width)
        .heightIs(image.size.height);
    }
    return _closeButton;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = Color(@"585858");
        _subTitleLabel.font = FontFactor(14.0f);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLabel;
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

- (void)addSubTitle:(NSString *)subTitle
{
    [self addSubview:self.subTitleLabel];
    self.subTitleLabel.text = [@"V" stringByAppendingString: subTitle];
    self.subTitleLabel.sd_layout
    .bottomSpaceToView(self.lineLabel, MarginFactor(4.0f))
    .centerXEqualToView(self)
    .heightIs(self.subTitleLabel.font.lineHeight)
    .widthRatioToView(self, 1.0f);

    self.alertTitleLabel.sd_layout
    .bottomSpaceToView(self.subTitleLabel, MarginFactor(5.0f))
    .centerXEqualToView(self)
    .heightIs(self.alertTitleLabel.font.lineHeight)
    .widthRatioToView(self, 1.0f);
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    [topVC.view addSubview:self];
}

- (void)showWithClose
{
    self.closeButton.hidden = NO;
    UIViewController *topVC = [self appRootViewController];
    [topVC.view addSubview:self];
}

- (void)dismissAlert
{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    [self removeFromSuperview];
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    [super removeFromSuperview];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backImageViewTaped:)];
        [self.backImageView addGestureRecognizer:recognizer];
    }
    [topVC.view addSubview:self.backImageView];
    CGRect afterFrame = CGRectZero;
    if(self.customView){
        CGFloat height = MAX(CGRectGetMaxY(self.rightBtn.frame), CGRectGetMaxY(self.customView.frame)) + kButtonBottomOffset;
        afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - CGRectGetWidth(self.customView.frame)) * 0.5, (CGRectGetHeight(topVC.view.bounds) - height) * 0.5, CGRectGetWidth(self.customView.frame), height);
    } else{
        afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeight) * 0.5, kAlertWidth, kAlertHeight);
    }

    self.frame = afterFrame;
    
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
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
}

- (void)backImageViewTaped:(UITapGestureRecognizer *)recognizer
{
    if (self.touchOtherDismiss) {
        [self dismissAlert];
    }
}

@end

@implementation UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
