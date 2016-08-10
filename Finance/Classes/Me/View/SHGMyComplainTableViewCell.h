//
//  SHGMyComplainTableViewCell.h
//  Finance
//
//  Created by weiqiankun on 16/8/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGMyComplianObject.h"

@interface SHGMyComplainTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL firstTopLine;
@property (nonatomic, assign) BOOL lastBottomLine;
@property(nonatomic, strong) SHGMyComplianObject *object;

@end
