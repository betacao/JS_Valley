//
//  SHGAuthenticationView.m
//  Finance
//
//  Created by changxicao on 16/6/23.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGAuthenticationView.h"

@interface SHGAuthenticationView ()

@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *rightImageView;

@property (assign, nonatomic) BOOL vStatus;
@property (assign, nonatomic) BOOL enterpriseStatus;

@end

@implementation SHGAuthenticationView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
        [self addAutoLayout];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v_gray"]];

    self.rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enterprise_gray"]];
    self.leftImageView.hidden = self.rightImageView.hidden = YES;
    
    [self sd_addSubviews:@[self.leftImageView, self.rightImageView]];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfClick:)];
    [self addGestureRecognizer:recognizer];
}

- (void)addAutoLayout
{
    self.leftImageView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .bottomSpaceToView(self, 0.0f)
    .widthIs(MarginFactor(self.leftImageView.image.size.width))
    .heightIs(MarginFactor(self.leftImageView.image.size.height));

    self.rightImageView.sd_layout
    .leftSpaceToView(self.leftImageView, MarginFactor(5.0f))
    .bottomSpaceToView(self, 0.0f)
    .widthIs(MarginFactor(self.rightImageView.image.size.width))
    .heightIs(MarginFactor(self.rightImageView.image.size.height));

    [self setupAutoWidthWithRightView:self.rightImageView rightMargin:0.0f];
}

- (void)updateWithVStatus:(BOOL)vStatus enterpriseStatus:(BOOL)enterpriseStatus
{
    self.leftImageView.hidden = self.rightImageView.hidden = NO;
    self.vStatus = vStatus;
    self.enterpriseStatus = enterpriseStatus;

    self.leftImageView.image = vStatus ? [UIImage imageNamed:@"v_yellow"] : [UIImage imageNamed:@"v_gray"];
    self.rightImageView.image = enterpriseStatus ? [UIImage imageNamed:@"enterprise_blue"] : [UIImage imageNamed:@"enterprise_gray"];
}

- (void)setVStatus:(BOOL)vStatus
{
    _vStatus = vStatus;
    if (!self.showGray) {
        self.leftImageView.hidden = !vStatus;
    }
}

- (void)setEnterpriseStatus:(BOOL)enterpriseStatus
{
    _enterpriseStatus = enterpriseStatus;
    if (!self.showGray) {
        self.rightImageView.hidden = !enterpriseStatus;
        if (self.vStatus) {
            self.rightImageView.sd_resetLayout
            .leftSpaceToView(self.leftImageView, MarginFactor(5.0f))
            .bottomSpaceToView(self, 0.0f)
            .widthIs(MarginFactor(self.rightImageView.image.size.width))
            .heightIs(MarginFactor(self.rightImageView.image.size.height));
        } else{
            self.rightImageView.sd_resetLayout
            .leftSpaceToView(self, 0.0f)
            .bottomSpaceToView(self, 0.0f)
            .widthIs(MarginFactor(self.rightImageView.image.size.width))
            .heightIs(MarginFactor(self.rightImageView.image.size.height));
        }
        UIView *view = enterpriseStatus ? self.rightImageView : self.leftImageView;
        CGFloat margin = (enterpriseStatus | self.vStatus) ? 0.0f : -self.leftImageView.image.size.width;
        [self setupAutoWidthWithRightView:view rightMargin: margin];
    }
}

- (void)selfClick:(id)sender
{
    if (self.block) {
        self.block();
    }
}

@end
