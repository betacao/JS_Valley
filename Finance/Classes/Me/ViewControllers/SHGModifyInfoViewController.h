//
//  SHGModifyInfoViewController.h
//  Finance
//
//  Created by changxicao on 15/9/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"

#define kCompany        @"company"
#define kDepartment     @"department"
#define kNickName       @"name"

@protocol ModifyInfoDelegate<NSObject>
@optional

- (void)didModifyUserInfo:(NSDictionary *)dictionary;

@end

@interface SHGModifyInfoViewController : BaseViewController

- (void)loadInitInfo:(NSDictionary *)dictionary;

@property (assign, nonatomic) id<ModifyInfoDelegate>delegate;

@end
