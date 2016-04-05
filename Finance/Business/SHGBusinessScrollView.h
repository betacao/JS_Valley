//
//  SHGBusinessScrollView.h
//  Finance
//
//  Created by changxicao on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBusinessScrollViewHeight MarginFactor(45.0f)

@protocol SHGBusinessScrollViewDelegate <NSObject>



@end

@interface SHGBusinessScrollView : UIView

@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (assign, nonatomic) id<SHGBusinessScrollViewDelegate>categoryDelegate;

- (NSInteger)currentIndex;
- (void)moveToIndex:(NSInteger)index;

@end

@interface SHGBusinessFilterView : UIView

@end