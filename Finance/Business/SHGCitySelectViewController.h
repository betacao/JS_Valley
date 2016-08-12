//
//  SHGCitySelectViewController.h
//  Finance
//
//  Created by weiqiankun on 16/8/11.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^SHGReturnCityBlock)(NSString *showText);

@interface SHGCitySelectViewController : BaseViewController
@property (nonatomic, copy) SHGReturnCityBlock returnCityBlock;
@property (weak, nonatomic) UIViewController *superController;

@end

@interface SHGCitySelectTableViewCell : UITableViewCell
@property (strong, nonatomic) NSString *city;

@end
