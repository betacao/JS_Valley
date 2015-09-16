//
//  SettingsObj.h
//  DingDCommunity
//
//  Created by JianjiYuan on 14-4-3.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsObj : NSObject

@property (nonatomic, strong)  NSString *imageInfo;
@property (nonatomic, strong)  NSString *content;
@property (nonatomic, strong)  NSString *isShowSwith;//是否显示开关
@property (nonatomic, strong)  NSString *isOn;//开关状态

@end
