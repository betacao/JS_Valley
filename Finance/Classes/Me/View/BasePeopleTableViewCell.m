//
//  BasePeopleTableViewCell.m
//  Finance
//
//  Created by Okay Hoo on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BasePeopleTableViewCell.h"
@interface BasePeopleTableViewCell()

- (IBAction)followButtonClicked:(id)sender;
@end

@implementation BasePeopleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (IBAction)followButtonClicked:(id)sender
{
	if (self.delegate && [self.delegate respondsToSelector:@selector(followButtonClicked:)]) {
		[self.delegate followButtonClicked:self.obj];
	}
}
@end
