//
//  SHGMainPageTableViewCell.h
//  Finance
//
//  Created by changxicao on 16/3/8.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleListDelegate.h"
#import "MLEmojiLabel.h"

@interface SHGMainPageTableViewCell : UITableViewCell

@property (weak, nonatomic) UIViewController<MLEmojiLabelDelegate> *controller;
@property (assign ,nonatomic) NSInteger index;

@property (weak, nonatomic) id<CircleListDelegate> delegate;

@property (strong ,nonatomic) CircleListObj *object;

@end
