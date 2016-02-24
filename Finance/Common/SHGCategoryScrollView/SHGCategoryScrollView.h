//
//  SHGCategoryScrollView.h
//  Finance
//
//  Created by changxicao on 15/12/11.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCategoryScrollViewHeight MarginFactor(45.0f)

@protocol SHGCategoryScrollViewDelegate <NSObject>

- (void)didChangeToIndex:(NSInteger)index firstId:(NSString *)firstId secondId:(NSString *)secondId;

@end

@interface SHGCategoryScrollView : UIView

@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (assign, nonatomic) id<SHGCategoryScrollViewDelegate>categoryDelegate;

- (NSString *)marketFirstId;
- (NSString *)marketSecondId;
- (NSString *)marketName;
- (NSInteger)currentIndex;
- (void)moveToIndex:(NSInteger)index;
@end
