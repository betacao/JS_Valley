//
//  RecommendTableViewCell.h
//  Finance
//
//  Created by zhuaijun on 15/8/17.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecmdFriendObj.h"
@interface RecommendTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblPosition;
@property (strong, nonatomic) IBOutlet UIButton *btnAttention;
@property (strong, nonatomic) IBOutlet UILabel *lblCityName;

-(void)loadDatasWithObj:(RecmdFriendObj *)obj;

@end
