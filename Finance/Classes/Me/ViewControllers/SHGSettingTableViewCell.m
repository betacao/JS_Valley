//
//  SHGSettingTableViewCell.m
//  Finance
//
//  Created by changxicao on 16/1/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGSettingTableViewCell.h"

@interface SHGSettingTableViewCell()

@end

@implementation SHGSettingTableViewCell

- (void)awakeFromNib
{
    self.titleLabel.font = FontFactor(15.0f);
    self.titleLabel.textColor = [UIColor colorWithHexString:@"161616"];
    self.titleLabel.backgroundColor = [UIColor clearColor];

    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(19.0f))
    .centerYEqualToView(self.contentView)
    .autoHeightRatio(0.0f);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.lineView.sd_layout
    .leftEqualToView(self.titleLabel)
    .widthIs(SCREENWIDTH - MarginFactor(19.0f))
    .bottomSpaceToView(self.contentView, 0.5f)
    .heightIs(0.5f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
