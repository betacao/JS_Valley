//
//  TeamDetailTableViewCell.m
//  Finance
//
//  Created by Okay Hoo on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "TeamDetailTableViewCell.h"
@interface TeamDetailTableViewCell()
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, strong) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftMoneyLabel;

@end
@implementation TeamDetailTableViewCell

- (void)awakeFromNib {
    [self initView];
}

- (void)initView
{
    self.leftNameLabel.font = FontFactor(14.0f);
    self.leftNameLabel.textColor = [UIColor colorWithHexString:@"989898"];
    
    self.leftMoneyLabel.font = FontFactor(14.0f);
    self.leftMoneyLabel.textColor = [UIColor colorWithHexString:@"989898"];
    
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    
    self.nameLabel.font = FontFactor(14.0f);
    self.nameLabel.textColor = [UIColor colorWithHexString:@"161616"];
    self.moneyLabel.font = FontFactor(14.0f);
    self.moneyLabel.textColor = [UIColor colorWithHexString:@"161616"];
    
    self.leftNameLabel.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .topSpaceToView(self.contentView, MarginFactor(18.0f))
    .autoHeightRatio(0.0f);
    [self.leftNameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.leftNameLabel.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .bottomSpaceToView(self.contentView, MarginFactor(18.0f))
    .autoHeightRatio(0.0f);
    [self.leftNameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.leftNameLabel, MarginFactor(10.0f))
    .topEqualToView(self.leftNameLabel)
    .autoHeightRatio(0.0f);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.moneyLabel.sd_layout
    .leftSpaceToView(self.leftMoneyLabel, MarginFactor(10.0f))
    .bottomEqualToView(self.leftMoneyLabel)
    .autoHeightRatio(0.0f);
    [self.moneyLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.lineView.sd_layout
    .leftEqualToView(self.leftMoneyLabel)
    .rightSpaceToView(self.contentView, 0.0f)
    .bottomSpaceToView(self.contentView, 0.0f)
    .heightIs(0.5f);

    
}
- (void)setObject:(TeamDetailObject *)object
{
    _object = object;
    self.leftNameLabel.text = @"姓名：";
    self.leftMoneyLabel.text = @"佣金：";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
