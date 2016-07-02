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


@interface SHGHorizontalTitleImageButton()

@end

@implementation SHGHorizontalTitleImageButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    SHGHorizontalTitleImageButton *button = [super buttonWithType:buttonType];
    return button;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    self.imageView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .centerYEqualToView(self)
    .widthIs(image.size.width)
    .heightIs(image.size.height);
    [self setupAutoWidthWithRightView:self.titleLabel rightMargin:0.0f];
    [self setupAutoHeightWithBottomViewsArray:@[self.imageView, self.titleLabel] bottomMargin:0.0f];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    self.titleLabel.sd_resetLayout
    .leftSpaceToView(self.imageView, self.margin)
    .centerYEqualToView(self)
    .heightIs(ceilf(self.titleLabel.font.lineHeight));
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:MAXFLOAT];
    
}

- (void)setMargin:(CGFloat)margin
{
    _margin = margin;
    self.titleLabel.sd_layout
    .leftSpaceToView(self.imageView, margin)
    .centerYEqualToView(self)
    .heightIs(ceilf(self.titleLabel.font.lineHeight));
}

@end