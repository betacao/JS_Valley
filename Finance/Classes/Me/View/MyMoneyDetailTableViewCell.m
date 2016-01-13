//
//  MyMoneyDetailTableViewCell.m
//  Finance
//
//  Created by Okay Hoo on 15/4/29.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MyMoneyDetailTableViewCell.h"

@implementation MyMoneyDetailTableViewCell

- (void)awakeFromNib {
    self.lineView.size = CGSizeMake(self.lineView.width, 0.5f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
