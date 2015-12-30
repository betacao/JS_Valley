//
//  CircleListRecommendViewController.h
//  Finance
//
//  Created by changxicao on 15/8/20.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecmdFriendObj.h"
#import "CircleListDelegate.h"

typedef void(^SHGRecommendBlock)(void);

@interface CircleListRecommendViewController : UIViewController<CircleListDelegate>

@property (assign ,nonatomic) id<CircleListDelegate> delegate;
@property (copy, nonatomic) SHGRecommendBlock closeBlock;
- (void)loadViewWithData:(NSArray *)dataArray;

- (CGFloat)heightOfView;

@end
