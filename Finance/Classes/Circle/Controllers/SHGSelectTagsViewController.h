//
//  SHGSelectTagsViewController.h
//  Finance
//
//  Created by changxicao on 15/11/17.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHGSelectTagsViewController : UIViewController

+ (instancetype)shareTagsViewController;

@end

@interface SHGHomeTagsView : UIView

- (void)updateSelectedArray;

- (NSArray *)userSelectedTags;

@end