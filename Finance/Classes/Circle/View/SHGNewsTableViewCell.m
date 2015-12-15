//
//  SHGNewsTableViewCell.m
//  Finance
//
//  Created by 魏虔坤 on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGNewsTableViewCell.h"

@interface SHGNewsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *originLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) CircleListObj * obj;

@end
@implementation SHGNewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)loadUi:(CircleListObj * )obj
{
    self.obj = obj;
    NSDate * today = [[NSDate alloc]init];
    NSString * todayString = [[today description]substringToIndex:10];
    NSString * timeString = [[obj.publishdate description]substringToIndex:10];
    
    if ([todayString isEqualToString:timeString]) {
        self.timeLabel.text = [obj.publishdate substringWithRange:NSMakeRange(11, 8)];
    }else
    {
        self.timeLabel.text =timeString;
    }
    self.titleLabel.text = obj.title;
    self.originLabel.text = obj.nickname;
    NSArray * arr = obj.photos;
    if (arr.count == 0) {
        [self loadNoTitleUi];
    }else
    {
        NSString * str = [arr objectAtIndex:0];
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,str]]];
    }
   //图片加边框
    CALayer * layer = [self.headerImage layer];
    layer.borderColor = [[UIColor colorWithHexString:@"ebebeb"] CGColor];
    layer.borderWidth = 1.0f;
}
-(void)loadNoTitleUi
{
    NSInteger toLeftSpace = 10.0f;
    NSInteger toTopSpace = 10.0f;
    NSInteger toBottomSpace = 10.0f;
    NSInteger bottomLabelHeight = 14.0;
    NSInteger bottomLabelWidth = 100;
    self.headerImage.hidden = YES;
    self.titleLabel.frame = CGRectMake(toLeftSpace, toTopSpace, self.contentView.width - 2*toLeftSpace, 35.0);
    self.originLabel.frame = CGRectMake(toLeftSpace, self.contentView.height-toBottomSpace-bottomLabelHeight, bottomLabelWidth, bottomLabelHeight);
    self.timeLabel.frame = CGRectMake(self.contentView.width-bottomLabelWidth-toLeftSpace, self.contentView.height-toBottomSpace-bottomLabelHeight, bottomLabelWidth, bottomLabelHeight);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
