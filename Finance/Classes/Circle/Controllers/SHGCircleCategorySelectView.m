//
//  SHGCircleCategorySelectView.m
//  Finance
//
//  Created by changxicao on 16/8/17.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCircleCategorySelectView.h"
#import "SHGBusinessButtonContentView.h"

#define kButtonHorizontalMargin MarginFactor(25.0f)
#define kButtonVerticalMargin MarginFactor(19.0f)

@interface SHGCircleCategorySelectView()

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) SHGBusinessButtonContentView *contentView;
@property (strong, nonatomic) NSMutableArray *buttonArray;
@end

@implementation SHGCircleCategorySelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:NOTIFI_SENDPOST object:nil];
    }
    return self;
}

- (void)initView
{
    self.clipsToBounds = YES;
    self.backgroundColor = ColorA(@"000000", 0.5f);
    self.contentView = [[SHGBusinessButtonContentView alloc] initWithMode:SHGBusinessButtonShowModeSingleChoice];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.buttonArray = [NSMutableArray array];
    self.titleArray = @[@"全部",@"债权融资",@"股权融资",@"资金",@"银证业务",@"其他"];
    CGFloat width = ceilf((SCREENWIDTH - 4.0f * kButtonHorizontalMargin) / 3.0f);
    CGFloat height = MarginFactor(26.0f);
    UIImage *defaultImage = [[UIImage imageNamed:@"circle_typeUnSelect"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
    UIImage *selectedImage = [[UIImage imageNamed:@"circle_typeSelect"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
    __block UIButton *lastButton = nil;
    [self.titleArray enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger num = idx / 3;
        NSInteger col = idx % 3;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:text forState:UIControlStateNormal];
        [button setTitleColor:Color(@"8a8a8a") forState:UIControlStateNormal];
        [button setBackgroundImage:defaultImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGRect frame = CGRectMake(kButtonHorizontalMargin + col * (width + kButtonHorizontalMargin), kButtonVerticalMargin + num * (height + kButtonVerticalMargin), width, height);
        button.frame = frame;
        button.titleLabel.font = FontFactor(14.0f);
        button.adjustsImageWhenHighlighted = NO;
        if (idx) {
            [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
            [button setTitleColor:Color(@"ff2f00") forState:UIControlStateSelected];
        }
        [self.buttonArray addObject:button];
        [self.contentView addSubview:button];
        lastButton = button;
    }];
    [self addSubview:self.contentView];

    self.contentView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .widthIs(SCREENWIDTH)
    .topSpaceToView(self, 0.0f);
    [self.contentView setupAutoHeightWithBottomView:lastButton bottomMargin:kButtonVerticalMargin];

}

- (void)setAlpha:(CGFloat)alpha
{
    [UIView animateWithDuration:0.25f animations:^{
        [super setAlpha:alpha];
    }];
}

- (void)refreshData
{
    [self buttonClick:[self.buttonArray firstObject]];
}

- (void)buttonClick:(UIButton *)button
{
    if (!button.isSelected) {
        [self.contentView didClickButton:button];
        if (self.block) {
            self.block(button.titleLabel.text);
        }
    }
    self.alpha = 0.0f;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.block) {
        self.block([self.titleArray firstObject]);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.alpha = 0.0f;
}

@end
