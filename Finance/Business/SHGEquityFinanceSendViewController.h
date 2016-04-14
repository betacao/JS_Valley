//
//  SHGEquityFinanceSendViewController.h
//  Finance
//
//  Created by weiqiankun on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGBusinessObject.h"
typedef NS_ENUM(NSInteger, SHGEquityFinaceSendType){
    SHGEquityFinaceSendTypeNew = 0,
    SHGEquityFinaceSendTypeReSet = 1
};

@interface SHGEquityFinanceSendViewController : BaseViewController
@property (strong, nonatomic) NSDictionary *firstDic;
@property (strong, nonatomic) SHGBusinessObject *object;
@property (assign, nonatomic) SHGEquityFinaceSendType sendType;
@end
