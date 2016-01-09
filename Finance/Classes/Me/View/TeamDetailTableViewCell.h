//
//  TeamDetailTableViewCell.h
//  Finance
//
//  Created by Okay Hoo on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, strong) IBOutlet UILabel *moneyLabel;
@end
