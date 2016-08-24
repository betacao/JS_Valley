//
//  SHGBaseSegmentViewController.h
//  Finance
//
//  Created by changxicao on 16/8/24.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"

@interface SHGBaseSegmentViewController : BaseViewController

@property (strong, nonatomic) NSArray *viewControllers;
@property (assign, nonatomic) NSUInteger selectedIndex;

- (void)initView;
- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

@end
