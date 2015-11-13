//
//  SGHActionSignTableViewCell.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionSignTableViewCell.h"
@interface SHGActionSignTableViewCell()
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *action_signHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *action_signNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *action_signCommpangyLlabe;
@property (weak, nonatomic) IBOutlet UIButton *action_signRightButton;

@property (weak, nonatomic) IBOutlet UIButton *action_signLeftButton;

@end

@implementation SGHActionSignTableViewCell

- (void)awakeFromNib {
    self.action_signNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.action_signCommpangyLlabe.textColor = [UIColor colorWithHexString:@"C1C1C1"];
    [self.action_signLeftButton setBackgroundColor:[UIColor colorWithHexString:@"FFA2BC"]];
    [self.action_signLeftButton setTitle:@"同意" forState:UIControlStateNormal];
    [self.action_signLeftButton setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
    self.action_signLeftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.action_signRightButton setBackgroundColor:[UIColor colorWithHexString:@"95DAFB"]];
    [self.action_signRightButton setTitle:@"驳回" forState:UIControlStateNormal];
    [self.action_signRightButton setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
     self.action_signRightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
