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
    self.lineView.sd_layout
    .leftEqualToView(self.textLabel)
    .rightSpaceToView(self.contentView, 0.0f)
    .bottomSpaceToView(self.contentView, 1.0f)
    .heightIs(0.5f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
