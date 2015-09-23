//
//  MeTableViewCell.m
//  Finance
//
//  Created by HuMin on 15/5/27.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MeTableViewCell.h"

@interface MeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end

@implementation MeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    CGRect frame = self.lineLabel.frame;
    frame.size.height = 0.5f;
    self.lineLabel.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
