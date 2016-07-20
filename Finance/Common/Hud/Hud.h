//
//  Hud.h
//  Finance
//
//  Created by HuMin on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hud : NSObject

+ (void)showWait;

+ (void)showGrayWait;

+ (void)hideHud;

+ (void)showMessageWithText:(NSString *)text;

@end
