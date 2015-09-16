//
//  BasePopupView.h
//  DingDCommunity
//
//  Created by JianjiYuan on 14-3-17.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasePopupView : UIView

@property (nonatomic, strong) UIView *viewContainer;

- (id)initWithFrame:(CGRect)frame superFrame:(CGRect)superFrame isController:(BOOL)isController type:(NSString *)type name:(NSString *)name;

- (id)initWithFrame:(CGRect)frame superFrame:(CGRect)superFrame isController:(BOOL)isController;

- (id)initWithFrame:(CGRect)frame superFrame:(CGRect)superFrame isController:(BOOL)isController defaultDate:(NSString *) defaultDate;

- (id)initWithFrame:(CGRect)frame superFrame:(CGRect)superFrame isController:(BOOL)isController type:(NSString *)type;

- (void)reloadDatas;
- (void)showWithAnimated:(BOOL)animated;
- (void)hideWithAnimated:(BOOL)animated;

@end
