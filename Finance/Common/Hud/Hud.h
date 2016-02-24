//
//  Hud.h
//  Finance
//
//  Created by HuMin on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hud : NSObject
+ (void)showLoadingWithMessage:(NSString *)message;
+ (void)showMessageWithText:(NSString *)text;
+ (void)showMessageWithLongText:(NSString *)text;
+ (void)showMessageWithCustomView:(UIView *)customView;
+ (void)hideHud;
@end
