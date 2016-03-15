//
//  SHGMarketTableViewCell.h
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGMarketObject.h"

typedef NS_ENUM(NSInteger, SHGMarketTableViewCellType) {
    SHGMarketTableViewCellTypeAll = 0,
    SHGMarketTableViewCellTypeMine,
    SHGMarketTableViewCellTypeOther
};
@protocol SHGMarketTableViewDelegate <NSObject>

- (void)clickCollectButton:(SHGMarketObject *)object state:(void(^)(BOOL state))block;
@optional
- (void)clickPrasiseButton:(SHGMarketObject *)object;
- (void)clickCommentButton:(SHGMarketObject *)object;
- (void)clickEditButton:(SHGMarketObject *)object;
- (void)clickDeleteButton:(SHGMarketObject *)object;
@end

@interface SHGMarketTableViewCell : UITableViewCell
@property (strong ,nonatomic) SHGMarketObject *object;
@property (assign, nonatomic) id<SHGMarketTableViewDelegate> delegate;
- (void)loadNewUiFortype:(SHGMarketTableViewCellType)type;

@end
