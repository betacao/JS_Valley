//
//  BasePeopleTableViewCell.m
//  Finance
//
//  Created by Okay Hoo on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BasePeopleTableViewCell.h"
@interface BasePeopleTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet SHGUserHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
- (IBAction)followButtonClicked:(id)sender;
@end

@implementation BasePeopleTableViewCell

- (void)awakeFromNib {

    [self loadView];
}

- (void)loadView
{
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.textColor = [UIColor colorWithHexString:@"161616"];
    self.nameLabel.font = FontFactor(15.0f);
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    self.headerView.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .topSpaceToView(self.contentView, MarginFactor(12.0f))
    .widthIs(MarginFactor(35.0f))
    .heightIs(MarginFactor(35.0f));
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.headerView, MarginFactor(15.0f))
    .centerYEqualToView(self.headerView)
    .autoHeightRatio(0.0f);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    UIImage *image = [UIImage imageNamed:@"me_follow"];
    CGSize followSize = image.size;
    self.followButton.sd_layout
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .centerYEqualToView(self.headerView)
    .widthIs(followSize.width)
    .heightIs(followSize.height);
    
    self.lineView.sd_layout
    .leftEqualToView(self.headerView)
    .rightSpaceToView(self.contentView, 0.0f)
    .bottomSpaceToView(self.contentView, 0.0f)
    .heightIs(0.5f);


}

- (void)setObject:(BasePeopleObject *)object
{
    _object = object;
    self.nameLabel.text = object.name;
    [self.nameLabel sizeToFit];
    self.followButton.hidden = object.followRelationHiden;
    UIImage *placeHolder = [UIImage imageNamed:@"default_head"];
    BOOL status = [object.userstatus isEqualToString:@"true"] ? YES : NO;
    [self.headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,object.headImageUrl] placeholderImage:placeHolder status:status userID:object.uid];
    
    if (object.followRelation == 0) {
        [self.followButton setImage:[UIImage imageNamed:@"me_follow"] forState:UIControlStateNormal];
    } else if (object.followRelation == 1){
        [self.followButton setImage:[UIImage imageNamed:@"me_followed"] forState:UIControlStateNormal];
    } else if (object.followRelation == 2){
        [self.followButton setImage:[UIImage imageNamed:@"me_follow_each"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (IBAction)followButtonClicked:(id)sender
{
	if (self.delegate && [self.delegate respondsToSelector:@selector(followButtonClicked:)]) {
		[self.delegate followButtonClicked:self.object];
	}
}
@end
