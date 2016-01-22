//
//  SHGMarketNoticeTableViewCell.h
//  Finance
//
//  Created by changxicao on 16/1/22.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGMarketObject.h"

@interface SHGMarketNoticeTableViewCell : UITableViewCell
- (void)loadDataWithObject:(SHGMarketObject *)object block: (void(^)(CGFloat height))block;
@end
