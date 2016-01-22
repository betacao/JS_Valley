//
//  SHGMarketSegmentViewController.h
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGMarketObject.h"
#import "SHGMarketDetailViewController.h"
#import "SHGMarketSendViewController.h"

typedef void(^loadViewFinishBlock)(UIView *view);

@interface SHGMarketSegmentViewController : UIViewController<SHGMarketSendDelegate, SHGMarketStateDelegate>

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (strong ,nonatomic, readonly) NSArray *rightBarButtonItems;
@property (strong ,nonatomic, readonly) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, copy) loadViewFinishBlock block;

+ (instancetype)sharedSegmentController;
- (void)changeTitleCityName:(NSString *)name;
- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setSelectedViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)refreshListViewController;
- (void)addOrDeletePraise:(SHGMarketObject *)object block:(void(^)(BOOL success))block;
- (void)deleteMarket:(SHGMarketObject *)object;
@end
