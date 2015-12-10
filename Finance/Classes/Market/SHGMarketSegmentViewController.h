//
//  SHGMarketSegmentViewController.h
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^loadViewFinishBlock)(UIView *view);

@interface SHGMarketSegmentViewController : BaseViewController

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (strong ,nonatomic, readonly) UIBarButtonItem *rightBarButtonItem;
@property (strong ,nonatomic, readonly) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, copy) loadViewFinishBlock block;

+ (instancetype)sharedSegmentController;
- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setSelectedViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end