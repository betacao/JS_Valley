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
#define kMarketNoticeCellHeight (SCREENWIDTH * 206.0f) / 960.0f + 12.0f//加间隔

@protocol SHGMarketTableViewDelegate <NSObject>

- (void)clickPrasiseButton:(SHGMarketObject *)object;
- (void)clickCommentButton:(SHGMarketObject *)object;
- (void)clickEditButton:(SHGMarketObject *)object;
- (void)tapUserHeaderImageView:(NSString *)uid;
- (void)ClickCollectButton:(SHGMarketObject *)object;
@optional
- (void)clickDeleteButton:(SHGMarketObject *)object;
@end

@interface SHGMarketTableViewCell : UITableViewCell
@property (strong ,nonatomic) SHGMarketObject *object;
@property (assign, nonatomic) id<SHGMarketTableViewDelegate> delegate;
@end
