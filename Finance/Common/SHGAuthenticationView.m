//
//  SHGAuthenticationView.m
//  Finance
//
//  Created by changxicao on 16/6/23.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGAuthenticationView.h"

@interface SHGAuthenticationView ()

@property (strong, nonatomic) UIImageView *imageView;

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
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v_normal_yellow"]];
    [self addSubview:self.imageView];
}

- (void)addAutoLayout
{
    self.imageView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .topSpaceToView(self, 0.0f)
    .widthIs(MarginFactor(self.imageView.image.size.width))
    .heightIs(MarginFactor(self.imageView.image.size.height));
    [self setupAutoWidthWithRightView:self.imageView rightMargin:MarginFactor(5.0f)];
    [self setupAutoHeightWithBottomView:self.imageView bottomMargin:0.0f];
}

- (void)updateWithStatus:(BOOL)status
{
    self.imageView.image = status ? [UIImage imageNamed:@"v_normal_yellow"] : [UIImage imageNamed:@"v_normal_gray"];
    if (status) {
        [self setupAutoWidthWithRightView:self.imageView rightMargin:MarginFactor(5.0f)];
    } else {
        [self setupAutoWidthWithRightView:self.imageView rightMargin:-MarginFactor(self.imageView.image.size.width)];
    }
}

@end
