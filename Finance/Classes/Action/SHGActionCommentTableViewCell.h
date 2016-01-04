//
//  SHGActionCommentTableViewCell.h
//  Finance
//
//  Created by changxicao on 15/11/20.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGActionObject.h"
typedef NS_ENUM(NSInteger, SHGActionCommentType)
{
    SHGActionCommentTypeFirst = 0,
    SHGActionCommentTypeNormal,
    SHGActionCommentTypeLast
};

@protocol SHGActionCommentDelegate<NSObject>
- (void)leftUserClick:(NSInteger)index;
- (void)rightUserClick:(NSInteger)index;
@end

@interface SHGActionCommentTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;

@property (nonatomic,weak)id<SHGActionCommentDelegate> delegate;
- (void)loadUIWithObj:(SHGActionCommentObject *)comobj commentType:(SHGActionCommentType)type;
@end
