//
//  SHGEmptyDataView.h
//  Finance
//
//  Created by changxicao on 15/12/5.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SHGEmptyDateType) {
    SHGEmptyDateNormal = 0,//普通的无数据
    SHGEmptyDateMarketDeleted = 1,
    SHGEmptyDateBusinessDeleted = 2,
    SHGEmptyDateDiscoverySearch = 3
};

@interface SHGEmptyDataView : UIView

@property (assign, nonatomic) SHGEmptyDateType type;

@end
