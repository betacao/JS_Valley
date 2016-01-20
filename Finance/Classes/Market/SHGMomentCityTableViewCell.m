//
//  SHGMomentCityTableViewCell.m
//  Finance
//
//  Created by weiqiankun on 16/1/20.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMomentCityTableViewCell.h"

@interface SHGMomentCityTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UIView *redLine;
@property (strong, nonatomic) SHGMarketCityObject *object;
@end
@implementation SHGMomentCityTableViewCell

- (void)awakeFromNib {
    
    self.cityNameLabel.textAlignment = NSTextAlignmentLeft;
    self.cityNameLabel.textColor = [UIColor colorWithHexString:@"434343"];
    self.cityNameLabel.font = [UIFont systemFontOfSize:14.0f * XFACTOR];
    self.redLine.backgroundColor = [UIColor colorWithHexString:@"E6E7E8"];
    self.redLine.frame = CGRectMake(self.redLine.origin.x, self.contentView.height - 1.0f, self.redLine.width, 0.5f);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    }

- (void)loadWithUi:(SHGMarketCityObject *)obj
{
    self.object = obj;
    self.cityNameLabel.text = obj.cityName;
}
@end
