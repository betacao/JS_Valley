//
//  SHGCategoryScrollView.m
//  Finance
//
//  Created by changxicao on 15/12/11.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGCategoryScrollView.h"
#import "SHGMarketObject.h"
#define kCategoryObjectMargin MarginFactor(15.0f)
#define kCategoryNormalFont  FontFactor(14.0f)
#define kCategorySelectFont  FontFactor(15.0f)

@interface SHGCategoryScrollView ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) CGFloat categoryWidth;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSMutableArray *buttonArrays;
@property (strong, nonatomic) UIView *underLineView;
@property (strong, nonatomic) UIImageView *blurImageView;
@property (weak, nonatomic) UIButton *selectedButton;
@end

@implementation SHGCategoryScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
   
    frame.size.height = kCategoryScrollViewHeight;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
    }
    return self;
}

- (NSString *)marketFirstId
{
    if (self.categoryArray && self.categoryArray.count > self.selectedIndex) {
        SHGMarketFirstCategoryObject *object = [self.categoryArray objectAtIndex:self.selectedIndex];
        //区分对象实际上是一级还是二级
        if ([object.parentId isEqualToString:@"-1"]) {
            return object.firstCatalogId;
        } else{
            return object.parentId;
        }

    }
    return @"";
}

- (NSString *)marketSecondId
{
    if (self.categoryArray && self.categoryArray.count > self.selectedIndex) {
        SHGMarketFirstCategoryObject *object = [self.categoryArray objectAtIndex:self.selectedIndex];
        //区分对象实际上是一级还是二级
        if ([object.parentId isEqualToString:@"-1"]) {
            return @"";
        } else{
            return object.firstCatalogId;
        }

    }
    return @"";
}

- (NSString *)marketName
{
    if (self.categoryArray && self.categoryArray.count > self.selectedIndex) {
        SHGMarketFirstCategoryObject *object = [self.categoryArray objectAtIndex:self.selectedIndex];
        return object.firstCatalogName;

    }
    return @"";
}

- (NSInteger)currentIndex
{
    return self.selectedIndex;
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

- (UIView *)underLineView
{
    if (!_underLineView) {
        _underLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, kCategoryScrollViewHeight - 1.5f, 0.0f, 1.5f)];
        _underLineView.backgroundColor = [UIColor colorWithHexString:@"D82626"];
    }
    if (!_underLineView.superview) {
        [self.scrollView addSubview:_underLineView];
    }
    return _underLineView;
}

- (UIImageView *)blurImageView
{
    if (!_blurImageView) {
        UIImage *blurImage = [UIImage imageNamed:@"more_Categoryblur"];
        _blurImageView = [[UIImageView alloc] init];
        _blurImageView.image = blurImage;
        [_blurImageView sizeToFit];
        [self.scrollView insertSubview:_blurImageView belowSubview:self.underLineView];

        CGPoint point = CGPointMake(CGRectGetWidth(self.frame) - blurImage.size.width, (CGRectGetHeight(self.frame) - blurImage.size.height) / 2.0f);
        point = [self convertPoint:point toView:self.scrollView];
        _blurImageView.origin = point;
    }
    if (!_blurImageView.superview) {
        [self.scrollView insertSubview:_blurImageView belowSubview:self.underLineView];
    }
    return _blurImageView;
}

- (void)moveToIndex:(NSInteger)index
{
    self.selectedIndex = index;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    self.blurImageView.alpha = 1.0f;
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
    [self.scrollView scrollRectToVisible:button.frame animated:YES];

    NSString *umentString = [@"ActionMarketTypeCode" stringByAppendingString:[self marketFirstId]];
    [MobClick event:umentString label:@"onClick"];
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
            self.scrollView.contentSize = CGSizeMake(self.categoryWidth, CGRectGetHeight(self.frame));
            [self.scrollView addSubview:button];
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
            self.scrollView.contentSize = CGSizeMake(self.categoryWidth, CGRectGetHeight(self.frame));
            [self.scrollView addSubview: button];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIImage *blurImage = [UIImage imageNamed:@"more_Categoryblur"];
    CGPoint point = CGPointMake(CGRectGetWidth(self.frame) - blurImage.size.width, (CGRectGetHeight(self.frame) - blurImage.size.height) / 2.0f);
    point = [self convertPoint:point toView:self.scrollView];
    self.blurImageView.origin = point;
}

@end
