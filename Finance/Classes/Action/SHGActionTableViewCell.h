//
//  SHGActionTableViewCell.h
//  Finance
//
//  Created by 魏虔坤 on 15/11/12.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGActionObject.h"
#define kActionCellHeight 251.0f

@protocol SHGActionTableViewDelegate <NSObject>

- (void)clickPrasiseButton:(SHGActionObject *)object;
- (void)clickCommentButton:(SHGActionObject *)object;
- (void)clickEditButton:(SHGActionObject *)object;

@end

@interface SHGActionTableViewCell : UITableViewCell

@property (assign, nonatomic) id<SHGActionTableViewDelegate> delegate;
- (void)loadDataWithObject:(SHGActionObject *)object;


@end
