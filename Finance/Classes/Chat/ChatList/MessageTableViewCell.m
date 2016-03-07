//
//  MessageTableViewCell.m
//  Finance
//
//  Created by haibo li on 15/5/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MessageTableViewCell.h"
@interface MessageTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;


@end

@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    CGRect frame = self.lineView.frame;
    frame.size.height = 0.5f;
    self.lineView.frame = frame;
    self.bgImageView.image = [[UIImage imageNamed:@"message_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(50.0f, 50.0f, 50.0f, 50.0f) resizingMode:UIImageResizingModeStretch];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadDatasWithObj:(MessageObj *)obj
{
    self.title.text = obj.title;
    NSDate *date = [self dateFromString:obj.time];
    self.time.text = [self stringFromDate:date];
    
    self.content.text = obj.content;
    self.content.numberOfLines = 0;
    self.content.lineBreakMode = 0;
    CGSize size = [self.content.text sizeWithSize:CGSizeMake(CGRectGetWidth(self.content.frame), CGFLOAT_MAX) font:self.content.font];
    CGRect frame = self.content.frame;
    frame.size.height = size.height;
    self.content.frame = frame;
    
    frame = self.bgImageView.frame;
    frame.size.height = CGRectGetMaxY(self.content.frame) + 14.0f - CGRectGetMinY(frame);
    self.bgImageView.frame = frame;
    
    if([obj.title rangeOfString:@"大牛通知"].location != NSNotFound){
        self.title.textColor = [UIColor colorWithHexString:@"F95C53"];
    } else if ([obj.title rangeOfString:@"系统通知"].location != NSNotFound){
        self.title.textColor = [UIColor colorWithHexString:@"606060"];
    }
    
}

- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}


@end
