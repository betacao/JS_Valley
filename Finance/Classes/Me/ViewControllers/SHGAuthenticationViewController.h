//
//  SHGAuthenticationViewController.h
//  Finance
//
//  Created by 魏虔坤 on 15/11/17.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"

@interface SHGAuthenticationViewController : BaseViewController
@property (assign, nonatomic) BOOL authState;
@end


@interface SHGAuthenticationNextViewController : BaseViewController

@property (strong, nonatomic) NSString *headerImageUrl;
@property (strong, nonatomic) NSString *authImageUrl;
@property (strong, nonatomic) UIImage *headerImage;
@property (strong, nonatomic) NSString *departmentCode;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) UIImage *authImage;
@property (strong, nonatomic) NSString *company;//保存一下 没什么用

@property (strong, nonatomic) NSString *licenseUrl;

@end