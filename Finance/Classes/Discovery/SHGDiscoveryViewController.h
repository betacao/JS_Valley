//
//  SHGDiscoveryViewController.h
//  Finance
//
//  Created by changxicao on 16/5/24.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"

@interface SHGDiscoveryViewController : BaseViewController

@end

@interface SHGDiscoveryMyContactCell : UITableViewCell

@property (strong, nonatomic) NSArray *effctiveArray;

@property (weak, nonatomic) SHGDiscoveryViewController *controller;

@end

@interface SHGDiscoveryContactExpandCell : UITableViewCell

@end

@interface SHGDiscoveryContactRecommendView : UIView

@end

@interface SHGDiscoveryCategoryButton : UIButton

- (void)setTitle:(NSString *)title image:(UIImage *)image;
- (void)setAttributedTitle:(NSAttributedString *)title image:(UIImage *)image;

@end