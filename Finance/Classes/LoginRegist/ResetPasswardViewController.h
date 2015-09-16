//
//  ResetPasswardViewController.h
//  Finance
//
//  Created by HuMin on 15/5/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "RegistViewController.h"

typedef NS_ENUM(NSInteger, CodeType)
{
    CodeInit = 0,//未发送验证码
    CodeInTime = 1,//已发送验证码
    CodeOverTime = 2,//验证码过时
};

@interface ResetPasswardViewController : BaseViewController
@property (nonatomic, strong) NSString *phone;

@end
