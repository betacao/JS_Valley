//
//  SHGRecommendView.h
//  Finance
//
//  Created by changxicao on 16/5/27.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHGRecommendCollectionView : UIView

@property (strong, nonatomic) NSArray *dataArray;

@property (assign, nonatomic) CGFloat totalHeight;

@property (assign, nonatomic) BOOL scrollEnabled;

@end
