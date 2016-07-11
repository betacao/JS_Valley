//
//  LinkViewController.h
//  Finance
//
//  Created by lizeng on 15/7/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "CircleListObj.h"

@interface LinkViewController : BaseViewController

@property (strong,nonatomic) NSString *url;
@property (strong, nonatomic) CircleListObj *object;
@property (strong, nonatomic) NSString *linkTitle;
@end
