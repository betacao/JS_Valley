//
//  SHGBusinessScrollView.m
//  Finance
//
//  Created by changxicao on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessScrollView.h"
#import "SHGBusinessObject.h"

#define kBusinessNormalFont  FontFactor(16.0f)

@interface SHGBusinessScrollView()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) CGFloat categoryWidth;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSMutableArray *buttonArrays;
@property (strong, nonatomic) UIView *redLineView;
@property (weak, nonatomic) UIButton *selectedButton;
@end

@implementation SHGBusinessScrollView
- (instancetype)initWithFrame:(CGRect)frame
{

    frame.size.height = kBusinessScrollViewHeight;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.delegate = self;

        [self addSubview:self.scrollView];

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, kBusinessScrollViewHeight - 0.5f, SCREENWIDTH, 0.5f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"e7e7e6"];
        [self addSubview:lineView];
    }
    return self;
}

- (void)setCategoryArray:(NSMutableArray *)categoryArray
{
    if (!_categoryArray) {
        _categoryArray = [NSMutableArray array];
    }
    [_categoryArray removeAllObjects];
    [_categoryArray addObjectsFromArray:categoryArray];
    [self setNeedsLayout];
}

- (NSMutableArray *)buttonArrays
{
    if (!_buttonArrays) {
        _buttonArrays = [NSMutableArray array];
    }
    return _buttonArrays;
}

- (UIView *)redLineView
{
    if (!_redLineView) {
        _redLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, kBusinessScrollViewHeight - 1.5f, 0.0f, 1.5f)];
        _redLineView.backgroundColor = [UIColor colorWithHexString:@"D82626"];
    }
    if (!_redLineView.superview) {
        [self.scrollView addSubview:_redLineView];
    }
    return _redLineView;
}


- (NSInteger)currentIndex
{
    return self.selectedIndex;
}


- (void)moveToIndex:(NSInteger)index
{
    self.selectedIndex = index;
}


- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    BOOL isChanged = _selectedIndex == selectedIndex ? NO : YES;
    _selectedIndex = selectedIndex;
    UIButton *button = [self.buttonArrays objectAtIndex:selectedIndex];
    if (self.selectedButton && ![button isEqual:self.selectedButton]) {
        [self.selectedButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    }
    self.selectedButton = button;
    [button setTitleColor:[UIColor colorWithHexString:@"D82626"] forState:UIControlStateNormal];

    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame = self.redLineView.frame;
        frame.origin.x = CGRectGetMinX(button.frame);
        frame.size.width = CGRectGetWidth(button.frame);
        self.redLineView.frame = frame;
    } completion:^(BOOL finished) {

    }];

    if (self.categoryDelegate && [self.categoryDelegate respondsToSelector:@selector(didMoveToIndex:)] && isChanged) {
        [self.categoryDelegate didMoveToIndex:selectedIndex];
    }

    //移动scrollview到相应的位置
    [self.scrollView scrollRectToVisible:button.frame animated:YES];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.categoryArray.count == 0) {
        return;
    }
    [self.scrollView removeAllSubviews];
    self.categoryWidth = 0.0f;
    [self.buttonArrays removeAllObjects];

    __block NSString *string = @"";
    [self.categoryArray enumerateObjectsUsingBlock:^(SHGBusinessFirstObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        string = [string stringByAppendingString:obj.name];
    }];

    CGFloat width = [string sizeWithAttributes:@{NSFontAttributeName:kBusinessNormalFont}].width;
    CGFloat margin = floorf(ABS(SCREENWIDTH - width) / self.categoryArray.count);
    [self.categoryArray enumerateObjectsUsingBlock:^(SHGBusinessFirstObject *object, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:object.name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = kBusinessNormalFont;
        CGSize size = [button sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.frame))];
        CGRect frame = button.frame;
        frame.size.width = size.width + margin;
        frame.size.height = CGRectGetHeight(self.frame);
        frame.origin.x = self.categoryWidth;
        frame.origin.y = 0.0f;
        button.frame = frame;
        self.categoryWidth = CGRectGetMaxX(frame);
        [self.scrollView addSubview:button];
        [self.buttonArrays addObject:button];
    }];
    self.scrollView.contentSize = CGSizeMake(self.categoryWidth, CGRectGetHeight(self.frame));
    self.selectedIndex = 0;

}

- (void)clickButton:(UIButton *)button
{
    NSInteger index = [self.buttonArrays indexOfObject:button];
    self.selectedIndex = index;
}


@end
