//
//  TeamDetailTableViewCell.m
//  Finance
//
//  Created by Okay Hoo on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "TeamDetailTableViewCell.h"

@implementation TeamDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.lineView.size = CGSizeMake(self.lineView.width, 0.5f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
