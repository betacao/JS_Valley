//
//  SHGBusinessCommentTableViewCell.h
//  Finance
//
//  Created by changxicao on 16/4/14.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGBusinessObject.h"
typedef NS_ENUM(NSInteger, SHGBusinessCommentType)
{
    SHGBusinessCommentTypeFirst = 0,
    SHGBusinessCommentTypeNormal,
    SHGBusinessCommentTypeLast
};

@protocol SHGBusinessCommentDelegate<NSObject>
-(void)leftUserClick:(NSInteger)index;
-(void)rightUserClick:(NSInteger)index;
@end

@interface SHGBusinessCommentTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;

@property (nonatomic,weak)id<SHGBusinessCommentDelegate> delegate;
- (void)loadUIWithObj:(SHGBusinessCommentObject *)comobj commentType:(SHGBusinessCommentType)type;
@end

