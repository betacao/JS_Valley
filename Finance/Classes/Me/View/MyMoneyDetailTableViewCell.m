//
//  MyMoneyDetailTableViewCell.m
//  Finance
//
//  Created by Okay Hoo on 15/4/29.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MyMoneyDetailTableViewCell.h"

@interface MyMoneyDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftProductLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UILabel *leftTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionMoney;
@property (weak, nonatomic) IBOutlet UILabel *leftCommiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyType;
@property (weak, nonatomic) IBOutlet UILabel *leftMoneyTypeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end
@implementation MyMoneyDetailTableViewCell

- (void)awakeFromNib {
   
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initView];
    [self addSdLayout];
}

- (void)initView
{
    
    self.leftNameLabel.font = FontFactor(14.0f);
    self.leftNameLabel.textColor = [UIColor colorWithHexString:@"989898"];
    
    self.leftProductLabel.font = FontFactor(14.0f);
    self.leftProductLabel.textColor = [UIColor colorWithHexString:@"989898"];
    
    self.leftCommiseLabel.font = FontFactor(14.0f);
    self.leftCommiseLabel.textColor = [UIColor colorWithHexString:@"989898"];
    self.leftMoneyTypeLabel.font = FontFactor(14.0f);
    self.leftMoneyTypeLabel.textColor = [UIColor colorWithHexString:@"989898"];
    
    self.leftMoneyTypeLabel.font = FontFactor(14.0f);
    self.leftMoneyTypeLabel.textColor = [UIColor colorWithHexString:@"989898"];
    
    self.leftTotalLabel.font = FontFactor(14.0f);
    self.leftTotalLabel.textColor = [UIColor colorWithHexString:@"989898"];

    self.nameLabel.textColor = [UIColor colorWithHexString:@"161616"];
    self.nameLabel.font = FontFactor(14.0f);
    self.productLabel.textColor = [UIColor colorWithHexString:@"161616"];
    self.productLabel.font = FontFactor(14.0f);
    self.totalMoney.textColor = [UIColor colorWithHexString:@"161616"];
    self.totalMoney.font = FontFactor(14.0f);
    self.commissionMoney.textColor = [UIColor colorWithHexString:@"161616"];
    self.commissionMoney.font = FontFactor(14.0f);
    self.moneyType.textColor = [UIColor colorWithHexString:@"161616"];
    self.moneyType.font = FontFactor(14.0f);
    
   
}

- (void)addSdLayout
{
    self.leftNameLabel.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .topSpaceToView(self.contentView, MarginFactor(20.0f))
    .autoHeightRatio(0.0f);
    [self.leftNameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
   
    self.leftProductLabel.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .topSpaceToView(self.leftNameLabel, MarginFactor(10.0f))
    .autoHeightRatio(0.0f);
    [self.leftProductLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.leftTotalLabel.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .topSpaceToView(self.leftProductLabel, MarginFactor(10.0f))
    .autoHeightRatio(0.0f);
    [self.leftTotalLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.leftCommiseLabel.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .topSpaceToView(self.leftTotalLabel, MarginFactor(10.0f))
    .autoHeightRatio(0.0f);
    [self.leftCommiseLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.leftMoneyTypeLabel.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .topSpaceToView(self.leftCommiseLabel, MarginFactor(10.0f))
    .autoHeightRatio(0.0f);
    [self.leftMoneyTypeLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.nameLabel.sd_layout
    .centerYEqualToView(self.leftNameLabel)
    .leftSpaceToView(self.leftProductLabel, MarginFactor(32.0f))
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .heightRatioToView(self.leftNameLabel,1.0);
    
    self.productLabel.sd_layout
    .centerYEqualToView(self.leftProductLabel)
    .leftSpaceToView(self.leftProductLabel, MarginFactor(32.0f))
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .heightRatioToView(self.leftProductLabel,1.0);
    
    self.totalMoney.sd_layout
    .centerYEqualToView(self.leftTotalLabel)
    .leftSpaceToView(self.leftProductLabel, MarginFactor(32.0f))
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .heightRatioToView(self.leftTotalLabel,1.0);
    
    self.commissionMoney.sd_layout
    .centerYEqualToView(self.leftCommiseLabel)
    .leftSpaceToView(self.leftProductLabel, MarginFactor(32.0f))
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .heightRatioToView(self.leftCommiseLabel,1.0);

    self.moneyType.sd_layout
    .centerYEqualToView(self.leftMoneyTypeLabel)
    .leftSpaceToView(self.leftProductLabel, MarginFactor(32.0f))
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .heightRatioToView(self.leftMoneyTypeLabel,1.0);
    
    self.lineView.sd_layout
    .topSpaceToView(self.moneyType, MarginFactor(20.0f))
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(0.5f);
    

    [self setupAutoHeightWithBottomView:self.lineView bottomMargin:0.0f];
}
- (void)setObject:(MyMoneyDetailObject *)object
{
    _object = object;
    self.nameLabel.text = object.name;
    self.productLabel.text = object.productName;
    self.totalMoney.text = object.totalMoney;
    self.commissionMoney.text = object.commission;
    switch ([object.type intValue]) {
        case 0:
            self.moneyType.text=@"我的客户";
            break;
        case 1:
            self.moneyType.text=@"二级客户";
        default:
            self.moneyType.text=@"三级客户";
            break;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
