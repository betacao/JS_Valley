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
@property (weak, nonatomic) IBOutlet UIImageView *Acyion_titleBg;
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
@property (weak, nonatomic) IBOutlet UIButton *Action_thr_zanButton;
@property (weak, nonatomic) IBOutlet UIButton *Action_thrCommentButton;
@property (weak, nonatomic) IBOutlet UIButton *Action_editeButton;
@property (weak, nonatomic) IBOutlet UIImageView *Action_topLine;
@property (weak, nonatomic) IBOutlet UIImageView *Action_centerLine;
@property (weak, nonatomic) IBOutlet UIImageView *Action_bottomLine;
@property (weak, nonatomic) IBOutlet UIView *twoButtonView;
@property (weak, nonatomic) IBOutlet UIView *thrButtonView;
@property (strong, nonatomic) SHGActionObject *object;


@end

@implementation SHGActionTableViewCell

- (void)awakeFromNib
{
    self.Action_titlelabel.font = [UIFont systemFontOfSize:12];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"efeeef"];
    self.Acyion_titleBg.image = [UIImage imageNamed:@"action_bg"];
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

- (void)loadDataWithObject:(SHGActionObject *)object
{
    self.object = object;
    [self clearCell];
    [self.Action_headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,object.headerImageUrl]] placeholderImage:[UIImage imageNamed:@"default_head"]];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    self.Action_titlelabel.text = object.theme;
    self.Action_pubdateLabel.text = object.createTime;
    self.Action_addressLabel.text = object.meetArea;
    self.Action_allNumLabel.text = [NSString stringWithFormat:@"邀请%@人", object.meetNum];
    self.Action_momentNumlabel.text = [NSString stringWithFormat:@"已报名%@人", object.attendNum];
    self.Action_messageLabel.text = object.friendShip;
    if (object.meetState == SHGActionStateOver) {
        [self.Action_signButton setTitle:@"已结束" forState:UIControlStateNormal];
        [self.Action_signButton setBackgroundColor:[UIColor colorWithHexString:@"E7E7E7"]];
    } else if (object.meetState == SHGActionStateVerying){
        [self.Action_signButton setTitle:@"审核中" forState:UIControlStateNormal];
        [self.Action_signButton setBackgroundColor:[UIColor colorWithHexString:@"FF837E"]];
    } else if (object.meetState == SHGActionStateSuccess){
        [self.Action_signButton setTitle:@"报名中" forState:UIControlStateNormal];
        [self.Action_signButton setBackgroundColor:[UIColor colorWithHexString:@"F95C53"]];
    } else if (object.meetState == SHGActionStateFailed){
        [self.Action_signButton setTitle:@"被驳回" forState:UIControlStateNormal];
        [self.Action_signButton setBackgroundColor:[UIColor colorWithHexString:@"BCBCBC"]];
    }
    
    if ([object.publisher isEqualToString:uid] && object.meetState == SHGActionStateSuccess) {
        //2代表通过审核了
        self.thrButtonView.hidden = NO;
        [self.Action_thr_zanButton setTitle:object.praiseNum forState:UIControlStateNormal];
        [self.Action_thrCommentButton setTitle:object.commentNum forState:UIControlStateNormal];
        if ([object.isPraise isEqualToString:@"Y"]) {
            [self.Action_thr_zanButton setImage:[UIImage imageNamed:@"home_yizan"] forState:UIControlStateNormal];
        } else{
            [self.Action_thr_zanButton setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
        }
    } else{
        self.twoButtonView.hidden = NO;
        [self.Action_zanButton setTitle:object.praiseNum forState:UIControlStateNormal];
        [self.Action_commentButton setTitle:object.commentNum forState:UIControlStateNormal];
        if ([object.isPraise isEqualToString:@"Y"]) {
            [self.Action_zanButton setImage:[UIImage imageNamed:@"home_yizan"] forState:UIControlStateNormal];
        } else{
            [self.Action_zanButton setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
        }
    }

}

- (void)clearCell
{
    self.Action_titlelabel.text = @"";
    self.Action_pubdateLabel.text = @"";
    self.Action_addressLabel.text = @"";
    self.Action_allNumLabel.text = @"";
    self.Action_momentNumlabel.text = @"";
    [self.Action_signButton setTitle:@"" forState:UIControlStateNormal];
    [self.Action_signButton setBackgroundColor:[UIColor clearColor]];
    self.twoButtonView.hidden = YES;
    self.thrButtonView.hidden = YES;
    [self.Action_thr_zanButton setTitle:@"0" forState:UIControlStateNormal];
    [self.Action_thrCommentButton setTitle:@"0" forState:UIControlStateNormal];
    [self.Action_zanButton setTitle:@"0" forState:UIControlStateNormal];
    [self.Action_commentButton setTitle:@"0" forState:UIControlStateNormal];
    [self.Action_thr_zanButton setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
    [self.Action_zanButton setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
}

//点赞
- (IBAction)addLove:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPrasiseButton:)]) {
        [self.delegate clickPrasiseButton:self.object];
    }
}
//点击评论
- (IBAction)addComment:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCommentButton:)]) {
        [self.delegate clickCommentButton:self.object];
    }
}
//点击编辑
- (IBAction)addEdit:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickEditButton:)]) {
        [self.delegate clickEditButton:self.object];
    }
}
@end
