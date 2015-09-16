//
//  RecommendTableViewCell.m
//  Finance
//
//  Created by zhuaijun on 15/8/17.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "RecommendTableViewCell.h"

@implementation RecommendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)loadDatasWithObj:(RecmdFriendObj *)obj
{
    [_imageHeader sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.username]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    if ([obj.flag isEqualToString:@"attention"])
    {
        [_btnAttention setImage:[UIImage imageNamed:@"已关注按钮"] forState:UIControlStateNormal] ;
    }else
    {
        [_btnAttention setImage:[UIImage imageNamed:@"关注按钮"] forState:UIControlStateNormal] ;
    }
    NSString *name = obj.username;
    if (obj.username.length > 4) {
        name = [obj.username substringToIndex:4];
        name = [NSString stringWithFormat:@"%@…",name];
    }
    _lblUserName.text = name;
    CGSize nameSize = [name sizeForFont:_lblUserName.font constrainedToSize:CGSizeMake(100, 20) lineBreakMode:_lblUserName.lineBreakMode];
    CGRect userRect = _lblUserName.frame;
    userRect.size.width = nameSize.width;
    _lblUserName.frame = userRect;
    
    NSString *comp = obj.company;
    if (obj.company.length > 5) {
        NSString *str = [obj.company substringToIndex:5];
        comp = [NSString stringWithFormat:@"%@…",str];
    }
    _lblUserName.text = comp;
    
    CGRect companRect = _lblUserName.frame;
    companRect.origin.x = _lblUserName.right + 8;
    
    CGSize companSize = [comp sizeForFont:_lblPosition.font constrainedToSize:CGSizeMake(84, 15) lineBreakMode:_lblPosition.lineBreakMode];
    companRect.size.width = companSize.width;
    _lblPosition.frame = companRect;
    
    _lblCityName.text = obj.area;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
