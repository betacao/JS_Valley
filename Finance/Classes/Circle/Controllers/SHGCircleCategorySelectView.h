//
//  SHGCircleCategorySelectView.h
//  Finance
//
//  Created by changxicao on 16/8/17.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SHGCircleCategorySelectBlock)(NSString *string);

@interface SHGCircleCategorySelectView : UIView

@property (copy, nonatomic) SHGCircleCategorySelectBlock block;

@end
