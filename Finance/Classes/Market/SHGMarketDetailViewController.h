//
//  SHGMarketDetailViewController.h
//  Finance
//
//  Created by changxicao on 15/12/12.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SHGMarketObject.h"

@protocol SHGMarketStateDelegate <NSObject>

- (void)updateToNewestMarket:(SHGMarketObject *)object;

@end

@interface SHGMarketDetailViewController : BaseTableViewController
@property (strong, nonatomic) SHGMarketObject *object;
@property (weak, nonatomic) id<SHGMarketStateDelegate> delegate;
@end
