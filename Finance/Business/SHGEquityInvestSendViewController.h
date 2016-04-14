//
//  SHGEquityInvestSendViewController.h
//  Finance
//
//  Created by weiqiankun on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGBusinessObject.h"
typedef NS_ENUM(NSInteger, SHGEquityInvestSendType){
    SHGEquityInvestSendTypeNew = 0,
    SHGEquityInvestSendTypeReSet = 1
};

@interface SHGEquityInvestSendViewController : BaseViewController
@property (strong, nonatomic) NSDictionary *firstDic;
@property (strong, nonatomic) SHGBusinessObject *object;
@property (assign, nonatomic) SHGEquityInvestSendType sendType;
@end
