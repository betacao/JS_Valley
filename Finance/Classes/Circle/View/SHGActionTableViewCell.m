//
//  SHGActionTableViewCell.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/12.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionTableViewCell.h"

@interface SHGActionTableViewCell ()
{
    //UIImage * img;
}
@property (weak, nonatomic) IBOutlet UILabel *Action_titlelabel;
@property (weak, nonatomic) IBOutlet UIImageView *Action_headImage;
@property (weak, nonatomic) IBOutlet UILabel *Action_nameLble;
@property (weak, nonatomic) IBOutlet UILabel *Action_pubdateLabel;
@property (weak, nonatomic) IBOutlet UIButton *Action_signButton;
@property (weak, nonatomic) IBOutlet UIImageView *Action_lineImage;
@property (weak, nonatomic) IBOutlet UILabel *Action_positionLable;
@property (weak, nonatomic) IBOutlet UIImageView *Action_timeImage;
@property (weak, nonatomic) IBOutlet UILabel *Action_timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *Action_bgImage;
@property (weak, nonatomic) IBOutlet UIImageView *Action_addressImage;
@property (weak, nonatomic) IBOutlet UILabel *Action_addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *Action_allNumImage;
@property (weak, nonatomic) IBOutlet UILabel *Action_allNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *Action_momentNumImage;
@property (weak, nonatomic) IBOutlet UILabel *Action_momentNumlabel;
@property (weak, nonatomic) IBOutlet UILabel *Action_messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *Action_zanButton;
@property (weak, nonatomic) IBOutlet UIButton *Action_commentButton;
@property (weak, nonatomic) IBOutlet UIButton *Action_thr_zanButton;
@property (weak, nonatomic) IBOutlet UIButton *Action_thrCommentButton;
@property (weak, nonatomic) IBOutlet UIButton *Action_editeButton;
@property (weak, nonatomic) IBOutlet UIImageView *Action_topLine;
@property (weak, nonatomic) IBOutlet UIImageView *Action_centerLine;
@property (weak, nonatomic) IBOutlet UIImageView *Action_bottomLine;
@property (weak, nonatomic) IBOutlet UIView *twoButtonView;
@property (weak, nonatomic) IBOutlet UIView *thrButtonView;



@end

@implementation SHGActionTableViewCell

- (void)awakeFromNib {
    
    //self.contentView.backgroundColor = [UIColor grayColor];
    self.Action_bgImage.image = [[UIImage imageNamed:@"action_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f) resizingMode:UIImageResizingModeTile];
    self.Action_titlelabel.textColor = [UIColor colorWithHexString:@"3A3A3A"];
    self.Action_titlelabel.backgroundColor = [UIColor clearColor];
    self.Action_signButton.backgroundColor = [UIColor colorWithHexString:@"F95C53"];
    [self.Action_signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.Action_nameLble.textColor = [UIColor colorWithHexString:@"333333"];
    self.Action_positionLable.textColor = [UIColor colorWithHexString:@"C1C1C1"];
    self.Action_pubdateLabel.textColor = [UIColor colorWithHexString:@"D2D1D1"];
    self.Action_timeLabel.textColor = [UIColor colorWithHexString:@"606060"];
    self.Action_addressLabel.textColor = [UIColor colorWithHexString:@"606060"];
    self.Action_allNumLabel.textColor = [UIColor colorWithHexString:@"606060"];
    self.Action_momentNumlabel.textColor = [UIColor colorWithHexString:@"606060"];
    self.Action_messageLabel.textColor = [UIColor colorWithHexString:@"D1D1D1"];
    //self.Action_centerLine.image =[self resizableImageWithCapInsets:img];
    UIImage * img = [UIImage imageNamed:@"action_xuxian"];
    self.Action_centerLine.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0 , 1, 0, 1) resizingMode:UIImageResizingModeTile];
    self.Action_bottomLine.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0 , 1, 0, 1) resizingMode:UIImageResizingModeTile];
    self.twoButtonView.hidden = YES;
    //所有活动
    [self.Action_zanButton setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
    [self.Action_zanButton setTitle:@"555" forState:UIControlStateNormal];
    [self.Action_zanButton setTitleColor:[UIColor colorWithHexString:@"D1D1D1"] forState:UIControlStateNormal];
    [self.Action_commentButton setImage:[UIImage imageNamed:@"home_comment"] forState:UIControlStateNormal];
    [self.Action_commentButton setTitle:@"555" forState:UIControlStateNormal];
    [self.Action_commentButton setTitleColor:[UIColor colorWithHexString:@"D1D1D1"] forState:UIControlStateNormal];
    //我的活动
    [self.Action_thr_zanButton setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
    [self.Action_thr_zanButton setTitle:@"555" forState:UIControlStateNormal];
    [self.Action_thr_zanButton setTitleColor:[UIColor colorWithHexString:@"D1D1D1"] forState:UIControlStateNormal];
    [self.Action_thrCommentButton setImage:[UIImage imageNamed:@"home_comment"] forState:UIControlStateNormal];
    [self.Action_thrCommentButton setTitle:@"555" forState:UIControlStateNormal];
    [self.Action_thrCommentButton setTitleColor:[UIColor colorWithHexString:@"D1D1D1"] forState:UIControlStateNormal];
    [self.Action_editeButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.Action_editeButton setTitleColor:[UIColor colorWithHexString:@"D1D1D1"] forState:UIControlStateNormal];
    

}
//- (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets
//{
//    
//   
//}


@end
