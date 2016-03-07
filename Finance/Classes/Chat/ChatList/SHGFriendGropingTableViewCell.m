//
//  SHGFriendGropingTableViewCell.m
//  Finance
//
//  Created by changxicao on 16/1/4.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGFriendGropingTableViewCell.h"

@interface SHGFriendGropingTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImageView;
@end

@implementation SHGFriendGropingTableViewCell

- (void)awakeFromNib
{
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.nameLabel.font = FontFactor(15.0f);
    self.nameLabel.textColor = [UIColor colorWithHexString:@"161616"];

    self.detailLabel.font = FontFactor(13.0f);
    self.detailLabel.textColor = [UIColor colorWithHexString:@"898989"];

    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];

    [self.rightArrowImageView sizeToFit];
}

- (void)addAutoLayout
{
    self.nameLabel.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(15.0f))
    .centerYEqualToView(self.contentView)
    .autoHeightRatio(0.0f);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    CGSize size = self.rightArrowImageView.frame.size;
    self.rightArrowImageView.sd_layout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .widthIs(size.width)
    .heightIs(size.height);

    self.detailLabel.sd_layout
    .rightSpaceToView(self.rightArrowImageView, MarginFactor(10.0f))
    .centerYEqualToView(self.contentView)
    .autoHeightRatio(0.0f);
    [self.detailLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.lineView.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(0.5f)
    .topSpaceToView(self.contentView, MarginFactor(55.0f));

    [self setupAutoHeightWithBottomView:self.lineView bottomMargin:0.0f];
    
}


- (void)setObject:(SHGFriendGropingObject *)object
{
    _object = object;
    [self clearCell];
    self.nameLabel.text = object.module;
    self.detailLabel.text = [object.counts stringByAppendingString:@"人"];
}

- (void)clearCell
{
    self.nameLabel.frame = CGRectZero;
    self.detailLabel.frame = CGRectZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
