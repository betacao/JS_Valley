//
//  UIButton+EnlargeEdge.h
//  firstDemo
//
//  Created by changxicao on 15/9/14.
//  Copyright (c) 2015年 changxicao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGBadgeView.h"

@interface UIButton (EnlargeEdge)

- (void)setEnlargeEdge:(CGFloat) size;
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end

@interface UIButton (Badge)

- (void)setBadgeNumber:(NSString *)number;
- (void)removeBadgeNumber;

@end
