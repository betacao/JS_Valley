//
//  SHGFriendGropingTableViewCell.m
//  Finance
//
//  Created by changxicao on 16/1/4.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGFriendGropingTableViewCell.h"

@interface SHGFriendGropingTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end

@implementation SHGFriendGropingTableViewCell

- (void)awakeFromNib
{
    CGRect frame = self.lineView.frame;
    frame.size.height = 0.5f;
    self.lineView.frame = frame;
}


- (void)loadDataWithModule:(SHGFriendGropingObject *)object
{
    [self clearCell];
    self.nameLabel.text = object.module;
    self.detailLabel.text = [object.counts stringByAppendingString:@"人"];
}

- (void)clearCell
{
    self.nameLabel.text = @"";
    self.detailLabel.text = @"0人";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
