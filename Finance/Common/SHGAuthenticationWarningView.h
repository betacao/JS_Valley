//
//  SHGAuthenticationWarningView.h
//  Finance
//
//  Created by changxicao on 16/6/22.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SHGAuthenticationWarningBlock)(void);

@interface SHGAuthenticationWarningView : UIView

@property (strong, nonatomic) NSString *text;

@property (copy, nonatomic) SHGAuthenticationWarningBlock block;

@end
