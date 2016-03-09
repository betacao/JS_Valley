//
//  BasePeopleTableViewCell.h
//  Finance
//
//  Created by Okay Hoo on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePeopleObject.h"

@protocol BasePeopleTableViewCellDelegate <NSObject>

@optional
- (void)followButtonClicked:(BasePeopleObject *)obj;

@end

@interface BasePeopleTableViewCell : UITableViewCell

@property (nonatomic, strong) BasePeopleObject *object;
@property (nonatomic, weak) id<BasePeopleTableViewCellDelegate> delegate;


@end
