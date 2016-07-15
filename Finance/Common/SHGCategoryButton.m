//
//  SHGCategoryButton.m
//  Finance
//
//  Created by changxicao on 16/4/11.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCategoryButton.h"

@implementation SHGCategoryButton


@end


@interface SHGHorizontalTitleImageView()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *label;

@end

@implementation SHGHorizontalTitleImageView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.label = [[UILabel alloc] init];
        self.label.textColor = kMainActionColor;
        self.label.font = kMainActionFont;
        [self sd_addSubviews:@[self.imageView, self.label]];

        self.imageView.sd_layout
        .leftSpaceToView(self, 0.0f)
        .centerYEqualToView(self)
        .widthIs(0.0f)
        .heightIs(0.0f);

        self.label.sd_layout
        .leftSpaceToView(self.imageView, 0.0f)
        .centerYEqualToView(self)
        .heightIs(ceilf(self.label.font.lineHeight));
        [self.label setSingleLineAutoResizeWithMaxWidth:MAXFLOAT];

        [self setupAutoWidthWithRightView:self.label rightMargin:0.0f];
        [self setupAutoHeightWithBottomViewsArray:@[self.imageView, self.label] bottomMargin:0.0f];
    }
    return self;
}

- (void)addImage:(UIImage *)image
{
    self.imageView.image = image;
    self.imageView.sd_resetLayout
    .leftSpaceToView(self, 0.0f)
    .centerYEqualToView(self)
    .widthIs(image.size.width)
    .heightIs(image.size.height);
}

- (void)addTitle:(NSString *)title
{
    self.label.text = title;
    self.label.sd_resetLayout
    .leftSpaceToView(self.imageView, self.margin)
    .centerYEqualToView(self)
    .heightIs(ceilf(self.label.font.lineHeight));
}

- (void)setMargin:(CGFloat)margin
{
    _margin = margin;
    self.label.sd_resetLayout
    .leftSpaceToView(self.imageView, self.margin)
    .centerYEqualToView(self)
    .heightIs(ceilf(self.label.font.lineHeight));
}

- (void)target:(id)target addSeletor:(SEL)selector
{
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        [self removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:(selector)];
    [self addGestureRecognizer:recognizer];
}

@end