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

#import "EMTextView.h"

@implementation EMTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _contentColor = [UIColor blackColor];
        _placeholderColor = [UIColor colorWithHexString:@"d3d3d3"];
        _editing = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    }
    return self;
}

- (void)awakeFromNib
{
    _contentColor = [UIColor blackColor];
    _placeholderColor = [UIColor colorWithHexString:@"d3d3d3"];
    _editing = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishEditing:) name:UITextViewTextDidEndEditingNotification object:self];
}

#pragma mark - super

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    
    _contentColor = textColor;
}

- (NSString *)text
{
    if ([super.text isEqualToString:_placeholder]) {
        return @"";
    }
    
    return [super text];
}

- (void)setText:(NSString *)string
{
    if (string == nil || string.length == 0) {
        return;
    }
    
    super.textColor = _contentColor;
    [super setText:string];
}

#pragma mark - setting

- (void)setPlaceholder:(NSString *)string
{
    _placeholder = string;
    
    [self finishEditing:nil];
}

- (void)setPlaceholderColor:(UIColor *)color
{
    _placeholderColor = color;
}

#pragma mark - notification

- (void)startEditing:(NSNotification *)notification
{
    _editing = YES;
    
    if ([super.text isEqualToString:_placeholder]) {
        super.textColor = _contentColor;
        super.text = @"";
    }

}

- (void)finishEditing:(NSNotification *)notification
{
    _editing = NO;
    
    if (super.text.length == 0) {
        super.textColor = _placeholderColor;
        super.text = _placeholder;
    }
    else{
        super.textColor = _contentColor;
    }
}

- (void)_firstBaselineOffsetFromTop
{
}

- (void)_baselineOffsetFromBottom
{
}

@end
