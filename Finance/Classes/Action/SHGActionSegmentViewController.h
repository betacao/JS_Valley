//
//  SHGActionSegmentViewController.h
//  Finance
//
//  Created by changxicao on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGActionSendViewController.h"
#import "SHGActionSignViewController.h"
#import "SHGActionDetailViewController.h"

@interface SHGActionSegmentViewController : BaseViewController<SHGActionSendDelegate, SHGActionAddCommentDelegate>

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;
+ (instancetype)sharedSegmentController;
- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setSelectedViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)addOrDeletePraise:(SHGActionObject *)object block:(void(^)(BOOL success))block;
@end
