//
//  UIView+HUD.h
//  OMNI
//
//  Created by changxicao on 16/5/16.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HUD)

- (void)showLoading;
- (void)showWithText:(NSString *)text;
- (void)hideHud;

- (void)showWithText:(NSString *)text enable:(BOOL)enable duration:(NSTimeInterval)duration;

- (void)removeAllSubviews;

@end