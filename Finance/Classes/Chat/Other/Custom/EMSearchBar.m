/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "EMSearchBar.h"

@implementation EMSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0.0f, 0.0f, SCREENWIDTH, 44.0f);
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = [UIColor colorWithHexString:@"161616"];
        self.translucent = NO;
        self.barTintColor = [UIColor colorWithHexString:@"E8E8E8"];
        self.searchBarStyle = UISearchBarStyleDefault;
        UIView *view = [self.subviews firstObject];
        for (id object in view.subviews) {
            if ([object isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                UITextField *textField = (UITextField *)object;
                textField.textColor = [UIColor colorWithHexString:@"161616"];
            } else if ([object isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
            } else{
            }
        }
        [self setImage:[UIImage imageNamed:@"emsearch_icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [self setSearchFieldBackgroundImage:[[UIImage imageNamed:@"search_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        self.backgroundImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"F8F9F9"] andSize:frame.size];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(frame) - 1.0f, SCREENWIDTH, 0.5f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"E6E7E8"];
        [self addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    UIView *view = [self.subviews firstObject];
    for (id object in view.subviews) {
        if ([object isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
        } else if ([object isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            UITextField *textField = (UITextField *)object;
            [textField setValue:[UIColor colorWithHexString:@"BEBEBE"] forKeyPath:@"_placeholderLabel.textColor"];
            [textField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
            textField.enablesReturnKeyAutomatically = NO;
        } else if ([object isKindOfClass:NSClassFromString(@"UINavigationButton")]){
            UIButton *button = (UIButton *)object;
            [button setTitle:@"取消" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"BEBEBE"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            button.enabled = YES;
        }
    }

}

/**
 *  自定义控件自带的取消按钮的文字（默认为“取消”/“Cancel”）
 *
 *  @param title 自定义文字
 */
- (void)setCancelButtonTitle:(NSString *)title
{
    for (UIView *searchbuttons in self.subviews)
    {
        if ([searchbuttons isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)searchbuttons;
//            cancelButton.titleLabel.textColor=[UIColor redColor];
            [cancelButton setTitle:title forState:UIControlStateNormal];
            break;
        }
    }
}

@end
