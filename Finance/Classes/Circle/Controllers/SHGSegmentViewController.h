//
//  SHGSegmentViewController.h
//  Finance
//
//  Created by changxicao on 15/11/3.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHGSegmentControllerDelegate;


@interface SHGSegmentViewController : UIViewController
@property (nonatomic, weak) id <SHGSegmentControllerDelegate> delegate;

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setSelectedViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end

@protocol SHGSegmentControllerDelegate <NSObject>
@optional
- (BOOL)SHGTabBarController:(SHGSegmentViewController *)segmentController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
- (void)SGGTabBarController:(SHGSegmentViewController *)segmentController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
@end
