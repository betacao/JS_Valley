//
//  SHGMarketTableViewCell.h
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGMarketObject.h"
#define kMarketCellHeight 200.0f

@interface SHGMarketTableViewCell : UITableViewCell

- (void)loadDataWithObject:(SHGMarketObject *)object;

@end
