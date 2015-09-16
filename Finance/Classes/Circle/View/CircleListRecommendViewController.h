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


@interface CircleListRecommendViewController : UIViewController<CircleListDelegate>

@property (assign ,nonatomic) id<CircleListDelegate> delegate;

- (void)loadViewWithData:(NSArray *)dataArray cityCode:(NSString *)currentCity;

- (CGFloat)heightOfView;

@end
