//
//  SHGPersonFriendsTableViewCell.h
//  Finance
//
//  Created by 魏虔坤 on 15/11/22.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHGPersonFriendsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet headerView *headeimage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

//@property (nonatomic, strong) BasePeopleObject *obj;
//@property (nonatomic, weak) id<BasePeopleTableViewCellDelegate> delegate;
@end
