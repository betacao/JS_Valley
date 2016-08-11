//
//  SHGEmptyDataView.h
//  Finance
//
//  Created by changxicao on 15/12/5.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SHGEmptyDataType) {
    SHGEmptyDataNormal = 0,//普通的无数据
    SHGEmptyDataMarketDeleted = 1,
    SHGEmptyDataBusinessDeleted = 2,
    SHGEmptyDataDiscoverySearch = 3,
    SHGEmptyDataCompanySearch = 4
};

@interface SHGEmptyDataView : UIView

@property (assign, nonatomic) SHGEmptyDataType type;

@end
