//
//  SHGBusinessCategoryContentView.m
//  Finance
//
//  Created by changxicao on 16/4/8.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessButtonContentView.h"

@interface SHGBusinessButtonContentView()

@end

@implementation SHGBusinessButtonContentView

- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    if ([subview isKindOfClass:[UIButton class]]) {
        [self.buttonArray addObject:subview];
    }
}

- (void)didClickButton:(UIButton *)button
{
    BOOL selected = button.isSelected;
    if ([self.buttonArray indexOfObject:button] == 0) {
        //全部重置为非选
        [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
        }];
    } else {
        if (((UIButton *)[self.buttonArray firstObject]).isSelected) {
            ((UIButton *)[self.buttonArray firstObject]).selected = NO;
        }
    }
    button.selected = !selected;
}

@end