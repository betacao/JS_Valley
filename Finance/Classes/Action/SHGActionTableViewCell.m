//
//  SHGActionTableViewCell.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/12.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionTableViewCell.h"
#define kItemMargin 6.0f * XFACTOR

@interface SHGActionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *Action_titlelabel;
@property (weak, nonatomic) IBOutlet UIImageView *Acyion_titleBg;
@property (weak, nonatomic) IBOutlet SHGUserHeaderView *Action_headImage;
@property (weak, nonatomic) IBOutlet UILabel *Action_nameLable;
@property (weak, nonatomic) IBOutlet UILabel *Action_pubdateLabel;
@property (weak, nonatomic) IBOutlet UIButton *Action_signButton;
@property (weak, nonatomic) IBOutlet UIView *Action_lineView;
@property (weak, nonatomic) IBOutlet UILabel *Action_companyLable;
@property (weak, nonatomic) IBOutlet UILabel *Action_departmentLable;
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
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"efeeef"];
    self.Acyion_titleBg.image = [UIImage imageNamed:@"action_bg"];
    self.Action_titlelabel.backgroundColor = [UIColor clearColor];
    self.Action_signButton.backgroundColor = [UIColor colorWithHexString:@"F95C53"];
    [self.Action_signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage * img = [UIImage imageNamed:@"action_xuxian"];
    self.Action_centerLine.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0 , 1, 0, 1) resizingMode:UIImageResizingModeTile];
    self.Action_bottomLine.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0 , 1, 0, 1) resizingMode:UIImageResizingModeTile];
    self.twoButtonView.hidden = YES;
    //所有活动
    [self.Action_zanButton setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
    //我的活动
    [self.Action_thr_zanButton setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserHeaderImageView:)];
    [self.Action_headImage addGestureRecognizer:recognizer];
}

- (void)loadDataWithObject:(SHGActionObject *)object index:(NSInteger)index
{
    self.object = object;
    [self clearCell];
    if (index == 0) {
        self.Acyion_titleBg.hidden = YES;
    } else{
        self.Acyion_titleBg.hidden = NO;
    }
    [self.Action_headImage updateStatus:[object.status isEqualToString:@"1"] ? YES : NO];
    [self.Action_headImage updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,object.headerImageUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *theme = object.theme;
    if (theme.length > 15) {
        theme = [[theme substringToIndex:15] stringByAppendingString:@"..."];
    }
    self.Action_titlelabel.text = theme;
    self.Action_nameLable.text = object.realName;
    if (object.createTime.length > 0) {
        self.Action_pubdateLabel.text = [[object.createTime substringWithRange:NSMakeRange(5, 5)] stringByAppendingString:@"发布"];
    }
    self.Action_timeLabel.text = [object.startTime stringByAppendingFormat:@"-%@",object.endTime];
    self.Action_addressLabel.text = object.meetArea;
    self.Action_allNumLabel.text = [NSString stringWithFormat:@"邀请%@人", object.meetNum];
    self.Action_momentNumlabel.text = [NSString stringWithFormat:@"已报名%@人", object.attendNum];
    //左下角
    if ([object.publisher isEqualToString:uid]){
        self.Action_messageLabel.text = object.position;
    } else{
        NSString *string = @"";
        if(object.friendShip && object.friendShip.length > 0){
            string = object.friendShip;
        }
        if(object.position && object.position.length > 0){
            string = [string stringByAppendingFormat:@" , %@",object.position];
        }
        self.Action_messageLabel.text = string;
    }

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
    [self layoutSubviewsFrame];
}

- (void)loadDateWithAllEdit:(SHGActionObject *)object
{
    self.object = object;
    if ([self.object.publisher isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]]) {
        self.thrButtonView.hidden = YES;
        self.twoButtonView.hidden = NO;
        [self.Action_zanButton setTitle:object.praiseNum forState:UIControlStateNormal];
        [self.Action_commentButton setTitle:object.commentNum forState:UIControlStateNormal];
        if ([object.isPraise isEqualToString:@"Y"]) {
            [self.Action_zanButton setImage:[UIImage imageNamed:@"home_yizan"] forState:UIControlStateNormal];
        } else{
            [self.Action_zanButton setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
        }

    }
     [self layoutSubviewsFrame];
}


- (void)layoutSubviewsFrame
{
    CGSize size = [self.Action_nameLable sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.Action_nameLable.frame))];
    CGRect frame = self.Action_nameLable.frame;
    frame.size.width = size.width;
    self.Action_nameLable.frame = frame;
    //1.72版本不需要分割线
    frame = self.Action_lineView.frame;
    frame.origin.x = CGRectGetMaxX(self.Action_nameLable.frame) + kItemMargin;
    self.Action_lineView.frame = frame;

    NSString *company = self.object.company;
    if (self.object.company.length > 6) {
        company = [[company substringToIndex:6] stringByAppendingString:@"..."];
    }
    self.Action_companyLable.text = company;
    frame = self.Action_companyLable.frame;
    size = [self.Action_companyLable sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.Action_companyLable.frame))];
    frame.size.width = size.width;
    frame.origin.x = CGRectGetMaxX(self.Action_lineView.frame) + kItemMargin;
    self.Action_companyLable.frame = frame;

    NSString *department = self.object.department;
    if (self.object.department.length > 4) {
        department = [[department substringToIndex:4] stringByAppendingString:@"..."];
    }
    self.Action_departmentLable.text = department;
    frame = self.Action_departmentLable.frame;
    size = [self.Action_departmentLable sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.Action_departmentLable.frame))];
    frame.size.width = size.width;
    frame.origin.x = CGRectGetMaxX(self.Action_companyLable.frame) + kItemMargin;
    self.Action_departmentLable.frame = frame;

//    if (company.length == 0 && department.length ==0) {
//        self.Action_lineView.hidden = YES;
//    } else{
//        self.Action_lineView.hidden = NO;
//    }

}

- (void)clearCell
{
    self.Action_titlelabel.text = @"";
    self.Action_pubdateLabel.text = @"";
    self.Action_addressLabel.text = @"";
    self.Action_allNumLabel.text = @"";
    self.Action_momentNumlabel.text = @"";
    self.Action_nameLable.text = @"";
    self.Action_timeLabel.text = @"";
    self.Action_messageLabel.text = @"";
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
- (void)tapUserHeaderImageView:(UIGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapUserHeaderImageView:)]) {
        [self.delegate tapUserHeaderImageView:self.object.publisher];
    }
}

@end
