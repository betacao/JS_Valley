//
//  SHGMarketCommentTableViewCell.h
//  Finance
//
//  Created by changxicao on 15/11/20.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGMarketObject.h"
typedef NS_ENUM(NSInteger, SHGMarketCommentType)
{
    SHGMarketCommentTypeFirst = 0,
    SHGMarketCommentTypeNormal,
    SHGMarketCommentTypeLast
};

@protocol SHGMarketCommentDelegate<NSObject>
-(void)leftUserClick:(NSInteger)index;
-(void)rightUserClick:(NSInteger)index;
@end

@interface SHGMarketCommentTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;

@property (nonatomic,weak)id<SHGMarketCommentDelegate> delegate;
- (void)loadUIWithObj:(SHGMarketCommentObject *)comobj commentType:(SHGMarketCommentType)type;
@end
