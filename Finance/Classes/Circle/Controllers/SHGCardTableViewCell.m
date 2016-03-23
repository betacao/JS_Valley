//
//  SHGCardTableViewCell.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/24.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGCardTableViewCell.h"
#define kTagViewWidth 45.0f * XFACTOR
#define kTagViewHeight 16.0f * XFACTOR
@interface SHGCardTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIView *grayView;
@end
@implementation SHGCardTableViewCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initView];
}

- (void)initView
{
    self.userNameLabel.font = FontFactor(16.0f);
    self.userNameLabel.textColor = [UIColor colorWithHexString:@"4277b2"];
    
    self.departmentLabel.font = FontFactor(14.0f);
    self.departmentLabel.textColor = [UIColor colorWithHexString:@"565656"];
    
    self.companyLabel.font = FontFactor(14.0f);
    self.companyLabel.textColor = [UIColor colorWithHexString:@"565656"];
    
    self.grayView.backgroundColor = [UIColor colorWithHexString:@"efeeef"];
    
    self.headerImageView.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .topSpaceToView(self.contentView, MarginFactor(15.0f))
    .widthIs(MarginFactor(50.f))
    .heightIs(MarginFactor(50.0f));
    
    self.userNameLabel.sd_layout
    .leftSpaceToView(self.headerImageView, MarginFactor(10.0f))
    .topEqualToView(self.headerImageView)
    .autoHeightRatio(0.0f);
    [self.userNameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.departmentLabel.sd_layout
    .leftSpaceToView(self.userNameLabel, MarginFactor(10.0f))
    .centerYEqualToView(self.userNameLabel)
    .autoHeightRatio(0.0f);
    [self.departmentLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.companyLabel.sd_layout
    .leftEqualToView(self.userNameLabel)
    .bottomEqualToView(self.headerImageView)
    .autoHeightRatio(0.0f);
    [self.companyLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.grayView.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .bottomSpaceToView(self.contentView, 0.0f)
    .heightIs(MarginFactor(10.0f));

}

- (void)setObject:(SHGCollectCardClass *)object
{
    
    _object = object;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.object.headerImageUrl]] placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    self.userNameLabel.text = object.name;
    [self.userNameLabel sizeToFit];
    self.companyLabel.text = object.companyname;
    [self.companyLabel sizeToFit];
    
    if (object.titles.length > 6) {
        NSString * str = [object.titles substringToIndex:6];
        self.departmentLabel.text = [NSString stringWithFormat:@"%@...",str];
    } else {
        self.departmentLabel.text = object.titles;
    }
    [self.departmentLabel sizeToFit];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

   
}

@end
