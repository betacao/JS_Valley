//
//  SHGCategoryButton.h
//  Finance
//
//  Created by changxicao on 16/4/11.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHGCategoryButton : UIButton

@property (strong, nonatomic) id object;

@end

//必须先设置图片，再设置文字
@interface SHGHorizontalTitleImageView : UIView

@property (assign, nonatomic) CGFloat margin;

- (void)addImage:(UIImage *)image;
- (void)addTitle:(NSString *)title;
- (void)target:(id)target addSeletor:(SEL)selector;

- (void)setEnlargeEdge:(CGFloat) size;
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end