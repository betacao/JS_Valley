//
//  SHGProgressHUD.h
//  Finance
//
//  Created by changxicao on 16/3/21.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHGProgressHUD : UIView

@property (assign, nonatomic) BOOL shouldAutoMediate;

- (void)stopAnimation;

- (CGSize)SHGProgressHUDSize;

@end
