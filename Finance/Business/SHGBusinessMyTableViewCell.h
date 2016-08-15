//
//  SHGBusinessMyTableViewCell.h
//  Finance
//
//  Created by weiqiankun on 16/8/12.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGBusinessObject.h"

@protocol SHGBusinessMyTableViewDelegate <NSObject>

- (void)goToEditBusiness:(SHGBusinessObject *)object;

@end

@interface SHGBusinessMyTableViewCell : UITableViewCell
@property (strong, nonatomic) NSArray *array;
@property (nonatomic, assign) id<SHGBusinessMyTableViewDelegate>delegate;
@end
