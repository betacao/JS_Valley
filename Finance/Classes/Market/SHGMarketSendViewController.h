//
//  SHGMarketSendViewController.h
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SHGMarketObject.h"

@protocol SHGMarketSendDelegate <NSObject>

- (void)didCreateNewMarket:(SHGMarketFirstCategoryObject *)object;

@end

@interface SHGMarketSendViewController : BaseViewController

@property (strong, nonatomic) SHGMarketObject *object;
@property (assign, nonatomic) id<SHGMarketSendDelegate> delegate;

@end
