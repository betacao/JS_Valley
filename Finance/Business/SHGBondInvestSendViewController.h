//
//  SHGBondFinancingSendViewController.h
//  Finance
//
//  Created by weiqiankun on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGBusinessObject.h"
typedef NS_ENUM(NSInteger, SHGBusinessSendType){
    SHGBusinessSendTypeNew = 0,
    SHGBusinessSendTypeReSet = 1
};
@interface SHGBondInvestSendViewController : BaseViewController
@property (strong, nonatomic) NSDictionary *firstDic;
@property (strong, nonatomic) SHGBusinessObject *object;
@property (assign, nonatomic) SHGBusinessSendType sendType;

@end
