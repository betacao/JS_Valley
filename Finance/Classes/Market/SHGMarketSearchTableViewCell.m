//
//  SHGSearchTableViewCell.m
//  Finance
//
//  Created by changxicao on 15/12/28.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketSearchTableViewCell.h"
@interface SHGMarketSearchTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation SHGMarketSearchTableViewCell

- (void)awakeFromNib
{
    CGRect frame = self.lineView.frame;
    frame.size.height = 0.5f;
    self.lineView.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
