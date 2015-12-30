//
//  SHGCategoryScrollView.m
//  Finance
//
//  Created by changxicao on 15/12/11.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGCategoryScrollView.h"
#import "SHGMarketObject.h"
#define kCategoryObjectMargin 10.0f * XFACTOR
#define kCategoryNormalFont [UIFont systemFontOfSize:14.0f]
#define kCategorySelectFont [UIFont systemFontOfSize:15.0f]
@interface SHGCategoryScrollView ()
@property (assign, nonatomic) CGFloat categoryWidth;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSMutableArray *buttonArrays;
@property (strong, nonatomic) UIView *underLineView;
@property (weak, nonatomic) UIButton *selectedButton;
@end

@implementation SHGCategoryScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size.height = kCategoryScrollViewHeight;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    }
    return self;
}

- (NSString *)marketFirstId
{
    SHGMarketFirstCategoryObject *object = [self.categoryArray objectAtIndex:self.selectedIndex];
    return object.firstCatalogId;
}

- (NSString *)marketSecondId
{
    return @"";
}

- (NSInteger)currentIndex
{
    return self.selectedIndex;
}

- (void)setCategoryArray:(NSArray *)categoryArray
{
    _categoryArray = categoryArray;
    [self setNeedsLayout];
}

- (NSMutableArray *)buttonArrays
{
    if (!_buttonArrays) {
        _buttonArrays = [NSMutableArray array];
    }
    return _buttonArrays;
}

- (UIView *)underLineView
{
    if (!_underLineView) {
        _underLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, kCategoryScrollViewHeight - 1.0f, 0.0f, 1.50f)];
        _underLineView.backgroundColor = [UIColor colorWithHexString:@"D82626"];
        [self addSubview:_underLineView];
    }
    return _underLineView;
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
        self.selectedButton.titleLabel.font = kCategoryNormalFont;
    }
    self.selectedButton = button;
    [button setTitleColor:[UIColor colorWithHexString:@"DB2626"] forState:UIControlStateNormal];
    button.titleLabel.font = kCategorySelectFont;

    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame = self.underLineView.frame;
        frame.origin.x = CGRectGetMinX(button.frame);
        frame.size.width = CGRectGetWidth(button.frame);
        self.underLineView.frame = frame;
    } completion:^(BOOL finished) {

    }];
    if (self.categoryDelegate && [self.categoryDelegate respondsToSelector:@selector(didChangeToIndex:firstId:secondId:)] && isChanged) {
        [self.categoryDelegate didChangeToIndex:selectedIndex firstId:[self marketFirstId] secondId:[self marketSecondId]];
    }
    //移动scrollview到相应的位置
    [self scrollRectToVisible:button.frame animated:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.categoryArray.count == 0 || self.buttonArrays.count != 0) {
        return;
    }
    [self removeAllSubviews];
    [self.buttonArrays removeAllObjects];

    __block NSString *string = @"";
    [self.categoryArray enumerateObjectsUsingBlock:^(SHGMarketFirstCategoryObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        string = [string stringByAppendingString:obj.firstCatalogName];
    }];
    CGFloat width = [string sizeWithAttributes:@{NSFontAttributeName:kCategoryNormalFont}].width + self.categoryArray.count * 2.0f * kCategoryObjectMargin;
    if (width > SCREENWIDTH) {
        [self.categoryArray enumerateObjectsUsingBlock:^(SHGMarketFirstCategoryObject *object, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:object.firstCatalogName forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = kCategoryNormalFont;
            CGSize size = [button sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.frame))];
            CGRect frame = button.frame;
            frame.size.width = size.width + kCategoryObjectMargin / 2.0f;
            frame.size.height = CGRectGetHeight(self.frame);
            frame.origin.x = self.categoryWidth + kCategoryObjectMargin;
            frame.origin.y = 0.0f;
            button.frame = frame;
            self.categoryWidth = CGRectGetMaxX(frame);
            self.contentSize = CGSizeMake(self.categoryWidth, CGRectGetHeight(self.frame));
            [self addSubview:button];
            [self.buttonArrays addObject:button];
        }];
    } else{
        width = SCREENWIDTH / self.categoryArray.count;
        [self.categoryArray enumerateObjectsUsingBlock:^(SHGMarketFirstCategoryObject *object, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:object.firstCatalogName forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = kCategoryNormalFont;
            CGRect frame = button.frame;
            frame.size.width = width;
            frame.size.height = CGRectGetHeight(self.frame);
            frame.origin.x = self.categoryWidth;
            frame.origin.y = 0.0f;
            button.frame = frame;
            self.categoryWidth = CGRectGetMaxX(frame);
            self.contentSize = CGSizeMake(self.categoryWidth, CGRectGetHeight(self.frame));
            [self addSubview: button];
            [self.buttonArrays addObject:button];
        }];
    }
    self.selectedIndex = 0;
    
}

- (void)clickButton:(UIButton *)button
{
    NSInteger index = [self.buttonArrays indexOfObject:button];
    self.selectedIndex = index;
}

@end
