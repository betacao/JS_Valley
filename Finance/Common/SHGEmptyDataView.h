//
//  SHGEmptyDataView.h
//  Finance
//
//  Created by changxicao on 15/12/5.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SHGEmptyDateType) {
    SHGEmptyDateTypeNormal = 0,//普通的无数据
    SHGEmptyDateTypeMarketDeleted = 1,
    SHGEmptyDateTypeBusinessDeleted = 2,
    SHGEmptyDateTypeMarketEmptyRecommended
};
typedef void(^SHGEmptyDataViewBlock)(NSDictionary *dictionary);
@interface SHGEmptyDataView : UIView

@property (assign, nonatomic) SHGEmptyDateType type;
@property (copy, nonatomic) SHGEmptyDataViewBlock block;
@end
