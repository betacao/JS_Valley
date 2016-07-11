//
//  SHGMainPageTableViewCell.h
//  Finance
//
//  Created by changxicao on 16/3/8.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGBusinessObject.h"
#import "CircleListDelegate.h"

@interface SHGMainPageTableViewCell : UITableViewCell

@property (assign ,nonatomic) NSInteger index;

@property (weak, nonatomic) id<CircleListDelegate> delegate;

@property (strong ,nonatomic) CircleListObj *object;

@end


@interface SHGMainPageBusinessView : UIView

@property (strong, nonatomic) SHGBusinessObject *object;

@end