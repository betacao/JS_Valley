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
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) CircleListObj * obj;

@end
@implementation SHGNewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)loadUi:(CircleListObj * )obj
{
    self.obj = obj;
    self.timeLabel.text = obj.publishdate;
    self.lineView.height = 0.5;
     self.titleLabel.numberOfLines =2;
    self.titleLabel.text = obj.title;
    if (obj.title.length > 40) {
        obj.title = [obj.title substringToIndex:40];
    }
    self.originLabel.text = obj.nickname;
    NSArray * arr = obj.photos;
    if (arr.count == 0) {
        [self loadNoTitleUi:obj];
    }else
    {
        CGSize tsize =CGSizeMake(self.titleLabel.frame.size.width,MAXFLOAT);
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14.0],NSFontAttributeName,nil];
        CGSize  actualsize =[obj.title boundingRectWithSize:tsize options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
        self.titleLabel.frame =CGRectMake(self.titleLabel.frame.origin.x,self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, actualsize.height);

        NSString * str = [arr objectAtIndex:0];
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,str]]];
    }
   //图片加边框
    CALayer * layer = [self.headerImage layer];
    layer.borderColor = [[UIColor colorWithHexString:@"ebebeb"] CGColor];
    layer.borderWidth = 0.50f;
}
-(void)loadNoTitleUi:(CircleListObj * )obj
{
    NSInteger toLeftSpace = 10.0f;
    NSInteger toTopSpace = 10.0f;
    //NSInteger toBottomSpace = 10.0f;
    NSInteger bottomLabelHeight = 14.0;
    NSInteger bottomLabelWidth = 100;
    self.headerImage.hidden = YES;
   self.titleLabel.frame = CGRectMake(toLeftSpace, toTopSpace, self.contentView.width - 2*toLeftSpace,self.titleLabel.frame.size.height);
    self.originLabel.frame = CGRectMake(toLeftSpace, self.contentView.height-2*toLeftSpace, bottomLabelWidth, bottomLabelHeight);
    self.timeLabel.frame = CGRectMake(SCREENWIDTH-bottomLabelWidth-toLeftSpace, self.contentView.height-2*toLeftSpace, bottomLabelWidth, bottomLabelHeight);
    CGSize ttsize =CGSizeMake(self.titleLabel.frame.size.width,MAXFLOAT);
    NSDictionary * ttdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14.0],NSFontAttributeName,nil];
    CGSize  tactualsize =[obj.title boundingRectWithSize:ttsize options:NSStringDrawingUsesLineFragmentOrigin  attributes:ttdic context:nil].size;
    self.titleLabel.frame = CGRectMake(toLeftSpace, toTopSpace, self.contentView.width - 2*toLeftSpace,tactualsize.height);
}
-(void)loadTitleLabelChange
{
    self.titleLabel.textColor = [UIColor colorWithHexString:@"898989"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
