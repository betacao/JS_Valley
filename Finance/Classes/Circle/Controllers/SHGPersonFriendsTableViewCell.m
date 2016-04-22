//
//  SHGPersonFriendsTableViewCell.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/22.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGPersonFriendsTableViewCell.h"
@interface SHGPersonFriendsTableViewCell()
@property (weak, nonatomic) IBOutlet SHGUserHeaderView *headeimage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation SHGPersonFriendsTableViewCell

- (void)awakeFromNib {

    self.nameLabel.font = FontFactor(15.0f);
    self.nameLabel.textColor = Color(@"161616");
    self.companyLabel.font = FontFactor(13.0f);
    self.companyLabel.textColor = Color(@"898989");
    self.lineView.backgroundColor = Color(@"efeeef");
    [self addSdLayout];
}

- (void)addSdLayout
{
    self.headeimage.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .centerYEqualToView(self.contentView)
    .widthIs(MarginFactor(40.0f))
    .heightIs(MarginFactor(40.0f));
    
    self.nameLabel.sd_layout
    .topEqualToView(self.headeimage)
    .leftSpaceToView(self.headeimage, MarginFactor(10.0f))
    .heightIs(self.nameLabel.font.lineHeight);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
  
    self.companyLabel.sd_layout
    .leftEqualToView(self.nameLabel)
    .bottomEqualToView(self.headeimage)
    .rightSpaceToView(self.contentView,MarginFactor(10.0f))
    .heightIs(self.companyLabel.font.lineHeight);
    //[self.companyLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    self.lineView.sd_layout
    .leftEqualToView(self.headeimage)
    .rightSpaceToView(self.contentView, 0.0f)
    .bottomSpaceToView(self.contentView, 0.5f)
    .heightIs(0.5f);
 
}

- (void)setObj:(BasePeopleObject *)obj
{
    [self clearCell];
    _obj = obj;
    
    BOOL status = [obj.userstatus isEqualToString:@"true"] ? YES : NO;
    [self.headeimage updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.headImageUrl] placeholderImage:[UIImage imageNamed:@"default_head"] status:status userID:obj.uid];
    self.headeimage.backgroundColor = [UIColor redColor];
    self.nameLabel.text = obj.name;
    self.companyLabel.text = obj.company;
    self.uid = obj.uid;

}

-(void)clearCell
{
    self.nameLabel.text = @"";
    self.companyLabel.text = @"";
    self.uid = @"";

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
