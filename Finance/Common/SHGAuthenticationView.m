//
//  SHGAuthenticationView.m
//  Finance
//
//  Created by changxicao on 16/6/23.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGAuthenticationView.h"

@interface SHGAuthenticationView ()

@property (strong, nonatomic) UIImageView *VButton;
@property (strong, nonatomic) UIImageView *QButton;

@property (assign, nonatomic) BOOL vStatus;
@property (assign, nonatomic) BOOL enterpriseStatus;

@end

@implementation SHGAuthenticationView

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    SHGAuthenticationView *button = [super buttonWithType:buttonType];
    if (button) {
        [button initView];
        [button addAutoLayout];
    }
    return button;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
//    self.backgroundColor = [UIColor greenColor];
    self.VButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v_gray"]];

    self.QButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enterprise_gray"]];
    self.VButton.hidden = self.QButton.hidden = YES;
    
    [self sd_addSubviews:@[self.VButton, self.QButton]];

    [self addTarget:self action:@selector(selfClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setEnlargeEdge:20.0f];
}

- (void)addAutoLayout
{
    self.VButton.sd_layout
    .leftSpaceToView(self, 0.0f)
    .bottomSpaceToView(self, 0.0f)
    .widthIs(MarginFactor(self.VButton.image.size.width))
    .heightIs(MarginFactor(self.VButton.image.size.height));

    self.QButton.sd_layout
    .leftSpaceToView(self.VButton, MarginFactor(5.0f))
    .bottomSpaceToView(self, 0.0f)
    .widthIs(MarginFactor(self.QButton.image.size.width))
    .heightIs(MarginFactor(self.QButton.image.size.height));

    [self setupAutoWidthWithRightView:self.QButton rightMargin:0.0f];
}

- (void)updateWithVStatus:(BOOL)vStatus enterpriseStatus:(BOOL)enterpriseStatus
{
    self.VButton.hidden = self.QButton.hidden = NO;
    self.vStatus = vStatus;
    self.enterpriseStatus = enterpriseStatus;

    self.VButton.image = vStatus ? [UIImage imageNamed:@"v_yellow"] : [UIImage imageNamed:@"v_gray"];
    self.QButton.image = enterpriseStatus ? [UIImage imageNamed:@"enterprise_blue"] : [UIImage imageNamed:@"enterprise_gray"];
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
            .bottomSpaceToView(self, 0.0f)
            .widthIs(MarginFactor(self.QButton.image.size.width))
            .heightIs(MarginFactor(self.QButton.image.size.height));
        } else{
            self.QButton.sd_resetLayout
            .leftSpaceToView(self, 0.0f)
            .bottomSpaceToView(self, 0.0f)
            .widthIs(MarginFactor(self.QButton.image.size.width))
            .heightIs(MarginFactor(self.QButton.image.size.height));
        }
        [self setupAutoWidthWithRightView:enterpriseStatus ? self.QButton : self.VButton rightMargin:(enterpriseStatus | self.vStatus) ? 0.0f : -self.VButton.image.size.width];
    }
}

- (void)selfClick:(id)sender
{
    if (self.block) {
        self.block();
    }
}

@end
