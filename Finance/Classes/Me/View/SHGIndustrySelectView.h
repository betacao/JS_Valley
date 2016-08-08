//
//  SHGIndustrySelectView.h
//  Finance
//
//  Created by weiqiankun on 16/8/8.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SHGInsustryReturnTextBlock)(NSString *text);

@interface SHGIndustrySelectView : UIView
- (instancetype)initWithFrame:(CGRect)frame andSelctIndustry:(NSString *)industry;
@property (nonatomic, copy) SHGInsustryReturnTextBlock returnTextBlock;

@end
