//
//  SGHActionSignTableViewCell.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionSignTableViewCell.h"

@interface SHGActionSignTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *action_signHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *action_signNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *action_signCommpanyLable;
@property (weak, nonatomic) IBOutlet UIButton *action_signRightButton;
@property (weak, nonatomic) IBOutlet UIImageView *action_bottomXuXian;

@property (weak, nonatomic) IBOutlet UIButton *action_signLeftButton;
@property (weak, nonatomic) IBOutlet UIView *action_bottomView;

@property (strong, nonatomic) SHGActionAttendObject *object;
@property (strong, nonatomic) NSString *rejectReson;
@end

@implementation SHGActionSignTableViewCell

- (void)awakeFromNib {
    self.action_signNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.action_signCommpanyLable.textColor = [UIColor colorWithHexString:@"C1C1C1"];
    [self.action_signLeftButton setBackgroundColor:[UIColor colorWithHexString:@"FFA2BC"]];
    [self.action_signLeftButton setTitle:@"同意" forState:UIControlStateNormal];
    [self.action_signLeftButton setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
    self.action_signLeftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.action_signRightButton setBackgroundColor:[UIColor colorWithHexString:@"95DAFB"]];
    [self.action_signRightButton setTitle:@"驳回" forState:UIControlStateNormal];
    [self.action_signRightButton setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
     self.action_signRightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.action_bottomXuXian.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.action_bottomView.frame;
    frame.size.height = 0.5f;
    frame.size.width = SCREENWIDTH - CGRectGetMinX(frame);
    self.action_bottomView.frame = frame;
}

- (void)loadLastCellLineImage
{
    self.action_bottomXuXian.hidden = NO;
    self.action_bottomView.hidden = YES;
    UIImage * img = [UIImage imageNamed:@"action_xuxian"];
    self.action_bottomXuXian.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0 , 1, 0, 1) resizingMode:UIImageResizingModeTile];

}

- (void)loadCellWithObject:(SHGActionAttendObject *)object publisher:(NSString *)publisher
{
    [self clearCell];
    self.object = object;
    self.action_signNameLabel.text = object.realname;
    self.action_signCommpanyLable.text = object.company;
    [self.action_signHeadImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,object.headimageurl]] placeholderImage:[UIImage imageNamed:@"default_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

    }];
    if ([object.uid isEqualToString:publisher]) {
        if ([object.state isEqualToString:@"0"]) {
            self.action_signLeftButton.hidden = NO;
            self.action_signRightButton.hidden = NO;
            [self.action_signLeftButton setTitle:@"同意" forState:UIControlStateNormal];
            [self.action_signRightButton setTitle:@"驳回" forState:UIControlStateNormal];
        } else if ([object.state isEqualToString:@"1"]) {
            self.action_signRightButton.hidden = NO;
            [self.action_signRightButton setTitle:@"已同意" forState:UIControlStateNormal];
            [self.action_signRightButton setEnabled:NO];
        } else if ([object.state isEqualToString:@"2"]) {
            self.action_signRightButton.hidden = NO;
            [self.action_signRightButton setTitle:@"已驳回" forState:UIControlStateNormal];

            [self.action_signRightButton setEnabled:NO];
        }
    } else{
        self.action_signLeftButton.hidden = YES;
        self.action_signRightButton.hidden = YES;
    }
}

- (void)clearCell
{
    self.action_signNameLabel.text = @"";
    self.action_signCommpanyLable.text = @"";
    [self.action_signHeadImage setImage:nil];
    self.action_signLeftButton.hidden = YES;
    self.action_signRightButton.hidden = YES;
}

- (IBAction)clickLeftButton:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(meetAttend:clickCommitButton:)]) {
        [self.delegate meetAttend:self.object clickCommitButton:button];
    }
}


- (IBAction)clickRightButton:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(meetAttend:clickRejectButton:reason:)]) {
        [self.delegate meetAttend:self.object clickRejectButton:button reason:self.rejectReson];
    }
}
@end
