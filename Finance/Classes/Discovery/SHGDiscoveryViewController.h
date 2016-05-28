//
//  SHGDiscoveryViewController.h
//  Finance
//
//  Created by changxicao on 16/5/24.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGCategoryButton.h"

@interface SHGDiscoveryViewController : BaseViewController

+ (instancetype)sharedController;

- (void)loadData;

@property (strong, nonatomic) UILabel *titleLabel;

@end

@interface SHGDiscoveryMyContactCell : UITableViewCell
//决定是不是显示邀请好友
@property (assign, nonatomic) BOOL hideInvateButton;

@property (strong, nonatomic) NSArray *effctiveArray;

@end

@interface SHGDiscoveryContactExpandCell : UITableViewCell

@end

@interface SHGDiscoveryCategoryButton : UIButton

@property (strong, nonatomic) id object;

- (void)setAttributedTitle:(NSAttributedString *)title image:(UIImage *)image;

@end