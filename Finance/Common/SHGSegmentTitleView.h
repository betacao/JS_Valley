//
//  SHGSegmentTitleView.h
//  Finance
//
//  Created by changxicao on 16/8/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SHGSegmentTitleViewBlock)(NSInteger index);

@interface SHGSegmentTitleView : UIView

@property (assign, nonatomic) CGFloat margin;//先设置margin 后给title
@property (strong, nonatomic) NSArray *titleArray;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (copy, nonatomic) SHGSegmentTitleViewBlock block;

@end
