//
//  SHGBaseSegmentViewController.h
//  Finance
//
//  Created by changxicao on 16/8/15.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"

@interface SHGBaseSegmentViewController : BaseViewController

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;

- (void)initView;
- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated;

@end
