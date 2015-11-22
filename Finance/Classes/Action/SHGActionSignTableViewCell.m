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

@property (weak, nonatomic) IBOutlet UIButton *action_signLeftButton;
@property (weak, nonatomic) IBOutlet UIImageView *action_bottomImage;

@property (strong, nonatomic) NSString *meetAttendId;
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
    
    
}

- (void)loadCellWithDictionary:(NSDictionary *)dictionary
{
    self.meetAttendId = [dictionary objectForKey:@"meetattendid"];
    self.action_signNameLabel.text = [dictionary objectForKey:@"realname"];
    self.action_signCommpanyLable.text = [dictionary objectForKey:@"company"];
    [self.action_signHeadImage sd_setImageWithURL:[NSURL URLWithString:[dictionary objectForKey:@"headimageurl"]] placeholderImage:[UIImage imageNamed:@"default_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

    }];
    if ([[dictionary objectForKey:@"status"] isEqualToString:@"0"]) {
        self.action_signLeftButton.hidden = NO;
        self.action_signRightButton.hidden = NO;
        [self.action_signLeftButton setTitle:@"同意" forState:UIControlStateNormal];
        [self.action_signRightButton setTitle:@"驳回" forState:UIControlStateNormal];
    } else if ([[dictionary objectForKey:@"status"] isEqualToString:@"1"]) {
        self.action_signRightButton.hidden = NO;
        [self.action_signRightButton setTitle:@"已同意" forState:UIControlStateNormal];
        [self.action_signRightButton setEnabled:NO];
    } else if ([[dictionary objectForKey:@"status"] isEqualToString:@"2"]) {
        self.action_signRightButton.hidden = NO;
        [self.action_signRightButton setTitle:@"已驳回" forState:UIControlStateNormal];
        [self.action_signRightButton setEnabled:NO];
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
        [self.delegate meetAttend:self.meetAttendId clickCommitButton:button];
    }
}


- (IBAction)clickRightButton:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(meetAttend:clickRejectButton:reason:)]) {
        [self.delegate meetAttend:self.meetAttendId clickRejectButton:button reason:self.rejectReson];
    }
}
@end
