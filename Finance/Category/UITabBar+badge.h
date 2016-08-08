//
//  UITabBar+badge.h
//  Finance
//
//  Created by changxicao on 16/8/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

+ (void)tabBar:(UITabBar *)tabBar addBadgeValue:(NSString *)badgeValue atIndex:(NSInteger)index;

+ (void)tabBar:(UITabBar *)tabBar hideBadgeOnItemIndex:(NSInteger)index; //隐藏小红点

@end
