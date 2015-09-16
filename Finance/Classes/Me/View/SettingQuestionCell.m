//
//  SettingQuestionCell.m
//  DingDCommunity
//
//  Created by JianjiYuan on 14-4-10.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import "SettingQuestionCell.h"

@implementation SettingQuestionCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadDatas:(NSObject *)detailInfo
{
    if ([detailInfo isKindOfClass:[SettingQuestionObj class]]) {
        SettingQuestionObj *info = (SettingQuestionObj *)detailInfo;
        _lblContent.text = info.content;
    }
    
}

@end
