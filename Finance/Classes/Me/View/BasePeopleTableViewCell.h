//
//  BasePeopleTableViewCell.h
//  Finance
//
//  Created by Okay Hoo on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePeopleObject.h"

@protocol BasePeopleTableViewCellDelegate <NSObject>

@optional
- (void)followButtonClicked:(BasePeopleObject *)obj;

@end

@interface BasePeopleTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel	*nameLabel;
@property (nonatomic, strong) IBOutlet UILabel	*describtionLabel;
@property (nonatomic, strong) IBOutlet headerView *headerView;
@property (nonatomic, strong) IBOutlet UIButton *followButton;

@property (nonatomic, strong) BasePeopleObject *obj;
@property (nonatomic, weak) id<BasePeopleTableViewCellDelegate> delegate;

+(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
