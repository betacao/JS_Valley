//
//  SHGModifyUserInfoViewController.h
//  Finance
//
//  Created by changxicao on 16/1/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"

#define kCompany        @"company"
#define kDepartment     @"department"
#define kNickName       @"name"
#define kIndustry        @"industry"
#define kLocation     @"location"
#define kHeaderImage       @"headerImage"
typedef void(^SHGModifyUserInfoBlock)(NSDictionary *info);
@interface SHGModifyUserInfoViewController : BaseViewController

@property (strong, nonatomic) NSDictionary *userInfo;
@property (copy, nonatomic) SHGModifyUserInfoBlock block;
@end
