//
//  SHGTitleLabelCenterButton.m
//  Finance
//
//  Created by weiqiankun on 16/7/8.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGTitleLabelCenterButton.h"

@implementation SHGTitleLabelCenterButton

- (void)setTitle:(NSString *)title image:(UIImage *)image
{
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateNormal];
    [self resetInsets];
    
}

- (void)resetInsets
{
    
    CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // 找出imageView最终的center
    CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, buttonBoundsCenter.y - (self.margain + CGRectGetHeight(self.imageView.frame)) / 2.0f);
    
    // 找出titleLabel最终的center
    CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, buttonBoundsCenter.y + (self.margain + CGRectGetHeight(self.titleLabel.frame)) / 2.0f);
    
    // 取得imageView最初的center
    CGPoint startImageViewCenter = self.imageView.center;
    
    // 取得titleLabel最初的center
    CGPoint startTitleLabelCenter = self.titleLabel.center;
    
    // 设置imageEdgeInsets
    CGFloat imageEdgeInsetsTop = endImageViewCenter.y - startImageViewCenter.y;
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.imageEdgeInsets)) {
        self.imageEdgeInsets = imageEdgeInsets;
    }
    
    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y-startTitleLabelCenter.y;
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    UIEdgeInsets titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.titleEdgeInsets)) {
        self.titleEdgeInsets = titleEdgeInsets;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.titleLabel.frame;
    frame.size.width = self.width;
    self.titleLabel.frame = frame;
}

@end
