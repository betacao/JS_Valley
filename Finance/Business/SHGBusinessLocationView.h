//
//  SHGBusinessLocationView.h
//  Finance
//
//  Created by weiqiankun on 16/4/12.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGBondFinanceSendViewController.h"
typedef void (^SHGReturnLocationBlock)(NSString *showText);

@interface SHGBusinessLocationView : UIView
@property (nonatomic, copy) SHGReturnLocationBlock returnLocationBlock;
@property (nonatomic, strong) NSString *currentButtonString;
@end
