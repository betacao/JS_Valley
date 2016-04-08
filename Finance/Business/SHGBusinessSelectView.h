//
//  SHGBusinessSelectView.h
//  Finance
//
//  Created by weiqiankun on 16/4/7.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SHGReturnTextBlock)(NSString *showText);

@interface SHGBusinessSelectView : UIView
- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array;

@property (nonatomic, copy) SHGReturnTextBlock returnTextBlock;

@end
