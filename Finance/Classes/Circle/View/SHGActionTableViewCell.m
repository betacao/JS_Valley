//
//  SHGActionTableViewCell.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/12.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionTableViewCell.h"

@interface SHGActionTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *Action_titlelabel;
@property (weak, nonatomic) IBOutlet UIImageView *Action_headImage;
@property (weak, nonatomic) IBOutlet UILabel *Action_nameLble;
@property (weak, nonatomic) IBOutlet UILabel *Action_pubdateLabel;
@property (weak, nonatomic) IBOutlet UIButton *Action_signButton;
@property (weak, nonatomic) IBOutlet UIImageView *Action_lineImage;
@property (weak, nonatomic) IBOutlet UILabel *Action_positionLable;
@property (weak, nonatomic) IBOutlet UIImageView *Action_timeImage;
@property (weak, nonatomic) IBOutlet UILabel *Action_timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *Action_addressImage;
@property (weak, nonatomic) IBOutlet UILabel *Action_addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *Action_allNumImage;
@property (weak, nonatomic) IBOutlet UILabel *Action_allNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *Action_momentNumImage;
@property (weak, nonatomic) IBOutlet UILabel *Action_momentNumlabel;
@property (weak, nonatomic) IBOutlet UILabel *Action_messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *Action_zanButton;
@property (weak, nonatomic) IBOutlet UIButton *Action_commentButton;
@property (weak, nonatomic) IBOutlet UIImageView *Action_topLine;
@property (weak, nonatomic) IBOutlet UIImageView *Action_centerLine;
@property (weak, nonatomic) IBOutlet UIImageView *Action_bottomLine;
@end

@implementation SHGActionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
