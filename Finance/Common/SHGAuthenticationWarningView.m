//
//  SHGAuthenticationWarningView.m
//  Finance
//
//  Created by changxicao on 16/6/22.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGAuthenticationWarningView.h"

@interface SHGAuthenticationWarningView ()

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIView *spliteView;
@property (strong, nonatomic) UIButton *button;

@end

@implementation SHGAuthenticationWarningView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
        [self addAutoLayout];
    }
    return self;
}

- (void)initView
{
    self.clipsToBounds = YES;
    self.backgroundColor = Color(@"fffef3");

    self.label = [[UILabel alloc] init];
    self.label.font = FontFactor(14.0f);
    self.label.textColor = Color(@"8a8654");

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.button setImage:[UIImage imageNamed:@"me_deleteInput"] forState:UIControlStateNormal];

    self.spliteView = [[UIView alloc] init];
    self.spliteView.backgroundColor = Color(@"ebebeb");

    [self sd_addSubviews:@[self.label, self.button, self.spliteView]];
}

- (void)addAutoLayout
{
    self.label.sd_layout
    .leftSpaceToView(self, MarginFactor(12.0f))
    .rightSpaceToView(self, 0.0f)
    .topSpaceToView(self, 0.0f)
    .bottomSpaceToView(self, 0.0f);

    self.button.sd_layout
    .heightRatioToView(self, 1.0f)
    .topSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .widthEqualToHeight();

    self.spliteView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .bottomSpaceToView(self, 0.0f)
    .heightIs(1 / SCALE);

}

- (void)setText:(NSString *)text
{
    _text = text;
    self.label.text = text;
}

- (void)buttonClick:(UIButton *)button
{
    if (self.block) {
        self.block();
    }
}


@end
