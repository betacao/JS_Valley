//
//  SHGRecommendHeaderView.m
//  Finance
//
//  Created by weiqiankun on 16/4/26.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGRecommendHeaderView.h"
@interface SHGRecommendHeaderView ()
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *lineView;
@end
@implementation SHGRecommendHeaderView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, MarginFactor(45.0f))];
    if (self) {

        [self addSubview:self.bgView];
        [self addSDLayout];
    }
    return self;
}

- (void)addSDLayout
{
    self.bgView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .topSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .bottomSpaceToView(self, 0.0f);
    
    self.lineView.sd_layout
    .leftSpaceToView(self.bgView, MarginFactor(12.0f))
    .centerYEqualToView(self.bgView)
    .widthIs(2.0f)
    .heightIs(MarginFactor(23.0f));
    
    self.titleLabel.sd_layout
    .leftSpaceToView (self.lineView, MarginFactor(5.0f))
    .centerYEqualToView(self.lineView)
    .heightIs(self.titleLabel.font.lineHeight);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc ]init];
        _bgView.backgroundColor = Color(@"efeeef");
    }
    return _bgView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Color(@"d43c33");
        [self.bgView addSubview:_lineView];
    }
    return _lineView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"人脉，优质业务的源泉";
        _titleLabel.font = FontFactor(14.0f);
        _titleLabel.textColor = Color(@"2c2c2c");
        [self.bgView addSubview:_titleLabel];
    }
    return _titleLabel;
}


@end
