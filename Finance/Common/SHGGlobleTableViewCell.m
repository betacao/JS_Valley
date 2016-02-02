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

@end

@implementation SHGGlobleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.textLabel.font = [UIFont systemFontOfSize:factor(15.0f)];
        self.textLabel.textColor = [UIColor colorWithHexString:@"161616"];

        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.rightArrowView];

        self.textLabel.sd_layout
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
        .topSpaceToView(self.textLabel, 0.0f)
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
    self.textLabel.text = model.text;

    //***********************高度自适应cell设置步骤************************

    [self setupAutoHeightWithBottomView:self.lineView bottomMargin:1.0f];
}

@end



@implementation SHGGlobleModel

@end
