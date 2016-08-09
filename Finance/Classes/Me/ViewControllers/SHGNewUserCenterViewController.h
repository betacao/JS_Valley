//
//  SHGNewUserCenterViewController.h
//  Finance
//
//  Created by changxicao on 16/8/8.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"

@interface SHGNewUserCenterViewController : BaseTableViewController

@property (assign, nonatomic) NSInteger unReadNumber;

+ (instancetype)sharedController;

@end

@interface SHGUserCenterObject : NSObject

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *text;

@end

@interface SHGUserCenterTableViewCell : UITableViewCell

@property (strong, nonatomic) SHGUserCenterObject *object;

- (void)addViewToFrontView:(UIView *)view;
- (void)addViewTolastView:(UIView *)view;

@end