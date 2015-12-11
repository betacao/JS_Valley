//
//  MLKMenuPopover1.h
//  MLKMenuPopover1
//
//  Created by NagaMalleswar on 20/11/14.
//  Copyright (c) 2014 NagaMalleswar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLKMenuPopover1;

@protocol MLKMenuPopover1Delegate

- (void)menuPopover1:(MLKMenuPopover1 *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex;

@end

@interface MLKMenuPopover1 : UIView <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property(nonatomic,assign) id<MLKMenuPopover1Delegate> menuPopoverDelegate;
@property (nonatomic, assign)BOOL isshow;
- (id)initWithFrame:(CGRect)frame menuItems:(NSArray *)menuItems;
- (void)showInView:(UIView *)view;
- (void)dismissMenuPopover;
- (void)layoutUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

