//
//  SettingQuestionCell.h
//  DingDCommunity
//
//  Created by JianjiYuan on 14-4-10.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingQuestionObj.h"

@interface SettingQuestionCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblContent;

- (void)reloadDatas:(NSObject *)detailInfo;

@end
