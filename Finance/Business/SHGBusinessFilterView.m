//
//  SHGBusinessFilterView.m
//  Finance
//
//  Created by changxicao on 16/4/6.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessFilterView.h"
#import "SHGBusinessMargin.h"
#import "SHGBusinessListViewController.h"
#import "UIButton+EnlargeEdge.h"
#import "SHGBusinessSelectCategoryViewController.h"
#import "SHGBusinessObject.h"

@interface SHGBusinessFilterView()

@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *middleButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *backgroundView;

@end

@implementation SHGBusinessFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self addAutoLayout];
    }
    return self;
}

- (void)initView
{
    self.clipsToBounds = YES;
    self.backgroundColor = Color(@"f0f0f0");

    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setTitle:@"高级筛选" forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = FontFactor(15.0f);
    [self.leftButton setTitleColor:Color(@"256ebf") forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton sizeToFit];
    [self addSubview:self.leftButton];

    self.middleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.middleButton setImage:[UIImage imageNamed:@"down_dark0"] forState:UIControlStateNormal];
    [self.middleButton sizeToFit];
    [self addSubview:self.middleButton];

    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setImage:[UIImage imageNamed:@"business_condition"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton sizeToFit];
    [self.rightButton setEnlargeEdge:20.0f];
    [self addSubview:self.rightButton];

    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = self.backgroundColor;
    [self addSubview:self.contentView];

}



- (void)addAutoLayout
{
    CGSize size = self.leftButton.frame.size;
    self.leftButton.sd_layout
    .leftSpaceToView(self, MarginFactor(12.0f))
    .topSpaceToView(self, MarginFactor(10.0f))
    .widthIs(size.width)
    .heightIs(ceilf(self.leftButton.titleLabel.font.lineHeight));

    size = self.middleButton.frame.size;
    self.middleButton.sd_layout
    .leftSpaceToView(self.leftButton, MarginFactor(5.0f))
    .centerYEqualToView(self.leftButton)
    .widthIs(size.width)
    .heightIs(size.height);

    size = self.rightButton.frame.size;
    self.rightButton.sd_layout
    .rightSpaceToView(self, MarginFactor(17.0f))
    .centerYEqualToView(self.leftButton)
    .widthIs(size.width)
    .heightIs(size.height);

    self.contentView.sd_layout
    .rightSpaceToView(self, 0.0f)
    .leftSpaceToView(self, 0.0f)
    .topSpaceToView(self.leftButton, MarginFactor(10.0f))
    .heightIs(0.0f);

    [self setupAutoHeightWithBottomView:self.contentView bottomMargin:0.0f];
}

- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        UITableView *tableView = [SHGBusinessListViewController sharedController].tableView;
        _backgroundView = [[UIView alloc] initWithFrame:tableView.frame];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTaped:)];
        [_backgroundView addGestureRecognizer:recognizer];
    }
    return _backgroundView;
}

- (void)setExpand:(BOOL)expand
{
    if (_expand == expand) {
        return;
    }
    _expand = expand;

    if (expand) {
        [self.contentView setupAutoHeightWithBottomView:[self.buttonArray lastObject] bottomMargin:MarginFactor(10.0f)];
        [UIView animateWithDuration:0.25f animations:^{
            [self.contentView updateLayout];
            self.rightButton.layer.transform = CATransform3DMakeRotation(0.000001 - M_PI, 0.0f, 0.0f, 1.0f);
        }];

        UIView *view = [SHGBusinessListViewController sharedController].view;
        [view insertSubview:self.backgroundView aboveSubview:[SHGBusinessListViewController sharedController].addBusinessButton];

    } else{

        [self.contentView setupAutoHeightWithBottomView:[self.contentView.subviews firstObject] bottomMargin:MarginFactor(0.0f)];
        [UIView animateWithDuration:0.25f animations:^{
            [self.contentView updateLayout];
            self.rightButton.layer.transform = CATransform3DIdentity;
        }];

        [self.backgroundView removeFromSuperview];
    }
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    CGFloat width = ceilf((SCREENWIDTH - kLeftToView * 6.0f) / 3.0f);
    [self.contentView removeAllSubviews];
    [self.buttonArray removeAllObjects];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:label];

    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSInteger row = idx / 3;
        NSInteger col = idx % 3;
        CGRect frame = CGRectMake(((2.0f * col) + 1) * kLeftToView + col * width, row * (MarginFactor(26.0f) + MarginFactor(10.0f)), width, MarginFactor(26.0f));
        button.frame = frame;
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:Color(@"f04241") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[[UIImage imageNamed:@"business_filterBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 12.0f, 0.0f, 22.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        button.titleLabel.font = FontFactor(13.0f);
        [self.contentView addSubview:button];
        [self.buttonArray addObject: button];
    }];

    //控制左按钮显示的文字
    if (dataArray.count > 0) {
        [self.leftButton setTitle:@"更多筛选条件" forState:UIControlStateNormal];
        self.middleButton.hidden = YES;
    } else{
        [self.leftButton setTitle:@"高级筛选" forState:UIControlStateNormal];
        self.middleButton.hidden = NO;
    }
    CGSize size = [self.leftButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.leftButton.frame))];
    self.leftButton.width = size.width;
}

- (void)leftButtonClicked:(UIButton *)button
{
    SHGBusinessSelectCategoryViewController *controller = [[SHGBusinessSelectCategoryViewController alloc] init];
    controller.firstType = self.firstType;
    [[SHGBusinessListViewController sharedController].navigationController pushViewController:controller animated:YES];
}

- (void)rightButtonClicked:(UIButton *)button
{
    self.expand = !self.expand;
}

- (void)buttonClicked:(UIButton *)button
{
    NSInteger index = [self.buttonArray indexOfObject:button];
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:self.dataArray];
    [array removeObjectAtIndex:index];
    self.dataArray = array;
    if (self.buttonArray.count > 0) {
        [self.contentView setupAutoHeightWithBottomView:[self.buttonArray lastObject] bottomMargin:MarginFactor(10.0f)];
    } else{
        [self.contentView setupAutoHeightWithBottomView:[self.contentView.subviews firstObject] bottomMargin:MarginFactor(0.0f)];
    }
    [UIView animateWithDuration:0.25f animations:^{
        [self.contentView updateLayout];
    }];
}

- (void)backgroundViewTaped:(UITapGestureRecognizer *)recognizer
{
    [self rightButtonClicked:nil];
}

@end
