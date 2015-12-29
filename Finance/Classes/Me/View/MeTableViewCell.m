//
//  MeTableViewCell.m
//  Finance
//
//  Created by HuMin on 15/5/27.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MeTableViewCell.h"

@interface MeTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation MeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    CGRect frame = self.lineView.frame;
    frame.size.height = 0.5f;
    self.lineView.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
