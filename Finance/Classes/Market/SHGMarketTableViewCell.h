//
//  SHGMarketTableViewCell.h
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGMarketObject.h"
#define kMarketCellHeight 166.0f

@protocol SHGMarketTableViewDelegate <NSObject>

- (void)clickPrasiseButton:(SHGMarketObject *)object;
- (void)clickCommentButton:(SHGMarketObject *)object;
- (void)clickEditButton:(SHGMarketObject *)object;
- (void)tapUserHeaderImageView:(NSString *)uid;

@end

@interface SHGMarketTableViewCell : UITableViewCell
@property (assign, nonatomic) id<SHGMarketTableViewDelegate> delegate;
- (void)loadDataWithObject:(SHGMarketObject *)object;

@end
