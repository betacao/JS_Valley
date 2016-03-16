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
    self.needLineView = YES;
    self = [super initWithFrame:frame];
    if (self) {
        self.translucent = NO;
        self.barTintColor = [UIColor colorWithHexString:@"E8E8E8"];
        self.searchBarStyle = UISearchBarStyleDefault;
        UIView *view = [self.subviews firstObject];
        for (id object in view.subviews) {
            if ([object isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                UITextField *textField = (UITextField *)object;
                textField.textColor = Color(@"3c3c3c");
                [textField setValue:Color(@"bebebe") forKeyPath:@"_placeholderLabel.textColor"];
                [textField setValue:FontFactor(15.0f) forKeyPath:@"_placeholderLabel.font"];
                textField.enablesReturnKeyAutomatically = NO;

            } else if ([object isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
            } else{
            }
        }
        [self setImage:[UIImage imageNamed:@"emsearch_icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
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

        } else if ([object isKindOfClass:NSClassFromString(@"UINavigationButton")]){
            UIButton *button = (UIButton *)object;
            [button setTitle:@"取消" forState:UIControlStateNormal];
            if (!self.cancelButtonTitleColor) {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else{
                [button setTitleColor:self.cancelButtonTitleColor forState:UIControlStateNormal];
            }
            button.titleLabel.font = FontFactor(15.0f);
            button.enabled = YES;
        } else{
            if (!self.needLineView) {
                UIView *view = (UIView *)object;
                [view removeFromSuperview];
            }
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
