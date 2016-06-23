//
//  SHGAuthenticationView.m
//  Finance
//
//  Created by changxicao on 16/6/23.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGAuthenticationView.h"

@interface SHGAuthenticationView ()

@property (strong, nonatomic) UIButton *VButton;
@property (strong, nonatomic) UIButton *QButton;

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
    self.VButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.VButton setImage:[UIImage imageNamed:@"v_gray"] forState:UIControlStateNormal];

    self.QButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.QButton setImage:[UIImage imageNamed:@"enterprise_gray"] forState:UIControlStateNormal];

    [self sd_addSubviews:@[self.VButton, self.QButton]];
}

- (void)addAutoLayout
{
    self.VButton.sd_layout
    .leftSpaceToView(self, MarginFactor(12.0f))
    .centerYEqualToView(self)
    .widthIs(self.VButton.currentImage.size.width)
    .heightIs(self.VButton.currentImage.size.height);

    self.QButton.sd_layout
    .leftSpaceToView(self.VButton, MarginFactor(5.0f))
    .centerYEqualToView(self)
    .widthIs(self.QButton.currentImage.size.width)
    .heightIs(self.QButton.currentImage.size.height);

    [self setupAutoWidthWithRightView:self.QButton rightMargin:MarginFactor(12.0f)];
}

- (void)updateWithVStatus:(BOOL)vStatus enterpriseStatus:(BOOL)enterpriseStatus
{
    self.vStatus = vStatus;
    self.enterpriseStatus = enterpriseStatus;

    [self.VButton setImage:vStatus ? [UIImage imageNamed:@"v_yellow"] : [UIImage imageNamed:@"v_gray"] forState:UIControlStateNormal];
    [self.QButton setImage:enterpriseStatus ? [UIImage imageNamed:@"enterprise_blue"] : [UIImage imageNamed:@"enterprise_gray"] forState:UIControlStateNormal];
}

- (void)setVStatus:(BOOL)vStatus
{
    _vStatus = vStatus;
    if (!self.showGray) {
        self.VButton.hidden = !vStatus;
    }
}

- (void)setEnterpriseStatus:(BOOL)enterpriseStatus
{
    _enterpriseStatus = enterpriseStatus;
    if (!self.showGray) {
        self.QButton.hidden = !enterpriseStatus;
        if (self.vStatus) {
            self.QButton.sd_resetLayout
            .leftSpaceToView(self.VButton, MarginFactor(5.0f))
            .centerYEqualToView(self)
            .widthIs(self.QButton.currentImage.size.width)
            .heightIs(self.QButton.currentImage.size.height);
        } else{
            self.QButton.sd_resetLayout
            .leftSpaceToView(self, MarginFactor(12.0f))
            .centerYEqualToView(self)
            .widthIs(self.QButton.currentImage.size.width)
            .heightIs(self.QButton.currentImage.size.height);
        }
        [self setupAutoWidthWithRightView:enterpriseStatus ? self.QButton : self.VButton rightMargin:(enterpriseStatus | self.vStatus) ? MarginFactor(12.0f) : - self.VButton.currentImage.size.width];
    }
}


@end
