//
//  MyMoneyDetailTableViewCell.h
//  Finance
//
//  Created by Okay Hoo on 15/4/29.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMoneyDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *productLabel;
@property (nonatomic, strong) IBOutlet UILabel *totalMoney;
@property (nonatomic, strong) IBOutlet UILabel *commissionMoney;
@property (weak, nonatomic) IBOutlet UILabel *moneyType;


@end
