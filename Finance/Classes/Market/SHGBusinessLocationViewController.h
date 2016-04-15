//
//  SHGBusinessLocationViewController.h
//  Finance
//
//  Created by weiqiankun on 16/3/30.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"

@interface SHGBusinessLocationViewController : BaseViewController
+ (instancetype)sharedController;
@property (nonatomic, strong) NSString *locationString;
@end
