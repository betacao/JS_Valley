//
//  SHGRecommendTableViewCell.h
//  Finance
//
//  Created by changxicao on 16/3/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleListDelegate.h"

@interface SHGRecommendTableViewCell : UITableViewCell<CircleListDelegate>

@property (strong, nonatomic) NSArray *objectArray;
@property (weak, nonatomic) UIViewController *controller;
@property (assign ,nonatomic) id<CircleListDelegate> delegate;
@property (strong, nonatomic) NSString *attentionState;
@end
