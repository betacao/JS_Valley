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
    self = [super initWithFrame:frame];
    if (self) {

//        [self setSearchFieldBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"F8F9F9"] andSize:frame.size] forState:UIControlStateNormal];

        self.searchBarStyle = UISearchBarStyleDefault;
        self.barTintColor = [UIColor colorWithHexString:@"F8F9F9"];        UIView *view = [self.subviews firstObject];
        for (id object in view.subviews) {
            if ([object isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            } else if ([object isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                UITextField *textField = (UITextField *)object;
                textField.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
            } else{
                UIButton *button = (UIButton *)object;
                [button setTitle:@"取消" forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
                button.enabled = YES;
            }
        }
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
            textField.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
        } else{
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
