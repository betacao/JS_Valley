//
//  SHGMomentCityViewController.h
//  Finance
//
//  Created by weiqiankun on 16/1/19.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol SHGMomentCityDelegate <NSObject>
- (void)didSelectCity:(NSString *)city;
@end
@interface SHGMomentCityViewController : BaseTableViewController

@property (assign, nonatomic) id<SHGMomentCityDelegate> delegate;
@end
