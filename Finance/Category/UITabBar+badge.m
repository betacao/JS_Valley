//
//  UITabBar+badge.m
//  Finance
//
//  Created by changxicao on 16/8/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "UITabBar+badge.h"

@implementation UITabBar (badge)

+ (void)tabBar:(UITabBar *)tabBar addBadgeValue:(NSString *)badgeValue atIndex:(NSInteger)index
{
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;

    UILabel *label = [[UILabel alloc] init];
    label.text = badgeValue;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = FontFactor(10.0f);
    label.backgroundColor = Color(@"d43c33");
    [badgeView addSubview:label];
    label.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f));
    label.sd_cornerRadiusFromHeightRatio = @(0.5f);

    //确定小红点的位置
    CGRect tabFrame = tabBar.frame;
    CGFloat percentX = (index + 0.5f) / tabBar.items.count;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1f * tabFrame.size.height);
    CGFloat width = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, label.font.lineHeight)].width;
    width = width > MarginFactor(15.0f) ? width : MarginFactor(15.0f);
    badgeView.frame = CGRectMake(x, y, width, MarginFactor(15.0f));
    badgeView.backgroundColor = [UIColor whiteColor];
    badgeView.layer.cornerRadius = CGRectGetHeight(badgeView.frame) / 2.0f;
    [tabBar addSubview:badgeView];
}

+ (void)tabBar:(UITabBar *)tabBar hideBadgeOnItemIndex:(NSInteger)index
{
    [UITabBar tabBar:tabBar removeBadgeOnItemIndex:index];
}

+ (void)tabBar:(UITabBar *)tabBar removeBadgeOnItemIndex:(NSInteger)index
{
    //按照tag值进行移除
    for (UIView *subView in tabBar.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
