//
//  SHGRecommendCollectionViewCell.h
//  Finance
//
//  Created by weiqiankun on 16/4/26.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleListDelegate.h"
@interface SHGRecommendCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) id<CircleListDelegate> delegate;

@property (strong ,nonatomic) CircleListObj *object;

@end
