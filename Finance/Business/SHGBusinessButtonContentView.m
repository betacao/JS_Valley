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

- (instancetype)initWithMode:(SHGBusinessButtonShowMode)mode
{
    self = [super init];
    if (self) {
        self.showMode = mode;
    }
    return self;
}


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
    if (self.showMode == SHGBusinessButtonShowModeExclusiveChoice) {
        //排他性选择
        //默认第一个排他
        BOOL selected = button.isSelected;
        if ([self.buttonArray indexOfObject:button] == self.exclusiveIndex) {
            //全部重置为非选
            [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.selected = NO;
            }];
        } else {
            if (((UIButton *)[self.buttonArray objectAtIndex:self.exclusiveIndex]).isSelected) {
                ((UIButton *)[self.buttonArray objectAtIndex:self.exclusiveIndex]).selected = NO;
            }
        }
        button.selected = !selected;
    } else if (self.showMode == SHGBusinessButtonShowModeSingleChoice) {
        BOOL selected = button.isSelected;
        //全部重置为非选
        [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
        }];
        button.selected = !selected;
    } else {
        BOOL selected = button.isSelected;
        button.selected = !selected;
    }

}

- (NSMutableArray *)selectedArray
{
    NSMutableArray *result = [NSMutableArray array];
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:[UIButton class]] && obj.isSelected) {
            [result addObject:obj.titleLabel.text];
        } else if ([obj isMemberOfClass:[SHGCategoryButton class]] && obj.isSelected) {
            [result addObject:((SHGCategoryButton *)obj).object];
        }
    }];
    return result;

}

@end