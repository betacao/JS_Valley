//
//  SHGBondFinanceViewController.h
//  Finance
//
//  Created by weiqiankun on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGBusinessObject.h"
typedef NS_ENUM(NSInteger, SHGBondFinaceSendType){
    SHGBondFinaceSendTypeNew = 0,
    SHGBondFinaceSendTypeReSet = 1
};
@interface SHGBondFinanceSendViewController : BaseViewController
@property (strong, nonatomic) NSDictionary *firstDic;
@property (strong, nonatomic) SHGBusinessObject *object;
@property (assign, nonatomic) SHGBondFinaceSendType sendType;
@end
