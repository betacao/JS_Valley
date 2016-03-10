//
//  SHGPersonalTableViewCell.m
//  Finance
//
//  Created by weiqiankun on 16/3/10.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGPersonalTableViewCell.h"

@interface SHGPersonalTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
@implementation SHGPersonalTableViewCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self inintView];
}

- (void)inintView
{
    self.nameLabel.font = FontFactor(15.0f);
    self.nameLabel.textColor = [UIColor colorWithHexString:@"161616"];
    
    self.countLabel.font = FontFactor(12.0f);
    self.countLabel.textColor = [UIColor colorWithHexString:@"989898"];
    self.countLabel.textAlignment = NSTextAlignmentRight;
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .centerYEqualToView(self.contentView)
    .autoHeightRatio(0.0f);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    UIImage *image = [UIImage imageNamed:@"rightArrowImage"];
    CGSize size = image.size;
    self.rightButton.sd_layout
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .centerYEqualToView(self.contentView)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.countLabel.sd_layout
    .rightSpaceToView(self.rightButton, MarginFactor(10.0f))
    .centerYEqualToView(self.contentView)
    .autoHeightRatio(0.0f);
    [self.countLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.lineView.sd_layout
    .leftEqualToView(self.nameLabel)
    .rightSpaceToView(self.contentView, 0.0f)
    .bottomSpaceToView(self.contentView, 0.0f)
    .heightIs(0.5);
}

- (void)setModel:(SHGPersonalMode *)model
{
    _model = model;
    self.nameLabel.text = model.name;
    [self.nameLabel sizeToFit];
    self.countLabel.text = model.count;
    [self.countLabel sizeToFit];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end

@implementation SHGPersonalMode



@end