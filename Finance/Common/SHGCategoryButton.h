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
@interface SHGHorizontalTitleImageButton : UIButton

@property (assign, nonatomic) CGFloat margin;
@end