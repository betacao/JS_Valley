//
//  SHGSameAndCommixtureSendViewController.h
//  Finance
//
//  Created by weiqiankun on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGBusinessObject.h"
typedef NS_ENUM(NSInteger, SHGSameAndCommixtureSendType){
    SHGSameAndCommixtureSendTypeNew = 0,
    SHGSameAndCommixtureSendTypeReSet = 1
};

@interface SHGSameAndCommixtureSendViewController : BaseViewController
@property (strong, nonatomic) NSDictionary *firstDic;
@property (strong, nonatomic) SHGBusinessObject *object;
@property (assign, nonatomic) SHGSameAndCommixtureSendType sendType;
@end
