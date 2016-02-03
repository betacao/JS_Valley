//
//  SHGGlobleTableViewCell.m
//  Finance
//
//  Created by weiqiankun on 16/1/21.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGGlobleTableViewCell.h"
@interface SHGGlobleTableViewCell()

@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIImageView *rightArrowView;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation SHGGlobleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.rightArrowView];

        self.titleLabel.sd_layout
        .leftSpaceToView(self.contentView, factor(19.0f))
        .topSpaceToView(self.contentView, 0.0f)
        .rightSpaceToView(self.contentView, 0.0f)
        .heightIs(factor(54.0f));

        CGSize size = self.rightArrowView.frame.size;

        self.rightArrowView.sd_layout
        .widthIs(size.width)
        .heightIs(size.height)
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, factor(11.0f));

        self.lineView.sd_layout
        .topSpaceToView(self.titleLabel, 1.0f)
        .leftSpaceToView(self.contentView, factor(18.0f))
        .rightSpaceToView(self.contentView, 0.0f)
        .heightIs(0.5f);
    }
    return self;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    }
    return _lineView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:factor(15.0f)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"161616"];
    }
    return _titleLabel;
}

- (UIImageView *)rightArrowView
{
    if (!_rightArrowView) {
        _rightArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrowImage"]];
        [_rightArrowView sizeToFit];
    }
    return _rightArrowView;
}

- (void)setModel:(SHGGlobleModel *)model
{
    _model = model;
    self.titleLabel.text = model.text;

    //***********************高度自适应cell设置步骤************************

    [self setupAutoHeightWithBottomView:self.lineView bottomMargin:0.0f];
}

- (void)setupNeedShowAccessorView:(BOOL)hidden
{
    self.rightArrowView.hidden = hidden;
}

@end



@implementation SHGGlobleModel

@end
