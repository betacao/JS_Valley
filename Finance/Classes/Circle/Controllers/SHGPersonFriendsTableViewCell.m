//
//  SHGPersonFriendsTableViewCell.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/22.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGPersonFriendsTableViewCell.h"
@interface SHGPersonFriendsTableViewCell()
@property (weak, nonatomic) IBOutlet headerView *headeimage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong,nonatomic) BasePeopleObject * obj;
@end

@implementation SHGPersonFriendsTableViewCell

- (void)awakeFromNib {
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserHeaderImageView:)];
    [self.headeimage addGestureRecognizer:recognizer];
    
}
- (void)tapUserHeaderImageView:(UIGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapUserHeaderImageView:)]) {
        [self.delegate tapUserHeaderImageView:self.uid];
    }
}
- (void)loadDatasWithObj:(BasePeopleObject *)obj
{
    [self clearCell];
    self.obj = obj;
    [self.headeimage updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.headImageUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.nameLabel.text = obj.name;
    self.companyLabel.text = obj.company;
    self.uid = obj.uid;
}
-(void)clearCell
{
    self.nameLabel.text = @"";
    self.companyLabel.text = @"";
    self.uid = @"";
    [self.headeimage updateHeaderView:nil placeholderImage:[UIImage imageNamed:@"default_head"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
