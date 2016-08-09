//
//  SHGSegmentTitleView.m
//  Finance
//
//  Created by changxicao on 16/8/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGSegmentTitleView.h"

@interface SHGSegmentTitleView()

@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *rightImageView;

@end

@implementation SHGSegmentTitleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.buttonArray = [NSMutableArray array];
        [self initView];
    }
    return self;
}

- (void)initView
{
    UIImage *image1 = [[UIImage imageNamed:@"title_left"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f) resizingMode:UIImageResizingModeStretch];
    UIImage *image2 = [[UIImage imageNamed:@"title_right"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 16.0f, 2.0f, 2.0f) resizingMode:UIImageResizingModeStretch];

    self.leftImageView = [[UIImageView alloc] initWithImage:image1];
//    self.leftImageView

    self.rightImageView = [[UIImageView alloc] initWithImage:image2];

    [self addSubview:self.leftImageView];
    [self addSubview:self.rightImageView];
}

- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    [titleArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:obj forState:UIControlStateNormal];
        button.titleLabel.font = FontFactor(15.0f);
        [button sizeToFit];
        button.frame = CGRectMake(CGRectGetMaxX(self.frame), 0.0f, CGRectGetWidth(button.frame), CGRectGetHeight(button.frame));
        button.centerY = kNavigationBarHeight / 2.0f;
        self.frame = CGRectMake(0.0f, 0.0f, CGRectGetMaxX(button.frame) + self.margin, kNavigationBarHeight);
        [self addSubview:button];
        [self.buttonArray addObject:button];
    }];
    self.size = CGSizeMake(CGRectGetWidth(self.frame) - self.margin, CGRectGetHeight(self.frame));
    UIButton *button = [self.buttonArray firstObject];
    [self buttonClick:button];
}

- (void)buttonClick:(UIButton *)button
{
    if (self.block) {
        self.block([self.buttonArray indexOfObject:button]);
    }
    CGFloat x = button.centerX;
    CGRect frame1 = CGRectMake(0.0f - self.rightImageView.image.size.width / 2.0f, kNavigationBarHeight - self.leftImageView.image.size.height, x, self.leftImageView.image.size.height);

    CGRect frame2 = CGRectMake(x - self.rightImageView.image.size.width / 2.0f, kNavigationBarHeight - self.rightImageView.image.size.height, CGRectGetWidth(self.frame) - x, self.rightImageView.image.size.height);

    [UIView animateWithDuration:0.25f animations:^{
        self.leftImageView.frame = frame1;
        self.rightImageView.frame = frame2;
    }];

}

@end
