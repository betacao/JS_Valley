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
    CGRect frame = self.lineView.frame;
    frame.size.height = 0.5f;
    self.lineView.frame = frame;
}

//- (void)load

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
