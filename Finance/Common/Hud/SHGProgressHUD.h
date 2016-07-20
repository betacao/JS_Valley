//
//  SHGProgressHUD.h
//  Finance
//
//  Created by changxicao on 16/3/21.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SHGProgressHUDType)
{
    SHGProgressHUDTypeNormal = 0,
    SHGProgressHUDTypeGray
};

@interface SHGProgressHUD : UIView

@property (assign, nonatomic) BOOL shouldAutoMediate;

@property (assign, nonatomic) SHGProgressHUDType type;

- (void)startAnimation;

- (void)stopAnimation;

- (CGSize)SHGProgressHUDSize;

@end
