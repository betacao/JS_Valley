//
//  SHGBusinessCategoryContentView.h
//  Finance
//
//  Created by changxicao on 16/4/8.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHGBusinessButtonContentView : UIView
@property (strong, nonatomic) NSMutableArray *buttonArray;

- (void)didClickButton:(UIButton *)button;

@end
